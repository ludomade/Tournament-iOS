//
//  TMatchView.m
//  Tournament
//
//  Created by Eugene Heckert on 6/22/15.
//  Copyright (c) 2015 Eugene Heckert. All rights reserved.
//

#import "TMatchView.h"
#import "Participant.h"
#import "Match.h"
#import "Tournament.h"

@interface TMatchView ()

@property(nonatomic, strong) Tournament* currentTournament;
@property(nonatomic, strong) Match* selectedMatch;

@property(nonatomic, strong) Participant* playerOne;
@property(nonatomic, strong) Participant* playerTwo;

@end

@implementation TMatchView


- (id)init
{
    self = [super init];
    if (self)
    {
        [[NSBundle mainBundle] loadNibNamed:@"TMatchView" owner:self options:nil];
        [self addSubview:self.mainView];
        [self setFrame:(CGRect){CGPointZero,self.mainView.frame.size}];
        //        [_mainView setFrame:(CGRect){{0,0},self.frame.size}];
        
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self.mainView setFrame:(CGRect){CGPointZero,frame.size}];
}

- (void)loadMatch:(Match *)match AndCurrentTournament:(Tournament *)tournament
{
    self.selectedMatch = match;
    
    self.currentTournament = tournament;
    
    if(self.selectedMatch.playerOneID)
    {
        self.playerOne = [self.currentTournament getParticipantByID:self.selectedMatch.playerOneID];
        
        self.playerOneNameLabel.text = self.playerOne.displayName;
        
        if(!self.currentTournament.quickAdvance)
        {
            self.playerOneScoreLabel.text = [NSString stringWithFormat:@"%i", self.selectedMatch.playerOneScore];
            
            CGSize size = [self.playerOneScoreLabel.text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17.0f]}];
            
            self.playerOneScoreLabelWidthConstraint.constant = size.width;
        }
        else
        {
            self.playerOneScoreLabel.text = @"";
            self.playerOneScoreLabelWidthConstraint.constant = 0;
        }
        
        self.playerOneAvatarImageViewWidthConstraint.constant = 0;
    }
    else
    {
        self.playerOne = nil;
        
        self.playerOneNameLabel.text = @"";
        
        self.playerOneAvatarImageViewWidthConstraint.constant = 0;
    }
    
    if(self.selectedMatch.playerTwoID)
    {
        self.playerTwo = [self.currentTournament getParticipantByID:self.selectedMatch.playerTwoID];
        
        self.playerTwoNameLabel.text = self.playerTwo.displayName;
        
        if(!self.currentTournament.quickAdvance)
        {
            self.playerTwoScoreLabel.text = [NSString stringWithFormat:@"%i", self.selectedMatch.playerTwoScore];
            
            CGSize size = [self.playerTwoScoreLabel.text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17.0f]}];
            
            self.playerTwoScoreLabelWidthConstraint.constant = size.width;
        }
        else
        {
            self.playerTwoScoreLabel.text = @"";
            self.playerTwoScoreLabelWidthConstraint.constant = 0;
        }
        
        self.playerTwoAvatarImageViewWidthConstraint.constant = 0;
    }
    else
    {
        self.playerTwo = nil;
        
        self.playerTwoNameLabel.text = @"";
        
        self.playerTwoAvatarImageViewWidthConstraint.constant = 0;
    }
    
    if(self.selectedMatch.winnerID.length > 0  && self.selectedMatch.loserID.length > 0 )
    {
        if([self.selectedMatch.winnerID isEqualToString:self.playerOne.participantID])
        {
            [self.playerOneView setBackgroundColor:LUDOMADE_YELLOW];
            
            [self.playerOneNameLabel setTextColor:LUDOMADE_SLATE];
            
            [self.playerOneScoreLabel setTextColor:LUDOMADE_SLATE];
            
            [self.playerTwoView setBackgroundColor:LIGHT_GREY];
            
            [self.playerTwoNameLabel setTextColor:[UIColor whiteColor]];
            
            [self.playerTwoScoreLabel setTextColor:[UIColor whiteColor]];
        }
        else
        {
            [self.playerOneView setBackgroundColor:LIGHT_GREY];
            
            [self.playerOneNameLabel setTextColor:[UIColor whiteColor]];
            
            [self.playerOneScoreLabel setTextColor:[UIColor whiteColor]];
            
            [self.playerTwoView setBackgroundColor:LUDOMADE_YELLOW];
            
            [self.playerTwoNameLabel setTextColor:LUDOMADE_SLATE];
            
            [self.playerTwoScoreLabel setTextColor:LUDOMADE_SLATE];
        }
    }
    
    if(self.playerOne && self.playerTwo)
    {
        [self.matchSelectBtn setEnabled:YES];
    }
    else
    {
        [self.matchSelectBtn setEnabled:NO];
    }
}

- (void) matchUpdated
{
    
    if(self.selectedMatch.playerOneID)
    {
        self.playerOne = [self.currentTournament getParticipantByID:self.selectedMatch.playerOneID];
        
        self.playerOneNameLabel.text = self.playerOne.displayName;
        
        if(!self.currentTournament.quickAdvance)
        {
            self.playerOneScoreLabel.text = [NSString stringWithFormat:@"%i", self.selectedMatch.playerOneScore];
            
            CGSize size = [self.playerOneScoreLabel.text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17.0f]}];
            
            self.playerOneScoreLabelWidthConstraint.constant = size.width;
        }
        else
        {
            self.playerOneScoreLabel.text = @"";
            self.playerOneScoreLabelWidthConstraint.constant = 0;
        }
        
        self.playerOneAvatarImageViewWidthConstraint.constant = 0;
    }
    else
    {
        self.playerOne = nil;
        
        self.playerOneNameLabel.text = @"";
        
        self.playerOneAvatarImageViewWidthConstraint.constant = 0;
    }
    
    if(self.selectedMatch.playerTwoID)
    {
        self.playerTwo = [self.currentTournament getParticipantByID:self.selectedMatch.playerTwoID];
        
        self.playerTwoNameLabel.text = self.playerTwo.displayName;
        
        if(!self.currentTournament.quickAdvance)
        {
            self.playerTwoScoreLabel.text = [NSString stringWithFormat:@"%i", self.selectedMatch.playerTwoScore];
            
            CGSize size = [self.playerTwoScoreLabel.text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17.0f]}];
            
            self.playerTwoScoreLabelWidthConstraint.constant = size.width;
        }
        else
        {
            self.playerTwoScoreLabel.text = @"";
            self.playerTwoScoreLabelWidthConstraint.constant = 0;
        }
        
        self.playerTwoAvatarImageViewWidthConstraint.constant = 0;
    }
    else
    {
        self.playerTwo = nil;
        
        self.playerTwoNameLabel.text = @"";
        
        self.playerTwoAvatarImageViewWidthConstraint.constant = 0;
    }
    
    if(self.selectedMatch.winnerID.length > 0  && self.selectedMatch.loserID.length > 0 )
    {
        if([self.selectedMatch.winnerID isEqualToString:self.playerOne.participantID])
        {
            [self.playerOneView setBackgroundColor:LUDOMADE_YELLOW];
            
            [self.playerOneNameLabel setTextColor:LUDOMADE_SLATE];
            
            [self.playerOneScoreLabel setTextColor:LUDOMADE_SLATE];
            
            [self.playerTwoView setBackgroundColor:LIGHT_GREY];
            
            [self.playerTwoNameLabel setTextColor:[UIColor whiteColor]];
            
            [self.playerTwoScoreLabel setTextColor:[UIColor whiteColor]];
        }
        else
        {
            [self.playerOneView setBackgroundColor:LIGHT_GREY];
            
            [self.playerOneNameLabel setTextColor:[UIColor whiteColor]];
            
            [self.playerOneScoreLabel setTextColor:[UIColor whiteColor]];
            
            [self.playerTwoView setBackgroundColor:LUDOMADE_YELLOW];
            
            [self.playerTwoNameLabel setTextColor:LUDOMADE_SLATE];
            
            [self.playerTwoScoreLabel setTextColor:LUDOMADE_SLATE];
        }
    }
    
    if(self.playerOne && self.playerTwo)
    {
        [self.matchSelectBtn setEnabled:YES];
    }
    else
    {
        [self.matchSelectBtn setEnabled:NO];
    }
}

- (void) updateBracketView
{
    
    if(self.selectedMatch.winnerID.length > 0  && self.selectedMatch.loserID.length > 0 )
    {
        if([self.selectedMatch.winnerID isEqualToString:self.playerOne.participantID])
        {
            [self.playerOneView setBackgroundColor:LUDOMADE_YELLOW];
            
            [self.playerOneNameLabel setTextColor:LUDOMADE_SLATE];
            
            [self.playerOneScoreLabel setTextColor:LUDOMADE_SLATE];
            
            [self.playerTwoView setBackgroundColor:LIGHT_GREY];
            
            [self.playerTwoNameLabel setTextColor:[UIColor whiteColor]];
            
            [self.playerTwoScoreLabel setTextColor:[UIColor whiteColor]];
        }
        else
        {
            [self.playerOneView setBackgroundColor:LIGHT_GREY];
            
            [self.playerOneNameLabel setTextColor:[UIColor whiteColor]];
            
            [self.playerOneScoreLabel setTextColor:[UIColor whiteColor]];
            
            [self.playerTwoView setBackgroundColor:LUDOMADE_YELLOW];
            
            [self.playerTwoNameLabel setTextColor:LUDOMADE_SLATE];
            
            [self.playerTwoScoreLabel setTextColor:LUDOMADE_SLATE];
        }
    }
    
    if(self.delegate)
    {
        if([self.delegate respondsToSelector:@selector(matchHasBeenUpdated:)])
        {
            [self.delegate matchHasBeenUpdated:self.selectedMatch];
        }
    }
}

- (IBAction)onMatchSelectedAction:(id)sender
{
    if(self.currentTournament.quickAdvance)
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"" message:@"Please select the winner of the match" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *playerOneAction = [UIAlertAction actionWithTitle:self.playerOne.displayName
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *action)
                                       {
                                           DLog(@"%@ Won", self.playerOne.displayName);
                                           self.selectedMatch.winnerID = self.playerOne.participantID;
                                           self.selectedMatch.loserID = self.playerTwo.participantID;
                                           
                                           [self updateBracketView];
                                       }];
        
        UIAlertAction *playerTwoAction = [UIAlertAction actionWithTitle:self.playerTwo.displayName
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction *action)
                                          {
                                              DLog(@"%@ Won", self.playerTwo.displayName);
                                              self.selectedMatch.winnerID = self.playerTwo.participantID;
                                              self.selectedMatch.loserID = self.playerOne.participantID;
                                              
                                              [self updateBracketView];
                                          }];
        
        UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Dismiss"
                                                                style:UIAlertActionStyleCancel
                                                              handler:^(UIAlertAction *action)
                                        {
                                        }];
        
        [alert addAction:playerOneAction];
        [alert addAction:playerTwoAction];
        [alert addAction:dismissAction];
        
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"" message:@"Please select the winner of the match" preferredStyle:UIAlertControllerStyleAlert];
        
        __weak UIAlertController *alertRef = alert;
        UIAlertAction *playerOneAction = [UIAlertAction actionWithTitle:self.playerOne.displayName
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction *action)
                                          {
                                              if([alertRef.textFields count] >= 2)
                                              {
                                                  UITextField* playerOneScore = ((UITextField *)[alertRef.textFields objectAtIndex:0]);
                                                  UITextField* playerTwoScore = ((UITextField *)[alertRef.textFields objectAtIndex:1]);
                                                  
                                                  DLog(@"%@ won with a score of %@", self.playerOne.displayName, playerOneScore.text);
                                                  
                                                  DLog(@"%@ lost with a score of %@", self.playerTwo.displayName, playerTwoScore.text);
                                                  
                                                  self.selectedMatch.winnerID = self.playerOne.participantID;
                                                  self.selectedMatch.loserID = self.playerTwo.participantID;
                                                  
                                                  self.selectedMatch.playerOneScore = [playerOneScore.text intValue];
                                                  self.selectedMatch.playerTwoScore = [playerTwoScore.text intValue];
                                                  
                                                  [self updateBracketView];
                                              }
                                          }];
        
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = [NSString stringWithFormat:@"%@ Score", self.playerOne.displayName];
        }];
        
        UIAlertAction *playerTwoAction = [UIAlertAction actionWithTitle:self.playerTwo.displayName
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction *action)
                                          {
                                              if([alertRef.textFields count] >= 2)
                                              {
                                                  UITextField* playerOneScore = ((UITextField *)[alertRef.textFields objectAtIndex:0]);
                                                  UITextField* playerTwoScore = ((UITextField *)[alertRef.textFields objectAtIndex:1]);
                                                  
                                                  DLog(@"%@ lost with a score of %@", self.playerOne.displayName, playerOneScore.text);
                                                  
                                                  DLog(@"%@ won with a score of %@", self.playerTwo.displayName, playerTwoScore.text);
                                                  
                                                  self.selectedMatch.winnerID = self.playerTwo.participantID;
                                                  self.selectedMatch.loserID = self.playerOne.participantID;
                                                  
                                                  self.selectedMatch.playerOneScore = [playerOneScore.text intValue];
                                                  self.selectedMatch.playerTwoScore = [playerTwoScore.text intValue];
                                                  
                                                  [self updateBracketView];
                                              }
                                          }];
        
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = [NSString stringWithFormat:@"%@ Score", self.playerTwo.displayName];
        }];
        
        UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Dismiss"
                                                                style:UIAlertActionStyleCancel
                                                              handler:^(UIAlertAction *action)
                                        {
                                        }];
        
        [alert addAction:playerOneAction];
        [alert addAction:playerTwoAction];
        [alert addAction:dismissAction];
        
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    }
}

@end
