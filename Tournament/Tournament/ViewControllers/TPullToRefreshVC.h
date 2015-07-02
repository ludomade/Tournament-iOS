//
//  TPullToRefreshViewController.h
//  Tournament
//
//  Created by Eugene Heckert on 5/8/15.
//  Copyright (c) 2015 Eugene Heckert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCustomTableAnimationVC.h"

@interface TPullToRefreshVC : TCustomTableAnimationVC

@property (nonatomic, strong) UIRefreshControl* refreshControl;

- (void) refreshData;

@end
