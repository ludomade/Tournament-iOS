//
//  Match.m
//  Tournament
//
//  Created by Eugene Heckert on 5/8/15.
//  Copyright (c) 2015 Eugene Heckert. All rights reserved.
//

#import "Match.h"

@implementation Match

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"matchID":@"matchID",
             @"matchState":@"matchState",
             @"round":@"round",
             @"playerOneID":@"playerOneID",
             @"playerTwoID":@"playerTwoID",
             @"playerOneScore":@"playerOneScore",
             @"playerTwoScore":@"playerTwoScore",
             @"playerOnePreReqMatchID":@"playerOnePreReqMatchID",
             @"playerTwoPreReqMatchID":@"playerTwoPreReqMatchID",
             @"playerOnePreReqMatchLoser":@"playerOnePreReqMatchLoser",
             @"playerTwoPreReqMatchLoser":@"playerTwoPreReqMatchLoser",
             @"winnerID":@"winnerID",
             @"loserID":@"loserID"
             };
}

- (void)setNilValueForKey:(NSString *)key
{
    if([key isEqualToString:@"playerOneID"])
    {
        self.playerOneID = @"";
    }
    else
    if([key isEqualToString:@"playerTwoID"])
    {
        self.playerTwoID = @"";
    }
    else
    if([key isEqualToString:@"playerOnePreReqMatchID"])
    {
        self.playerOnePreReqMatchID = @"";
    }
    else
    if([key isEqualToString:@"playerTwoPreReqMatchID"])
    {
        self.playerTwoPreReqMatchID = @"";
    }
    else
    if([key isEqualToString:@"winnerID"])
    {
        self.winnerID = @"";
    }
    else
    if([key isEqualToString:@"loserID"])
    {
        self.loserID = @"";
    }
    else
    {
        [super setNilValueForKey:key];
    }
}

//+ (NSValueTransformer *)matchStateJSONTransformer
//{
//    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString* value, BOOL *success, NSError *__autoreleasing *error) {
//        return @([Match getMatchStateFromString:value]);
//    }];
//}

+ (MatchState)getMatchStateFromString:(NSString *)state
{
    
    if([[state uppercaseString] isEqualToString:[@"complete" uppercaseString]])
    {
        return MATCH_COMPLETE;
    }
    else
    if([[state uppercaseString] isEqualToString:[@"underway" uppercaseString]])
    {
        return MATCH_UNDERWAY;
    }
    else
    if([[state uppercaseString] isEqualToString:[@"pending" uppercaseString]])
    {
        return MATCH_PENDING;
    }
    else
    {
        return UNKNOWN_MATCH_STATE;
    }
}

+ (NSString *) getStringFromMatchState:(MatchState)state
{
    
    switch (state)
    {
        case MATCH_COMPLETE:
        {
            return @"complete";
            break;
        }
        case MATCH_UNDERWAY:
        {
            return @"underway";
            break;
        }
        case MATCH_PENDING:
        {
            return @"pending";
            break;
        }
        case UNKNOWN_MATCH_STATE:
        {
            return @"unknown";
            break;
        }
        default:
        {
            return @"unknown";
            break;
        }
    }
}

+ (NSArray *)parseMatchsFromJson:(NSArray *)json
{
    NSMutableArray* retArr = [NSMutableArray new];
    
    DLog(@"json: %@", json);
    
    [json enumerateObjectsUsingBlock:^(NSDictionary* dic, NSUInteger idx, BOOL *stop)
     {
         //NSDictionary* tournamentDic = [dic getDictionaryAttributeForKey:@"match"];
         
         DLog(@"dic: %@", dic);
         DLog(@"idx: %lu", (unsigned long)idx);
         
         if (dic)
         {
             NSError* error;
             Match* match = [MTLJSONAdapter modelOfClass:[Match class] fromJSONDictionary:dic error:&error];
             
             if (!error)
             {
                 DLog(@"match: %@", match);
                 [retArr addObject:match];
             }
         }
     }];
    
    DLog(@"retArr: %@", retArr);
    
    return retArr;
}

- (MatchState)getMatchState
{
    return [Match getMatchStateFromString:self.matchState];
}

@end
