//
//  Tournament.h
//  Tournament
//
//  Created by Eugene Heckert on 5/7/15.
//  Copyright (c) 2015 Eugene Heckert. All rights reserved.
//

#import <Parse/Parse.h>

@class Participant;

typedef enum
{
    DOUBLE_ELIMINATION,
    SINGLE_ELIMINATION,
    ROUND_ROBIN,
    SWISS,
    UNKNOWN_TOURNAMENT_TYPE
    
} tournamentType;

typedef enum
{
    TOURNAMENT_COMPLETE,
    TOURNAMENT_AWAITING_REVIEW,
    TOURNAMENT_UNDERWAY,
    TOURNAMENT_PENDING,
    UNKNOWN_TOURNAMENT_STATE
    
} tournamentState;

typedef enum
{
    MATCH_WINS,
    GAME_SET_WINS,
    GAME_SET_WINS_PERCENT,
    POINTS_SCORED,
    POINTS_DIFFERENCE,
    CUSTOM,
    UNKNOWN_TOURNAMENT_RANKED_BY
    
} tournamentRankedBy;

@interface Tournament : PFObject <PFSubclassing>

@property (nonatomic, strong) NSString* objectId;
@property (nonatomic, strong) NSDate* createdAt;
@property (nonatomic, strong) NSDate* updatedAt;
@property (nonatomic, strong) NSString* createdBy;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* tournamentType;
@property (nonatomic, strong) NSString* state;
@property (nonatomic, strong) NSString* rankedBy;
@property (nonatomic, assign) BOOL quickAdvance;
@property (nonatomic, assign) BOOL holdThirdPlaceMatch;
@property (nonatomic, strong) NSString* gameName;
@property (nonatomic, assign) int participantsCount;

@property (nonatomic, assign) int maxNumberRounds;

@property (nonatomic, strong) NSArray* tournamentMatchesDictAr;
@property (nonatomic, strong) NSArray* tournamentParticipantsDictAr;

@property (nonatomic, strong) NSArray* tournamentMatches;
@property (nonatomic, strong) NSArray* tournamentParticipants;

+ (tournamentType)getTournamentTypeFromString:(NSString*)type;
+ (tournamentState)getTournamentStateFromString:(NSString*)state;
+ (tournamentRankedBy)getTournamentRankedByFromString:(NSString*)rankedBy;

- (tournamentType)getTournamentType;
- (tournamentState)getTournamentState;
- (tournamentRankedBy)getTournamentRanked;

- (void) convertMatches;
- (void) convertParticipants;

- (Participant*) getParticipantByID:(NSString*)partID;

- (void) saveTournament;

@end




