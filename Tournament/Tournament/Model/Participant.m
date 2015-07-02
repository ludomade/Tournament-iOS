//
//  Participant.m
//  Tournament
//
//  Created by Eugene Heckert on 5/8/15.
//  Copyright (c) 2015 Eugene Heckert. All rights reserved.
//

#import "Participant.h"

@implementation Participant

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"participantID":@"participantID",
             @"name":@"name",
             @"userName":@"userName",
             @"displayName":@"displayName"
             };
}

- (void)setNilValueForKey:(NSString *)key
{
    {
        [super setNilValueForKey:key];
    }
}

+ (NSArray *)parseParticipantsFromJson:(NSArray *)json
{
    NSMutableArray* retArr = [NSMutableArray new];
    
    [json enumerateObjectsUsingBlock:^(NSDictionary* dic, NSUInteger idx, BOOL *stop)
     {
         //NSDictionary* participantDic = [dic getDictionaryAttributeForKey:@"participant"];
         
         if (dic)
         {
             NSError* error;
             Participant* participant = [MTLJSONAdapter modelOfClass:[Participant class] fromJSONDictionary:dic error:&error];
             
             if (!error)
             {
                 [retArr addObject:participant];
             }
         }
     }];
    
    return retArr;
}

@end
