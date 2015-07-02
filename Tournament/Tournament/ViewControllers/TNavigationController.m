//
//  TNavigationController.m
//  Tournament
//
//  Created by Eugene Heckert on 6/24/15.
//  Copyright (c) 2015 Eugene Heckert. All rights reserved.
//

#import "TNavigationController.h"

@interface TNavigationController () <UINavigationControllerDelegate>

@end

@implementation TNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.interactivePopGestureRecognizer.delegate = self;
        self.delegate = self;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    [super pushViewController:viewController animated:animated];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
//    if (![viewController isEqual:self.viewControllers[0]])
//    {
//        // Setup Back Button
//        if (viewController.navigationItem.leftBarButtonItem.tag != NAV_ARROW_TAG)
//        {
//            UIImage* backBtnImg = [UIImage imageNamed:@"white_icon_backarrow"];
//            UIButton* backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, backBtnImg.size.width, self.navigationBar.frame.size.height)];
//            [backBtn setImage:backBtnImg forState:UIControlStateNormal];
//            [backBtn addTarget:self action:@selector(handleNavBarBack) forControlEvents:UIControlEventTouchUpInside];
//            UIBarButtonItem *backNavBtn = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
//            backNavBtn.tag = NAV_ARROW_TAG;
//            
//            viewController.navigationItem.leftBarButtonItem = backNavBtn;
//        }
//    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.interactivePopGestureRecognizer.enabled = YES;
    }
}
- (void)handleNavBarBack
{
    [self popViewControllerAnimated:YES];
}

@end
