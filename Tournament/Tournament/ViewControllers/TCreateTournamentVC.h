//
//  TCreateTournamentVC.h
//  Tournament
//
//  Created by Eugene Heckert on 6/25/15.
//  Copyright (c) 2015 Eugene Heckert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCreateTournamentVC : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewBottomConstraint;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UITextField *tournamentNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *gameNameTextField;
@property (weak, nonatomic) IBOutlet UIView *participantListView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *participantListViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UITextField *participantNameEntryTextField;

@end
