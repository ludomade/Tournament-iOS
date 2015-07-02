//
//  TTournamentCell.h
//  Tournament
//
//  Created by Eugene Heckert on 5/7/15.
//  Copyright (c) 2015 Eugene Heckert. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Tournament;

@interface TTournamentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *tournamentNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *tournamentTypeLabel;

@property (weak, nonatomic) IBOutlet UILabel *gameNameLabel;

- (void) loadTournament:(Tournament*)tour;

@end
