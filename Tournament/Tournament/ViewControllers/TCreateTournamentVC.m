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

@property (nonatomic, strong) Tournament* currentTournament;

@property (nonatomic, strong) Tournament* createdTournament;

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
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    TParticipantView* participantView = [TParticipantView new];
    
    self.nextParticipantViewFrame = (CGRect){CGPointZero,{self.participantListView.frame.size.width, participantView.frame.size.height}};
    
    for(int i = 0; i < AUTO_CREATE_PARTICIPANTS_COUNT;i++)
    {
        self.participantNameEntryTextField.text = [NSString stringWithFormat:@"%i",i];
        
        [self onAddParticipantAction:nil];
    }
    
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

- (void) dismissKeyboard
{
    [self.tournamentNameTextField resignFirstResponder];
    [self.gameNameTextField resignFirstResponder];
    [self.participantNameEntryTextField resignFirstResponder];
}

- (void) createTournament
{
    [self dismissKeyboard];
    
    if(![self.participantList count])
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
    
    PFObject* tournament = [PFObject objectWithClassName:@"Tournament"];
    
//    self.createdTournament = [Tournament new];
//    
//    self.createdTournament.name = self.tournamentName;
    
    tournament[@"name"] = self.tournamentName;
    
    if(self.gameNameTextField.text.length > 0)
    {
//        self.createdTournament.gameName = self.gameNameTextField.text;
        tournament[@"gameName"] = self.gameNameTextField.text;
    }
    else
    {
//        self.createdTournament.gameName = @"Unspecified game";
        tournament[@"gameName"] = @"Unspecified game";
    }
    
//    self.createdTournament.tournamentType = @"Single Elimination";
    tournament[@"tournamentType"] = @"Single Elimination";
    
//    self.createdTournament.state = @"pending";
    tournament[@"tournamentState"] = @"pending";
    
//    self.createdTournament.createdBy = [TNetworkManager sharedInstance].user.username;
    tournament[@"createdBy"] = [TNetworkManager sharedInstance].user.username;
    
    [self CreateMatches];
    
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
    
//    self.createdTournament.tournamentParticipantsDictAr = self.participantList;
    tournament[@"tournamentParticipantsDictAr"] = self.participantList;
    
//    self.createdTournament.tournamentMatchesDictAr = self.matchList;
    tournament[@"tournamentMatchesDictAr"] = self.matchList;
    
//    self.createdTournament.maxNumberRounds = self.roundCounter;
    tournament[@"maxNumberRounds"] = [NSNumber numberWithInt:self.roundCounter];
    
//    self.createdTournament.participantsCount = (int) [self.participantList count];
    tournament[@"participantsCount"] = [NSNumber numberWithInt:(int)[self.participantList count]];
    
//    self.createdTournament.quickAdvance = YES;
    tournament[@"quickAdvance"] = @YES;
    
    [tournament saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded)
        {
            // The object has been saved.
            
            [[TNetworkManager sharedInstance].user newTournamentName:tournament[@"name"]];
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

- (void) CreateMatches
{
    int participantCount = (int)[self.participantList count];
    int preReqMatchCoutner = 0;
    int matchID = 0;
    int numberToElimateRoundOne = 0;
    int numberOfByes = 0;
    
    self.roundCounter = 0;
    
    while (![self isPowerOfTwo:participantCount])
    {
        numberToElimateRoundOne++;
        participantCount--;
        
    };
    
    if(numberToElimateRoundOne)
    {
        numberOfByes = (participantCount - numberToElimateRoundOne);
        
        self.roundCounter++;
        
        for(int i = 0,j = 0;j < numberToElimateRoundOne;i += 2,j++)
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
            
            match = [self createMatchWtihID:[NSString stringWithFormat:@"%i", matchID] PlayerOneID:playerOne[@"participantID"] PlayerTwoID:playerTwo[@"participantID"] PlayerOnePreReqMatch:playerOnePreReqMatch PlayerTwoPreReqMatch:playerTwoPreReqMatch];
            
            DLog(@"match: %@", match);
            
            [self.matchList addObject:match];
            
            matchID += 1;
        }
    }
    
    
    do
    {
        self.roundCounter += 1;
        
        for(int i = 0; i < participantCount;i += 2)
        {
            NSMutableDictionary* playerOne;
            NSMutableDictionary* playerTwo;
            NSString* playerOnePreReqMatch = @"";
            NSString* playerTwoPreReqMatch = @"";
            NSDictionary* match = @{};
            
            if(self.roundCounter == 1)
            {
                playerOne = [self getNextParticipant];
                
                [playerOne setValue:@YES forKey:ASSIGNED_MATCH_KEY];
                
                playerTwo = [self getNextParticipant];
                
                [playerTwo setValue:@YES forKey:ASSIGNED_MATCH_KEY];
                
                playerOnePreReqMatch = @"";
                playerTwoPreReqMatch = @"";
                
                match = [self createMatchWtihID:[NSString stringWithFormat:@"%i", matchID] PlayerOneID:playerOne[@"participantID"] PlayerTwoID:playerTwo[@"participantID"] PlayerOnePreReqMatch:playerOnePreReqMatch PlayerTwoPreReqMatch:playerTwoPreReqMatch];
            }
            else
                if(self.roundCounter == 2 && numberOfByes)
                {
                    
                    if(numberOfByes >= numberToElimateRoundOne)
                    {
                        if(numberToElimateRoundOne > preReqMatchCoutner)
                        {
                            playerOne = (NSMutableDictionary*)[self getNextParticipant];
                            
                            [playerOne setValue:@YES forKey:ASSIGNED_MATCH_KEY];
                            
                            playerTwoPreReqMatch = [NSString stringWithFormat:@"%i", preReqMatchCoutner];
                            
                            preReqMatchCoutner += 1;
                            
                            match = [self createMatchWtihID:[NSString stringWithFormat:@"%i", matchID] PlayerOneID:playerOne[@"participantID"] PlayerTwoID:@"" PlayerOnePreReqMatch:playerOnePreReqMatch PlayerTwoPreReqMatch:playerTwoPreReqMatch];
                        }
                        else
                        {
                            playerOne = [self getNextParticipant];
                            
                            [playerOne setValue:@YES forKey:ASSIGNED_MATCH_KEY];
                            
                            playerTwo = [self getNextParticipant];
                            
                            [playerTwo setValue:@YES forKey:ASSIGNED_MATCH_KEY];
                            
                            playerOnePreReqMatch = @"";
                            playerTwoPreReqMatch = @"";
                            
                            match = [self createMatchWtihID:[NSString stringWithFormat:@"%i", matchID] PlayerOneID:playerOne[@"participantID"] PlayerTwoID:playerTwo[@"participantID"] PlayerOnePreReqMatch:playerOnePreReqMatch PlayerTwoPreReqMatch:playerTwoPreReqMatch];
                            
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
                            
                            match = [self createMatchWtihID:[NSString stringWithFormat:@"%i", matchID] PlayerOneID:playerOne[@"participantID"] PlayerTwoID:@"" PlayerOnePreReqMatch:playerOnePreReqMatch PlayerTwoPreReqMatch:playerTwoPreReqMatch];
                        }
                        else
                        {
                            playerOnePreReqMatch = [NSString stringWithFormat:@"%i", preReqMatchCoutner];
                            
                            preReqMatchCoutner += 1;
                            
                            playerTwoPreReqMatch = [NSString stringWithFormat:@"%i", preReqMatchCoutner];
                            
                            preReqMatchCoutner += 1;
                            
                            match = [self createMatchWtihID:[NSString stringWithFormat:@"%i", matchID] PlayerOneID:@"" PlayerTwoID:@"" PlayerOnePreReqMatch:playerOnePreReqMatch PlayerTwoPreReqMatch:playerTwoPreReqMatch];
                            
                        }
                    }
                }
                else
                {
                    playerOnePreReqMatch = [NSString stringWithFormat:@"%i", preReqMatchCoutner];
                    
                    preReqMatchCoutner += 1;
                    
                    playerTwoPreReqMatch = [NSString stringWithFormat:@"%i", preReqMatchCoutner];
                    
                    preReqMatchCoutner += 1;
                    
                    match = [self createMatchWtihID:[NSString stringWithFormat:@"%i", matchID] PlayerOneID:@"" PlayerTwoID:@"" PlayerOnePreReqMatch:playerOnePreReqMatch PlayerTwoPreReqMatch:playerTwoPreReqMatch];
                }
            
            DLog(@"match: %@", match);
            
            [self.matchList addObject:match];
            
            matchID += 1;
        }
        
        participantCount /= 2;
        
        DLog(@"participantCount: %i", participantCount);
        
    }while(participantCount > 1);
}

- (NSDictionary*) createMatchWtihID:(NSString*)matchID PlayerOneID:(NSString*)playerOneID PlayerTwoID:(NSString*)playerTwoID PlayerOnePreReqMatch:(NSString*)playerOnePreReqMatch PlayerTwoPreReqMatch:(NSString*)playerTwoPreReqMatch
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
             @"playerOnePreReqMatchLoser":@"",
             @"playerTwoPreReqMatchLoser":@"",
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

- (BOOL) isPowerOfTwo:(int) x
{
    return ((x != 0) && !(x & (x-1)));
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

@end
