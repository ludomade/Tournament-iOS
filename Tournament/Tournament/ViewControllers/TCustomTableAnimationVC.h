//
//  TCustomTableViewController.h
//  Tournament
//
//  Created by Eugene Heckert on 5/8/15.
//  Copyright (c) 2015 Eugene Heckert. All rights reserved.
//

#define RELOAD_INDEX_RESET     -1

typedef enum AnimationStyleType
{
    SLIDE_IN_RIGHT,
    FADE_IN,
    SLIDE_IN_BOTTOM,
    SCALE_IN,
    NO_ANIMATION
    
}AnimationStyle;

#import <UIKit/UIKit.h>

@interface TCustomTableAnimationVC : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    @protected NSMutableArray* results;
}
@property (assign, nonatomic) NSInteger reloadIdx;
@property (assign, nonatomic) int totalNumResults;

@property (assign, nonatomic) AnimationStyle  tableAnimationStyle;

@end
