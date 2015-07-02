//
//  User.m
//  Tournament
//
//  Created by Eugene Heckert on 5/7/15.
//  Copyright (c) 2015 Eugene Heckert. All rights reserved.
//

#import "User.h"
#import "Tournament.h"

@interface User ()

@end

@implementation User

@dynamic challongeAPIKey;
@dynamic tournamentNames;
@dynamic tournamentIDs;

+ (User*) currentUser
{
    return (User*)[PFUser currentUser];
}

- (BOOL) isTournamentNameUnique:(NSString*)name
{
    if(!self.tournamentNames)
    {
        self.tournamentNames = [NSMutableArray new];
    }
    
    return [self.tournamentNames containsObject:name];
}

- (void)newTournamentName:(NSString*)name
{
    if(!self.tournamentNames)
    {
        self.tournamentNames = [NSMutableArray new];
    }
    
    if(![self.tournamentNames containsObject:name])
    {
        [self.tournamentNames addObject:name];
    }
}

- (void)removeTournamentName:(NSString*)name
{
    if(!self.tournamentNames)
    {
        self.tournamentNames = [NSMutableArray new];
    }
    
    if([self.tournamentNames containsObject:name])
    {
        [self.tournamentNames removeObject:name];
    }
}

//- (void)newTournament:(Tournament *)tournament
//{
//    if(!self[@"tournamentNames"])
//    {
//        self[@"tournamentNames"] = [NSMutableArray new];
//    }
//    
//    [self[@"tournamentNames"] addObject:tournament.name];
//    
//    if(!self[@"tournamentIDs"])
//    {
//        self[@"tournamentIDs"] = [NSMutableArray new];
//    }
//    
//    [self[@"tournamentIDs"] addObject:tournament.objectId];
//}
//
//- (NSString *)challongeAPIKey
//{
//    return self[@"challongeAPIKey"];
//}
//
//- (NSMutableArray *)tournamentNames
//{
//    return self[@"tournamentNames"];
//}
//
//- (NSMutableArray *)tournamentIDs
//{
//    return self[@"tournamentIDs"];
//}

@end
