//
//  Match.h
//  Tournament
//
//  Created by Eugene Heckert on 5/8/15.
//  Copyright (c) 2015 Eugene Heckert. All rights reserved.
//

#import "Tournament.h"

typedef enum
{
    MATCH_COMPLETE,
    MATCH_UNDERWAY,
    MATCH_PENDING,
    UNKNOWN_MATCH_STATE
    
} MatchState;

@interface Match : MTLModel < MTLJSONSerializing>

@property (nonatomic, strong) NSString* matchID;
@property (nonatomic, strong) NSString* matchState;
@property (nonatomic, assign) int round;
@property (nonatomic, strong) NSString* playerOneID;
@property (nonatomic, strong) NSString* playerTwoID;
@property (nonatomic, assign) int playerOneScore;
@property (nonatomic, assign) int playerTwoScore;
@property (nonatomic, strong) NSString* playerOnePreReqMatchID;
@property (nonatomic, strong) NSString* playerTwoPreReqMatchID;
@property (nonatomic, strong) NSString* playerOnePreReqMatchLoser;
@property (nonatomic, strong) NSString* playerTwoPreReqMatchLoser;
@property (nonatomic, strong) NSString* winnerID;
@property (nonatomic, strong) NSString* loserID;

+ (NSArray*) parseMatchsFromJson:(NSArray*)json;

+ (NSString*) getStringFromMatchState:(MatchState)state;

- (MatchState) getMatchState;

@end
