//
//  Participant.h
//  Tournament
//
//  Created by Eugene Heckert on 5/8/15.
//  Copyright (c) 2015 Eugene Heckert. All rights reserved.
//

#import "User.h"

@interface Participant : MTLModel < MTLJSONSerializing>

@property (nonatomic, strong) NSString* participantID;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) User* parseUser;
@property (nonatomic, strong) NSString* userName;
@property (nonatomic, strong) NSString* displayName;

+ (NSArray*) parseParticipantsFromJson:(NSArray*)json;

@end
