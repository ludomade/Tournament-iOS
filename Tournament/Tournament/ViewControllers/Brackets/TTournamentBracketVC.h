//
//  TTournamentBracketVC.h
//  Tournament
//
//  Created by Eugene Heckert on 6/18/15.
//  Copyright (c) 2015 Eugene Heckert. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Tournament;

@interface TTournamentBracketVC : UIViewController
{
}

@property(nonatomic, strong, readonly) Tournament* selectedTournament;

- (void) loadTournament:(Tournament*)tour;

@end
