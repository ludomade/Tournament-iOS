//
//  TNoDataView.h
//  Tournament
//
//  Created by Eugene Heckert on 6/26/15.
//  Copyright (c) 2015 Eugene Heckert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TNoDataView : UIView

@property (weak, nonatomic) IBOutlet UIView *mainView;

@property (weak, nonatomic) IBOutlet UILabel *noDataLabel;

+ (TNoDataView*)sharedInstance;

- (void)showNoDataView:(UIView *)view WithText:(NSString*)text;
- (void)removeNoDataView;

@end
