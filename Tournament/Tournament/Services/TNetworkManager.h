//
//  NetworkManager.h
//  Tournament
//
//  Created by Eugene Heckert on 5/7/15.
//  Copyright (c) 2015 Eugene Heckert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import <Mantle/Mantle.h>
#import "AFNetworking.h"
#import <Parse/Parse.h>

@class User;

@interface TNetworkManager : NSObject

@property (strong, nonatomic) User *user;

+ (TNetworkManager *) sharedInstance;

//- (void) saveUser;

//- (RACSignal *)getUsers;

//- (RACSignal *)loginUser:(User*)user;

//- (RACSignal *)getTournaments;

- (RACSignal *)importTournamentDetails:(int)tournameID;

- (RACSignal *)importChallongeTournaments;

- (RACSignal *)getTournamentList;

- (RACSignal *)getTournamentDetail:(NSString*)objectID;

@end
