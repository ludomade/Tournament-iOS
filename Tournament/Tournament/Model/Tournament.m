//
//  Tournament.m
//  Tournament
//
//  Created by Eugene Heckert on 5/7/15.
//  Copyright (c) 2015 Eugene Heckert. All rights reserved.
//

#import "Tournament.h"
#import "Match.h"
#import "Participant.h"

@implementation Tournament

@dynamic objectId;
@dynamic createdAt;
@dynamic updatedAt;
@dynamic createdBy;
@dynamic name;
@dynamic tournamentType;
@dynamic state;
@dynamic rankedBy;
@dynamic quickAdvance;
@dynamic holdThirdPlaceMatch;
@dynamic gameName;
@dynamic participantsCount;

@dynamic maxNumberRounds;

@dynamic tournamentMatchesDictAr;
@dynamic tournamentParticipantsDictAr;

@synthesize tournamentMatches;
@synthesize tournamentParticipants;

+(NSString *)parseClassName
{
    return @"Tournament";
}

+ (tournamentType)getTournamentTypeFromString:(NSString*)type
{
    
    if([[type uppercaseString] isEqualToString:[@"double elimination" uppercaseString]])
    {
        return DOUBLE_ELIMINATION;
    }
    else
    if([[type uppercaseString] isEqualToString:[@"single elimination" uppercaseString]])
    {
        return SINGLE_ELIMINATION;
    }
    if([[type uppercaseString] isEqualToString:[@"swiss" uppercaseString]])
    {
        return SWISS;
    }
    if([[type uppercaseString] isEqualToString:[@"round robin" uppercaseString]])
    {
        return ROUND_ROBIN;
    }
    else
    {
        return UNKNOWN_TOURNAMENT_TYPE;
    }
    
}

+ (tournamentState)getTournamentStateFromString:(NSString *)state
{
    
    if([[state uppercaseString] isEqualToString:[@"complete" uppercaseString]])
    {
        return TOURNAMENT_COMPLETE;
    }
    else
    if([[state uppercaseString] isEqualToString:[@"awaiting_review" uppercaseString]])
    {
        return TOURNAMENT_AWAITING_REVIEW;
    }
    else
    if([[state uppercaseString] isEqualToString:[@"underway" uppercaseString]])
    {
        return TOURNAMENT_UNDERWAY;
    }
    else
    if([[state uppercaseString] isEqualToString:[@"pending" uppercaseString]])
    {
        return TOURNAMENT_PENDING;
    }
    else
    {
        return UNKNOWN_TOURNAMENT_STATE;
    }
}

+ (tournamentRankedBy)getTournamentRankedByFromString:(NSString *)rankedBy
{
    
    if([[rankedBy uppercaseString] isEqualToString:[@"" uppercaseString]])
    {
        return MATCH_WINS;
    }
    else
    if([[rankedBy uppercaseString] isEqualToString:[@"" uppercaseString]])
    {
        return GAME_SET_WINS;
    }
    else
    if([[rankedBy uppercaseString] isEqualToString:[@"" uppercaseString]])
    {
        return GAME_SET_WINS_PERCENT;
    }
    else
    if([[rankedBy uppercaseString] isEqualToString:[@"" uppercaseString]])
    {
        return POINTS_SCORED;
    }
    else
    if([[rankedBy uppercaseString] isEqualToString:[@"" uppercaseString]])
    {
        return POINTS_DIFFERENCE;
    }
    else
    if([[rankedBy uppercaseString] isEqualToString:[@"" uppercaseString]])
    {
        return CUSTOM;
    }
    else
    {
        return UNKNOWN_TOURNAMENT_RANKED_BY;
    }
}

- (tournamentType) getTournamentType
{
    return [Tournament getTournamentTypeFromString:self.tournamentType];
}

- (tournamentState)getTournamentState
{
    return [Tournament getTournamentStateFromString:self.state];
}

- (tournamentRankedBy)getTournamentRanked
{
    return [Tournament getTournamentRankedByFromString:self.rankedBy];
}

- (void) convertMatches
{
    NSArray* tempAR = [Match parseMatchsFromJson:self.tournamentMatchesDictAr];
    
    self.tournamentMatches = tempAR;
}

- (void) convertParticipants
{
    self.tournamentParticipants = [Participant parseParticipantsFromJson:self.tournamentParticipantsDictAr];
}

- (Participant*)getParticipantByID:(NSString*)partID
{
    for(Participant* participant in self.tournamentParticipants)
    {
        if([participant.participantID isEqualToString: partID])
        {
            return participant;
        }
    }
    
    return nil;
}

- (void)saveTournament
{
    for(Match* match in self.tournamentMatches)
    {
        for(NSMutableDictionary* matchDict in self.tournamentMatchesDictAr)
        {
            if([match.matchID isEqualToString:matchDict[@"matchID"]])
            {
                [matchDict setObject:match.matchState forKey:@"matchState"];
                
                [matchDict setObject:match.playerOneID forKey:@"playerOneID"];
                [matchDict setObject:match.playerTwoID forKey:@"playerTwoID"];
                
                [matchDict setObject:[NSNumber numberWithInt:match.playerOneScore] forKey:@"playerOneScore"];
                [matchDict setObject:[NSNumber numberWithInt:match.playerTwoScore] forKey:@"playerTwoScore"];
                
                [matchDict setObject:match.winnerID forKey:@"winnerID"];
                [matchDict setObject:match.loserID forKey:@"loserID"];
            }
        }
    }
    
    [self save];
}


@end
