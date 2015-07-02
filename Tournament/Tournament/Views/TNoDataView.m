//
//  TNoDataView.m
//  Tournament
//
//  Created by Eugene Heckert on 6/26/15.
//  Copyright (c) 2015 Eugene Heckert. All rights reserved.
//

#import "TNoDataView.h"

@interface TNoDataView ()

@property (nonatomic, strong) UIView* parentView;

@property (nonatomic) BOOL isActive;

@end

static TNoDataView *sharedNoDataView = nil;

@implementation TNoDataView

+ (TNoDataView*)sharedInstance
{
    @synchronized(self)
    {
        if( sharedNoDataView == nil )
            sharedNoDataView = [[self alloc] init];
    }
    
    return sharedNoDataView;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        [[NSBundle mainBundle] loadNibNamed:@"TNoDataView" owner:self options:nil];
        [self addSubview:_mainView];
        [_mainView setFrame:(CGRect){{0,0},self.frame.size}];
        
    }
    
    return self;
}


- (void)showNoDataView:(UIView *)view WithText:(NSString *)text
{
    DLog(@"");
    if(self.superview == view)
    {
        return;
    }
    
    if(_isActive)
    {
        [self removeNoDataView];
    }
    else
    {
        _isActive = YES;
    }
    
    self.noDataLabel.text = text;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [self setFrame:(CGRect){{0,0},view.frame.size}];
    [view addSubview:self];
}

- (void)removeNoDataView
{
    DLog(@"");
    _isActive = NO;
    
    [self removeFromSuperview];
}

@end
