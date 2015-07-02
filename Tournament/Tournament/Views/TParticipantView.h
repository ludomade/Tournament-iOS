//
//  TParticipantView.h
//  Tournament
//
//  Created by Eugene Heckert on 6/19/15.
//  Copyright (c) 2015 Eugene Heckert. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Participant;

@interface TParticipantView : UIView

@property (weak, nonatomic) IBOutlet UIView *mainView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarImageViewWidthConstraint;

- (void) loadParticipantName:(NSString*)name;
- (void) loadParticipant:(Participant*)part;
- (void) noParticipant;

@end
