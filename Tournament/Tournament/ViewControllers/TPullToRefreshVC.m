//
//  TPullToRefreshViewController.m
//  Tournament
//
//  Created by Eugene Heckert on 5/8/15.
//  Copyright (c) 2015 Eugene Heckert. All rights reserved.
//

#import "TPullToRefreshVC.h"

@interface TPullToRefreshVC ()

@end

@implementation TPullToRefreshVC

- (id) init
{
    self = [super init];
    if(self)
    {
        if(!self.refreshControl)
        {
            self.refreshControl = [UIRefreshControl new];
            
            [self.refreshControl addTarget:self action:@selector(sendRefreashDataCall) forControlEvents:UIControlEventValueChanged];
        }
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if(!self.refreshControl)
    {
        self.refreshControl = [UIRefreshControl new];
        
        [self.refreshControl addTarget:self action:@selector(sendRefreashDataCall) forControlEvents:UIControlEventValueChanged];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshData
{
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(self.refreshControl.isRefreshing)
    {
        DLog(@"~testing");
        [self refreshData];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(self.refreshControl.isRefreshing)
    {
        DLog(@"~testing");
        [scrollView setScrollEnabled:NO];
    }
}

- (void) sendRefreashDataCall
{
    DLog(@"~testing");
    if(self.refreshControl.isRefreshing)
    {
        [self refreshData];
    }
}

@end
