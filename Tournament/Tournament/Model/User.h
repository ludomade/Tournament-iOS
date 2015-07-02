//
//  User.h
//  Tournament
//
//  Created by Eugene Heckert on 5/7/15.
//  Copyright (c) 2015 Eugene Heckert. All rights reserved.
//

#import <Parse/Parse.h>

@class Tournament;

@interface User : PFUser <PFSubclassing>

@property(nonatomic, strong) NSString* challongeAPIKey;

@property(nonatomic, strong) NSMutableArray* tournamentNames;
@property(nonatomic, strong) NSMutableArray* tournamentIDs;

- (BOOL) isTournamentNameUnique:(NSString*)name;

- (void) newTournamentName:(NSString*)name;

- (void) removeTournamentName:(NSString*)name;

@end
