//
//  TCreateTournamentVC.m
//  Tournament
//
//  Created by Eugene Heckert on 6/25/15.
//  Copyright (c) 2015 Eugene Heckert. All rights reserved.
//

#import "TCreateTournamentVC.h"
#import "TParticipantView.h"
#import "Tournament.h"
#import "User.h"
#import "Match.h"
#import "Participant.h"

#define ASSIGNED_MATCH_KEY                          @"assign Match Key"

#define AUTO_CREATE_PARTICIPANTS_COUNT              0

@interface TCreateTournamentVC ()

@property (nonatomic, strong) NSMutableArray* participantList;

@property (nonatomic, strong) NSMutableArray* participantNameList;

@property (nonatomic, strong) NSMutableArray* matchList;

@property (nonatomic, strong) NSString* tournamentName;

@property (nonatomic, strong) NSString* tournamentType;

@property (nonatomic, strong) Tournament* currentTournament;

@property (nonatomic, assign) CGRect nextParticipantViewFrame;

@property (nonatomic, assign) int participantID;

@property (nonatomic, assign) int roundCounter;

@end

@implementation TCreateTournamentVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"CREATE TOURNAMENT";
    
    self.participantList = [NSMutableArray new];
    
    self.participantNameList = [NSMutableArray new];
    
    self.matchList = [NSMutableArray new];
    
    self.participantID = 0;
    
    NSArray* tournamentNames = [TNetworkManager sharedInstance].user.tournamentNames;
    
    BOOL needsTitle = NO;
    NSInteger tournamentNumber = 0;
    NSString* possibleName;
    
    /*This is used to create a possible tournament name. We want to avoid Tournaments with the same name.*/
    do
    {
        tournamentNumber++;
        
        needsTitle = NO;
        
        possibleName = [NSString stringWithFormat:@"Tournament %02li", tournamentNumber];
        
        if([tournamentNames containsObject:possibleName])
        {
            needsTitle = YES;
        }
        
    }while(needsTitle);
    
    self.tournamentName = possibleName;
    
    self.tournamentType = @"Single Elimination";
    
    self.tournamentTypeLabel.text = [NSString stringWithFormat:@"Current Tournament Type: %@", self.tournamentType];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    TParticipantView* participantView = [TParticipantView new];
    
    self.nextParticipantViewFrame = (CGRect){{0,1},{self.participantListView.frame.size.width, participantView.frame.size.height}};
    
#if DEBUG
    /*This allows for the creation of large tournaments without the need for having to hand enter
      each participant's name. The names will just be a number/*/
    for(int i = 0; i < AUTO_CREATE_PARTICIPANTS_COUNT;i++)
    {
        self.participantNameEntryTextField.text = [NSString stringWithFormat:@"%i",i];
        
        [self onAddParticipantAction:nil];
    }
#endif
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View Controller Methods

- (void) dismissKeyboard
{
    [self.tournamentNameTextField resignFirstResponder];
    [self.gameNameTextField resignFirstResponder];
    [self.participantNameEntryTextField resignFirstResponder];
}

#pragma mark - Tournament Helper Methods

- (NSDictionary*) createMatchWtihID:(NSString*)matchID PlayerOneID:(NSString*)playerOneID PlayerTwoID:(NSString*)playerTwoID PlayerOnePreReqMatch:(NSString*)playerOnePreReqMatch PlayerTwoPreReqMatch:(NSString*)playerTwoPreReqMatch PlayerOnePreReqMatchLoser:(BOOL)playerOneMatchLoser PlayerTwoPreReqMatchLoser:(BOOL)playerTwoMatchLoser
{
    return @{
             @"matchID":matchID,
             @"matchState":@"pending",
             @"round":[NSNumber numberWithInt: self.roundCounter],
             @"playerOneID":playerOneID,
             @"playerTwoID":playerTwoID,
             @"playerOneScore":[NSNumber numberWithInt: 0],
             @"playerTwoScore":[NSNumber numberWithInt: 0],
             @"playerOnePreReqMatchID":playerOnePreReqMatch,
             @"playerTwoPreReqMatchID":playerTwoPreReqMatch,
             @"playerOnePreReqMatchLoser":@(playerOneMatchLoser),
             @"playerTwoPreReqMatchLoser":@(playerTwoMatchLoser),
             @"winnerID":@"",
             @"loserID":@""
             };
}

- (NSMutableDictionary*) getNextParticipant
{
    
    for(int i = 0; i < [self.participantList count];i++)
    {
        NSMutableDictionary* tempParticipant = self.participantList[i];
        
        if(![[tempParticipant valueForKey:ASSIGNED_MATCH_KEY] boolValue])
        {
            return tempParticipant;
        }
    }
    
    return [NSMutableDictionary new];
}

- (BOOL) isPowerOfTwo:(int) x
{
    return ((x != 0) && !(x & (x-1)));
}

#pragma mark - Create Tournaments

- (void) createTournament
{
    [self dismissKeyboard];
    
    /*You need atleast two people to have a tournament. More would be better but not required.*/
    if([self.participantList count] < 2)
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"You cannot create a tournament without any participants. Please add some now." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action)
                                   {
                                   }];
        
        [alert addAction:okAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    /*When creating a tournament you want to create it with a PFObject
      this is due to the fact that it will allow parse to lazily create
      the class and you don't have to.
      If you want to use the Tournament model object for the creation of 
      a tournament you will need to first create the class with all the
      matching fields.*/
    PFObject* tournament = [PFObject objectWithClassName:@"Tournament"];
    
    tournament[@"name"] = self.tournamentName;
    
    if(self.gameNameTextField.text.length > 0)
    {
        tournament[@"gameName"] = self.gameNameTextField.text;
    }
    else
    {
        tournament[@"gameName"] = @"Unspecified game";
    }
    
    tournament[@"tournamentType"] = self.tournamentType;
    
    tournament[@"tournamentState"] = @"pending";
    
    tournament[@"createdBy"] = [TNetworkManager sharedInstance].user.username;
    
    if([[self.tournamentType uppercaseString] isEqualToString:[@"Single Elimination" uppercaseString]])
    {
        [self createSingleEliminationMatches];
    }
    else
    if([[self.tournamentType uppercaseString] isEqualToString:[@"Double Elimination" uppercaseString]])
    {
        [self createDoubleEliminationMatches];
    }
    
    if([self.matchList count] <= 0)
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Was unable to create any matches." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action)
                                   {
                                   }];
        
        [alert addAction:okAction];
        
        return;
    }
    
    tournament[@"tournamentParticipantsDictAr"] = self.participantList;
    
    tournament[@"tournamentMatchesDictAr"] = self.matchList;
    
    tournament[@"maxNumberRounds"] = [NSNumber numberWithInt:self.roundCounter];
    
    tournament[@"participantsCount"] = [NSNumber numberWithInt:(int)[self.participantList count]];
    
    tournament[@"quickAdvance"] = @YES;
    
    [tournament saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
        if (succeeded)
        {
            //Update the list of Tournament names so that it can't be reused.
            [[TNetworkManager sharedInstance].user newTournamentName:tournament[@"name"]];
            
            /*No need to wait for this update since it only affects the possible name of tournaments
              and most users will not be making more then one tournament at a time.*/
            [[TNetworkManager sharedInstance].user saveEventually];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            // There was a problem, check error.description
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error" message:[error description] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *action)
                                       {
                                       }];
            
            [alert addAction:okAction];
        }
    }];
    
}

#pragma mark - Single Elimination Matches

- (void) createSingleEliminationMatches
{
    int participantCount = (int)[self.participantList count];
    int preReqMatchCoutner = 0;
    int matchID = 0;
    int numberToEliminateRoundOne = 0;
    int numberOfByes = 0;
    
    self.roundCounter = 0;
    
    /*For the tournament to work correctly you need a number of participants
      that are a power of two. If the number of participants are not a power
      of two you will need to find the humber of people who need to be eliminated
      in round one so that round two is a power of two.*/
    while (![self isPowerOfTwo:participantCount])
    {
        numberToEliminateRoundOne++;
        participantCount--;
        
    };
    
    /*If you need to Elimination people you can safly assume that for each person
      who you need to eliminate you will have a round one match. After which all 
      remaining players will get a bye to round two.*/
    if(numberToEliminateRoundOne)
    {
        numberOfByes = (participantCount - numberToEliminateRoundOne);
        
        self.roundCounter++;
        
        for(int i = 0,j = 0;j < numberToEliminateRoundOne;i += 2,j++)
        {
            NSMutableDictionary* playerOne;
            NSMutableDictionary* playerTwo;
            NSString* playerOnePreReqMatch = @"";
            NSString* playerTwoPreReqMatch = @"";
            NSDictionary* match = @{};
            
            playerOne = [self getNextParticipant];
            
            [playerOne setValue:@YES forKey:ASSIGNED_MATCH_KEY];
            
            playerTwo = [self getNextParticipant];
            
            [playerTwo setValue:@YES forKey:ASSIGNED_MATCH_KEY];
            
            playerOnePreReqMatch = @"";
            playerTwoPreReqMatch = @"";
            
            match = [self createMatchWtihID:[NSString stringWithFormat:@"%i", matchID] PlayerOneID:playerOne[@"participantID"] PlayerTwoID:playerTwo[@"participantID"] PlayerOnePreReqMatch:playerOnePreReqMatch PlayerTwoPreReqMatch:playerTwoPreReqMatch PlayerOnePreReqMatchLoser:NO PlayerTwoPreReqMatchLoser:NO];
            
            DLog(@"match: %@", match);
            
            [self.matchList addObject:match];
            
            matchID += 1;
        }
    }
    
    /*This makes the rest of the tournament's matches.*/
    do
    {
        self.roundCounter++;
        
        for(int i = 0; i < participantCount;i += 2)
        {
            NSMutableDictionary* playerOne;
            NSMutableDictionary* playerTwo;
            NSString* playerOnePreReqMatch = @"";
            NSString* playerTwoPreReqMatch = @"";
            NSString* playerOneID = @"";
            NSString* playerTwoID = @"";
            NSDictionary* match = @{};
            
            /*If you did not need to eliminate anyone the first round this will
              make round one matches. Round one matches are different from other
              matches due to the fact they do not have prerequisite matches and 
              participants will be assigned to a match.*/
            if(self.roundCounter == 1)
            {
                playerOne = [self getNextParticipant];
                
                [playerOne setValue:@YES forKey:ASSIGNED_MATCH_KEY];
                
                playerTwo = [self getNextParticipant];
                
                [playerTwo setValue:@YES forKey:ASSIGNED_MATCH_KEY];
                
                playerOnePreReqMatch = @"";
                playerTwoPreReqMatch = @"";
                
                playerOneID = playerOne[@"participantID"];
                playerTwoID = playerTwo[@"participantID"];
                
//                match = [self createMatchWtihID:[NSString stringWithFormat:@"%i", matchID] PlayerOneID:playerOne[@"participantID"] PlayerTwoID:playerTwo[@"participantID"] PlayerOnePreReqMatch:playerOnePreReqMatch PlayerTwoPreReqMatch:playerTwoPreReqMatch PlayerOnePreReqMatchLoser:NO PlayerTwoPreReqMatchLoser:NO];
            }
            else
            if(self.roundCounter == 2 && numberOfByes)
            {
                /*If the number of byes is less then the number of people to
                  eliminated in round one it means that two matchs will have 
                  to complete against each other to see advances to round two.
                  If the number of byes is greater then the number of participants
                  to eliminate then the winner of a match will face off against one
                  of the bye paticipants. If there enough byes some of them will be 
                  full matches and will act like normal.*/
                if(numberOfByes >= numberToEliminateRoundOne)
                {
                    if(numberToEliminateRoundOne > preReqMatchCoutner)
                    {
                        playerOne = (NSMutableDictionary*)[self getNextParticipant];
                        
                        [playerOne setValue:@YES forKey:ASSIGNED_MATCH_KEY];
                        
                        playerTwoPreReqMatch = [NSString stringWithFormat:@"%i", preReqMatchCoutner];
                        
                        preReqMatchCoutner += 1;
                        
                        playerOneID = playerOne[@"participantID"];
                        
//                        match = [self createMatchWtihID:[NSString stringWithFormat:@"%i", matchID] PlayerOneID:playerOne[@"participantID"] PlayerTwoID:@"" PlayerOnePreReqMatch:playerOnePreReqMatch PlayerTwoPreReqMatch:playerTwoPreReqMatch PlayerOnePreReqMatchLoser:NO PlayerTwoPreReqMatchLoser:NO];
                    }
                    else
                    {
                        playerOne = [self getNextParticipant];
                        
                        [playerOne setValue:@YES forKey:ASSIGNED_MATCH_KEY];
                        
                        playerTwo = [self getNextParticipant];
                        
                        [playerTwo setValue:@YES forKey:ASSIGNED_MATCH_KEY];
                        
                        playerOnePreReqMatch = @"";
                        playerTwoPreReqMatch = @"";
                        
                        playerOneID = playerOne[@"participantID"];
                        playerTwoID = playerTwo[@"participantID"];
                        
//                        match = [self createMatchWtihID:[NSString stringWithFormat:@"%i", matchID] PlayerOneID:playerOne[@"participantID"] PlayerTwoID:playerTwo[@"participantID"] PlayerOnePreReqMatch:playerOnePreReqMatch PlayerTwoPreReqMatch:playerTwoPreReqMatch PlayerOnePreReqMatchLoser:NO PlayerTwoPreReqMatchLoser:NO];
                        
                    }
                }
                else
                {
                    if(numberOfByes > preReqMatchCoutner)
                    {
                        playerOne = (NSMutableDictionary*)[self getNextParticipant];
                        
                        [playerOne setValue:@YES forKey:ASSIGNED_MATCH_KEY];
                        
                        playerTwoPreReqMatch = [NSString stringWithFormat:@"%i", preReqMatchCoutner];
                        
                        preReqMatchCoutner += 1;
                        
                        playerOneID = playerOne[@"participantID"];
                        
//                        match = [self createMatchWtihID:[NSString stringWithFormat:@"%i", matchID] PlayerOneID:playerOne[@"participantID"] PlayerTwoID:@"" PlayerOnePreReqMatch:playerOnePreReqMatch PlayerTwoPreReqMatch:playerTwoPreReqMatch PlayerOnePreReqMatchLoser:NO PlayerTwoPreReqMatchLoser:NO];
                    }
                    else
                    {
                        playerOnePreReqMatch = [NSString stringWithFormat:@"%i", preReqMatchCoutner];
                        
                        preReqMatchCoutner += 1;
                        
                        playerTwoPreReqMatch = [NSString stringWithFormat:@"%i", preReqMatchCoutner];
                        
                        preReqMatchCoutner += 1;
                        
//                        match = [self createMatchWtihID:[NSString stringWithFormat:@"%i", matchID] PlayerOneID:@"" PlayerTwoID:@"" PlayerOnePreReqMatch:playerOnePreReqMatch PlayerTwoPreReqMatch:playerTwoPreReqMatch PlayerOnePreReqMatchLoser:NO PlayerTwoPreReqMatchLoser:NO];
                        
                    }
                }
            }
            else
            {
                playerOnePreReqMatch = [NSString stringWithFormat:@"%i", preReqMatchCoutner];
                
                preReqMatchCoutner += 1;
                
                playerTwoPreReqMatch = [NSString stringWithFormat:@"%i", preReqMatchCoutner];
                
                preReqMatchCoutner += 1;
                
//                match = [self createMatchWtihID:[NSString stringWithFormat:@"%i", matchID] PlayerOneID:@"" PlayerTwoID:@"" PlayerOnePreReqMatch:playerOnePreReqMatch PlayerTwoPreReqMatch:playerTwoPreReqMatch PlayerOnePreReqMatchLoser:NO PlayerTwoPreReqMatchLoser:NO];
            }
            
            match = [self createMatchWtihID:[NSString stringWithFormat:@"%i", matchID] PlayerOneID:playerOneID PlayerTwoID:playerTwoID PlayerOnePreReqMatch:playerOnePreReqMatch PlayerTwoPreReqMatch:playerTwoPreReqMatch PlayerOnePreReqMatchLoser:NO PlayerTwoPreReqMatchLoser:NO];
            
            DLog(@"match: %@", match);
            
            [self.matchList addObject:match];
            
            matchID += 1;
        }
        
        participantCount /= 2;
        
        DLog(@"participantCount: %i", participantCount);
        
    }while(participantCount > 1);
}

#pragma mark - Double Elimination Matches

- (void) createDoubleEliminationMatches
{
    int participantCount = (int)[self.participantList count];
    int preReqMatchCoutner = 0;
    int matchID = 0;
    int numberToEliminateRoundOne = 0;
    int numberOfByes = 0;
    
    self.roundCounter = 0;
    
    /*For the tournament to work correctly you need a number of participants
     that are a power of two. If the number of participants are not a power
     of two you will need to find the humber of people who need to be eliminated
     in round one so that round two is a power of two.*/
    while (![self isPowerOfTwo:participantCount])
    {
        numberToEliminateRoundOne++;
        participantCount--;
        
    };
    
    /*If you need to Elimination people you can safly assume that for each person
     who you need to eliminate you will have a round one match. After which all
     remaining players will get a bye to round two.*/
    if(numberToEliminateRoundOne)
    {
        numberOfByes = (participantCount - numberToEliminateRoundOne);
        
        self.roundCounter++;
        
        for(int i = 0,j = 0;j < numberToEliminateRoundOne;i += 2,j++)
        {
            NSMutableDictionary* playerOne;
            NSMutableDictionary* playerTwo;
            NSString* playerOnePreReqMatch = @"";
            NSString* playerTwoPreReqMatch = @"";
            NSDictionary* match = @{};
            
            playerOne = [self getNextParticipant];
            
            [playerOne setValue:@YES forKey:ASSIGNED_MATCH_KEY];
            
            playerTwo = [self getNextParticipant];
            
            [playerTwo setValue:@YES forKey:ASSIGNED_MATCH_KEY];
            
            playerOnePreReqMatch = @"";
            playerTwoPreReqMatch = @"";
            
//            match = [self createMatchWtihID:[NSString stringWithFormat:@"%i", matchID] PlayerOneID:playerOne[@"participantID"] PlayerTwoID:playerTwo[@"participantID"] PlayerOnePreReqMatch:playerOnePreReqMatch PlayerTwoPreReqMatch:playerTwoPreReqMatch];
            
            DLog(@"match: %@", match);
            
            [self.matchList addObject:match];
            
            matchID += 1;
        }
    }
    
    /*This makes the rest of the tournament's matches.*/
    do
    {
        self.roundCounter++;
        
        for(int i = 0; i < participantCount;i += 2)
        {
            NSMutableDictionary* playerOne;
            NSMutableDictionary* playerTwo;
            NSString* playerOnePreReqMatch = @"";
            NSString* playerTwoPreReqMatch = @"";
            NSDictionary* match = @{};
            
            /*If you did not need to eliminate anyone the first round this will
             make round one matches. Round one matches are different from other
             matches due to the fact they do not have prerequisite matches and
             participants will be assigned to a match.*/
            if(self.roundCounter == 1)
            {
                playerOne = [self getNextParticipant];
                
                [playerOne setValue:@YES forKey:ASSIGNED_MATCH_KEY];
                
                playerTwo = [self getNextParticipant];
                
                [playerTwo setValue:@YES forKey:ASSIGNED_MATCH_KEY];
                
                playerOnePreReqMatch = @"";
                playerTwoPreReqMatch = @"";
                
//                match = [self createMatchWtihID:[NSString stringWithFormat:@"%i", matchID] PlayerOneID:playerOne[@"participantID"] PlayerTwoID:playerTwo[@"participantID"] PlayerOnePreReqMatch:playerOnePreReqMatch PlayerTwoPreReqMatch:playerTwoPreReqMatch];
            }
            else
                if(self.roundCounter == 2 && numberOfByes)
                {
                    /*If the number of byes is less then the number of people to
                     eliminated in round one it means that two matchs will have
                     to complete against each other to see advances to round two.
                     If the number of byes is greater then the number of participants
                     to eliminate then the winner of a match will face off against one
                     of the bye paticipants. If there enough byes some of them will be
                     full matches and will act like normal.*/
                    if(numberOfByes >= numberToEliminateRoundOne)
                    {
                        if(numberToEliminateRoundOne > preReqMatchCoutner)
                        {
                            playerOne = (NSMutableDictionary*)[self getNextParticipant];
                            
                            [playerOne setValue:@YES forKey:ASSIGNED_MATCH_KEY];
                            
                            playerTwoPreReqMatch = [NSString stringWithFormat:@"%i", preReqMatchCoutner];
                            
                            preReqMatchCoutner += 1;
                            
//                            match = [self createMatchWtihID:[NSString stringWithFormat:@"%i", matchID] PlayerOneID:playerOne[@"participantID"] PlayerTwoID:@"" PlayerOnePreReqMatch:playerOnePreReqMatch PlayerTwoPreReqMatch:playerTwoPreReqMatch];
                        }
                        else
                        {
                            playerOne = [self getNextParticipant];
                            
                            [playerOne setValue:@YES forKey:ASSIGNED_MATCH_KEY];
                            
                            playerTwo = [self getNextParticipant];
                            
                            [playerTwo setValue:@YES forKey:ASSIGNED_MATCH_KEY];
                            
                            playerOnePreReqMatch = @"";
                            playerTwoPreReqMatch = @"";
                            
//                            match = [self createMatchWtihID:[NSString stringWithFormat:@"%i", matchID] PlayerOneID:playerOne[@"participantID"] PlayerTwoID:playerTwo[@"participantID"] PlayerOnePreReqMatch:playerOnePreReqMatch PlayerTwoPreReqMatch:playerTwoPreReqMatch];
                            
                        }
                    }
                    else
                    {
                        if(numberOfByes > preReqMatchCoutner)
                        {
                            playerOne = (NSMutableDictionary*)[self getNextParticipant];
                            
                            [playerOne setValue:@YES forKey:ASSIGNED_MATCH_KEY];
                            
                            playerTwoPreReqMatch = [NSString stringWithFormat:@"%i", preReqMatchCoutner];
                            
                            preReqMatchCoutner += 1;
                            
//                            match = [self createMatchWtihID:[NSString stringWithFormat:@"%i", matchID] PlayerOneID:playerOne[@"participantID"] PlayerTwoID:@"" PlayerOnePreReqMatch:playerOnePreReqMatch PlayerTwoPreReqMatch:playerTwoPreReqMatch];
                        }
                        else
                        {
                            playerOnePreReqMatch = [NSString stringWithFormat:@"%i", preReqMatchCoutner];
                            
                            preReqMatchCoutner += 1;
                            
                            playerTwoPreReqMatch = [NSString stringWithFormat:@"%i", preReqMatchCoutner];
                            
                            preReqMatchCoutner += 1;
                            
//                            match = [self createMatchWtihID:[NSString stringWithFormat:@"%i", matchID] PlayerOneID:@"" PlayerTwoID:@"" PlayerOnePreReqMatch:playerOnePreReqMatch PlayerTwoPreReqMatch:playerTwoPreReqMatch];
                            
                        }
                    }
                }
                else
                {
                    playerOnePreReqMatch = [NSString stringWithFormat:@"%i", preReqMatchCoutner];
                    
                    preReqMatchCoutner += 1;
                    
                    playerTwoPreReqMatch = [NSString stringWithFormat:@"%i", preReqMatchCoutner];
                    
                    preReqMatchCoutner += 1;
                    
//                    match = [self createMatchWtihID:[NSString stringWithFormat:@"%i", matchID] PlayerOneID:@"" PlayerTwoID:@"" PlayerOnePreReqMatch:playerOnePreReqMatch PlayerTwoPreReqMatch:playerTwoPreReqMatch];
                }
            
            DLog(@"match: %@", match);
            
            [self.matchList addObject:match];
            
            matchID += 1;
        }
        
        participantCount /= 2;
        
        DLog(@"participantCount: %i", participantCount);
        
    }while(participantCount > 1);
}

#pragma mark - IBAction Methods

- (IBAction)onAddParticipantAction:(id)sender
{
    if(self.participantNameEntryTextField.text.length < 1)
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please enter the name of a participant." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *action)
                                       {
                                       }];
        
        [alert addAction:okAction];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
    if([self.participantNameList containsObject:self.participantNameEntryTextField.text])
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"A participant by that name has already been created." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action)
                                   {
                                   }];
        
        [alert addAction:okAction];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
    NSString* participantName = self.participantNameEntryTextField.text;
    
    self.participantNameEntryTextField.text = @"";
    
    NSMutableDictionary* participantDict = [[NSMutableDictionary alloc] initWithDictionary:
                                            @{@"participantID":[NSString stringWithFormat:@"%i", self.participantID],
                                              @"name":participantName,
                                              @"userName":@"userName",
                                              ASSIGNED_MATCH_KEY:@NO,
                                              @"displayName":participantName}];
    
    [self.participantList addObject:participantDict];
    
    self.participantID += 1;
    
    TParticipantView* participantView = [TParticipantView new];
    
    [participantView setFrame:self.nextParticipantViewFrame];
    
    [participantView loadParticipantName:participantName];
    
    if(self.participantListViewHeightConstraint.constant == 0)
    {
        self.participantListViewHeightConstraint.constant = 1;
    }
    
    self.participantListViewHeightConstraint.constant = ((self.nextParticipantViewFrame.size.height + self.nextParticipantViewFrame.origin.y) + 1);
    
    self.nextParticipantViewFrame = (CGRect){{self.nextParticipantViewFrame.origin.x,(self.nextParticipantViewFrame.origin.y + (self.nextParticipantViewFrame.size.height + 1))},self.nextParticipantViewFrame.size};
    
    [self.participantListView addSubview:participantView];
}

- (IBAction)onSelectTournamentType:(id)sender
{
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: nil];
    
    [actionSheet addButtonWithTitle:@"Single Elimination"];
    
    [actionSheet addButtonWithTitle:@"Double Elimination"];
    
    [actionSheet showInView:self.view];
}

- (IBAction)onCreateTournamentAction:(id)sender
{
    if(self.tournamentNameTextField.text.length < 1)
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Warning" message:[NSString stringWithFormat:@"You are about to create a tournament with no name. Do you want to us %@ as your tournament name?", self.tournamentName] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"YES"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action)
                                   {
                                        [self createTournament];
                                   }];
        
        UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"NO"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *action)
                                   {
                                   }];
        
        [alert addAction:noAction];
        
        [alert addAction:yesAction];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
    /*We don't want the user to have more then one of the same tournament name.
      This will help reduce confusion down the road when the user has a lot of tournaments in there list.*/
    if([[TNetworkManager sharedInstance].user isTournamentNameUnique:self.tournamentNameTextField.text])
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error" message:[NSString stringWithFormat:@"You already have a tournament with the name %@. Please use a different name.", self.tournamentNameTextField.text] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *action)
                                   {
                                   }];
        
        [alert addAction:okAction];
        
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    self.tournamentName = self.tournamentNameTextField.text;
    
    [self createTournament];
}

#pragma mark - Keyboard Methods

- (void) keyboardDidShow:(NSNotification*)note
{
    
    NSDictionary* info = [note userInfo];
    NSValue *avalue = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [avalue CGRectValue].size;
    
    self.scrollViewBottomConstraint.constant = keyboardSize.height;
    
}

- (void) keyboardDidHide:(NSNotification*)note
{
    
    self.scrollViewBottomConstraint.constant = 0;
    
    [UIView animateWithDuration:0.25f animations:^{
        
        [self.view layoutIfNeeded];
        
    }];
}

#pragma mark - UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.tournamentNameTextField)
    {
        [self.gameNameTextField becomeFirstResponder];
    }
    else
    if(textField == self.gameNameTextField)
    {
        [self.participantNameEntryTextField becomeFirstResponder];
    }
    else
    if(textField == self.participantNameEntryTextField)
    {
        [self onAddParticipantAction:nil];
    }
    
    return YES;
}

#pragma mark - UIActionSheet Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(!buttonIndex)
    {
        return;
    }
    
    NSInteger index = buttonIndex - 1;
    
    switch (index)
    {
        case 0:
        {
            self.tournamentType = @"Single Elimination";
            break;
        }
        case 1:
        {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Sorry" message:@"Double Elimination tournaments are not currently supported." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction *action)
                                       {
                                       }];
            
            [alert addAction:okAction];
            
            [self presentViewController:alert animated:YES completion:nil];
            break;
        }
            
        default:
        {
            self.tournamentType = @"Single Elimination";
            break;
        }
    }
    
    self.tournamentTypeLabel.text = [NSString stringWithFormat:@"Current Tournament Type: %@", self.tournamentType];
}

@end
