//
//  TActivityIndicator.m
//  Tournament
//
//  Created by Eugene Heckert on 5/7/15.
//  Copyright (c) 2015 Eugene Heckert. All rights reserved.
//

#import "TActivityIndicator.h"

@interface TActivityIndicator ()

@property (nonatomic, strong) UIView* parentView;

@property (nonatomic, strong) UIView* loadingView;
@property (nonatomic, strong) UIView* dimBackgroundView;
@property (nonatomic) BOOL isActive;

@end

static TActivityIndicator *sharedActivityIndicator = nil;

@implementation TActivityIndicator

+ (TActivityIndicator*)sharedInstance
{
    @synchronized(self)
    {
        if( sharedActivityIndicator == nil )
            sharedActivityIndicator = [[self alloc] init];
    }
    
    return sharedActivityIndicator;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [[NSBundle mainBundle] loadNibNamed:@"TActivityIndicator" owner:self options:nil];
        [self addSubview:_mainView];
        [_mainView setFrame:(CGRect){{0,0},self.frame.size}];
        
    }
    
    return self;
}


- (void)showActivityIndicator:(UIView *)view
{
    DLog(@"");
    if(self.superview == view)
    {
        return;
    }
    
    if(_isActive)
    {
        [self removeActivityIndicator];
    }
    else
    {
        _isActive = YES;
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [self setFrame:(CGRect){{0,0},view.frame.size}];
    [view addSubview:self];
    
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    rotationAnimation.fromValue = @(0.0);
    rotationAnimation.toValue = @(M_PI * 2.0);
    rotationAnimation.duration = 1.0;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = MAXFLOAT;
    
    [_loadingSpinnerImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)removeActivityIndicator
{
    DLog(@"");
    _isActive = NO;
    
    [_loadingSpinnerImageView.layer removeAnimationForKey:@"rotationAnimation"];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    [self removeFromSuperview];
}

@end
