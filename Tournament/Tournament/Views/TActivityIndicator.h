//
//  TActivityIndicator.h
//  Tournament
//
//  Created by Eugene Heckert on 5/7/15.
//  Copyright (c) 2015 Eugene Heckert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TActivityIndicator : UIView

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIView *darkBackgroundView;

@property (weak, nonatomic) IBOutlet UIView *activityIndicatorView;

@property (weak, nonatomic) IBOutlet UIImageView *loadingSpinnerImageView;

+ (TActivityIndicator*)sharedInstance;

- (void)showActivityIndicator:(UIView *)view;
- (void)removeActivityIndicator;

@end
