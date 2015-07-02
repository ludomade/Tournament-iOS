//
//  TParticipantView.m
//  Tournament
//
//  Created by Eugene Heckert on 6/19/15.
//  Copyright (c) 2015 Eugene Heckert. All rights reserved.
//

#import "TParticipantView.h"
#import "Participant.h"

@interface TParticipantView ()

@property(strong, nonatomic) NSString* participantName;

@end

@implementation TParticipantView


- (id)init
{
    self = [super init];
    if (self)
    {
        [[NSBundle mainBundle] loadNibNamed:@"TParticipantView" owner:self options:nil];
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

- (void)loadParticipantName:(NSString *)name
{
    self.participantName = name;
    
    self.nameLabel.text = name;
    
    self.avatarImageViewWidthConstraint.constant = 0;
}

- (void)loadParticipant:(Participant *)part
{
    self.nameLabel.text = part.displayName;
    
    self.avatarImageViewWidthConstraint.constant = 0;
}

- (void) noParticipant
{
    self.nameLabel.text = @"";
    
    self.avatarImageViewWidthConstraint.constant = 0;

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
