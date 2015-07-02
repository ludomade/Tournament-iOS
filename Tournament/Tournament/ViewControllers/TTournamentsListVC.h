//
//  TTournamentsListVC.h
//  Tournament
//
//  Created by Eugene Heckert on 5/7/15.
//  Copyright (c) 2015 Eugene Heckert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPullToRefreshVC.h"

@interface TTournamentsListVC : TPullToRefreshVC

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
