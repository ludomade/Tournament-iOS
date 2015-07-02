//
//  TTabBarController.m
//  Tournament
//
//  Created by Eugene Heckert on 5/7/15.
//  Copyright (c) 2015 Eugene Heckert. All rights reserved.
//

#import "TTabBarController.h"
#import "User.h"
#import "TLoginVC.h"
#import "TTournamentsListVC.h"
#import "SecondViewController.h"

@implementation TTabBarController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(![TNetworkManager sharedInstance].user)
    {
        DLog(@"[TNetworkManager sharedInstance].user: %@", [TNetworkManager sharedInstance].user);
        
        DLog(@"User is not signed in.");
        
        TLoginVC* loginVC = [[TLoginVC alloc] initWithNibName:@"TLoginVC" bundle:nil];
        
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}

//- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
//{
//    self.title = item.title;
//    DLog(@"");
//}

@end
