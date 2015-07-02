//
//  TRoundHeaderView.m
//  Tournament
//
//  Created by Eugene Heckert on 6/22/15.
//  Copyright (c) 2015 Eugene Heckert. All rights reserved.
//

#import "TRoundHeaderView.h"

@implementation TRoundHeaderView


- (id)init
{
    self = [super init];
    if (self)
    {
        [[NSBundle mainBundle] loadNibNamed:@"TRoundHeaderView" owner:self options:nil];
        [self addSubview:self.mainView];
        [self setFrame:(CGRect){CGPointZero,self.mainView.frame.size}];
        
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self.mainView setFrame:(CGRect){CGPointZero,frame.size}];
}

@end
