//
//  TMatchView.h
//  Tournament
//
//  Created by Eugene Heckert on 6/22/15.
//  Copyright (c) 2015 Eugene Heckert. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Participant, Match, Tournament;

@protocol TMatchViewDelegate <NSObject>

- (void) matchHasBeenUpdated:(Match*)updatedMatch;

@end

@interface TMatchView : UIView

@property (weak, nonatomic) IBOutlet UIView *mainView;

@property (weak, nonatomic) IBOutlet UIView *playerOneView;
@property (weak, nonatomic) IBOutlet UIImageView *playerOneAvatarImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *playerOneAvatarImageViewWidthConstraint;
@property (weak, nonatomic) IBOutlet UILabel *playerOneNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerOneScoreLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *playerOneScoreLabelWidthConstraint;

@property (weak, nonatomic) IBOutlet UIView *playerTwoView;
@property (weak, nonatomic) IBOutlet UIImageView *playerTwoAvatarImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *playerTwoAvatarImageViewWidthConstraint;
@property (weak, nonatomic) IBOutlet UILabel *playerTwoNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerTwoScoreLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *playerTwoScoreLabelWidthConstraint;

@property (weak, nonatomic) IBOutlet UIButton *matchSelectBtn;

@property (weak, nonatomic) id<TMatchViewDelegate> delegate;

- (void) loadMatch:(Match*)match AndCurrentTournament:(Tournament*)tournament;

- (void) matchUpdated;


@end
