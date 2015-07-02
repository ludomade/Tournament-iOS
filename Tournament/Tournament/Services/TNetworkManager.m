//
//  NetworkManager.m
//  Tournament
//
//  Created by Eugene Heckert on 5/7/15.
//  Copyright (c) 2015 Eugene Heckert. All rights reserved.
//

#import "TNetworkManager.h"
#import "NetworkManagerDefaultKeyValues.h"
#import "User.h"
#import "Tournament.h"
#import "Match.h"
#import "Participant.h"

#define kDefaultRequestTimeout 180.0

@interface TNetworkManager ()

@property (strong, nonatomic) AFHTTPRequestOperationManager* manager;
@property (strong, nonatomic) NSString* baseURLString;
@property (strong, nonatomic) NSDictionary* servicesJson;
@property (strong, nonatomic) NSDictionary* requestDict;

@end

@implementation TNetworkManager


+ (TNetworkManager *) sharedInstance
{
    static TNetworkManager *sharedServiceFacade = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedServiceFacade = [self new];
    });
    
    return sharedServiceFacade;
}


- (TNetworkManager *) init
{
    self = [super init];
    
    if (self)
    {
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Services" ofType:@"json"];
        
        NSError *error = nil;
        
        NSData *JSONData = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:&error];
        
        self.servicesJson = [NSJSONSerialization JSONObjectWithData:JSONData options:0 error:&error];
        
        NSDictionary* environDict = [self.servicesJson getDictionaryAttributeForKey:SERVICES_ENVIRONMENTS];
        NSDictionary* selectedEnvDict = [environDict getDictionaryAttributeForKey:SERVICES_SELECTED_ENVIRONMENT];
        
        NSString* baseURI = [selectedEnvDict getStringAttributeForKey:SERVICES_BASE_URI];
        NSString* version = [selectedEnvDict getStringAttributeForKey:SERVICES_VERSION];
        
        self.baseURLString = [NSString stringWithFormat:@"%@%@",baseURI, version];
        
        self.manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:self.baseURLString]];
        self.manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [self.manager.requestSerializer setTimeoutInterval:20];
        [self.manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"content-type"];
        [self.manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"accept"];
        self.manager.securityPolicy.allowInvalidCertificates = YES;
        
        self.requestDict = [self.servicesJson getDictionaryAttributeForKey:SERVICES_REQUESTS];
        
        NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
        
        NSData* userData = [userDefaults objectForKey:DEFAULTS_USER];
        
        self.user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
        
    }
    
    return self;
}

- (User *)user
{
    return [User currentUser];
}

-(NSURLRequest*) createPOSTRequestFromURL:(NSString *)url withData:(NSData *)postData
{
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    [req setHTTPMethod:@"POST"];
    [req setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req setHTTPBody:postData];
    [req setTimeoutInterval:kDefaultRequestTimeout];
    
    return req;
}


-(NSURLRequest*) createGETRequestFromURL:(NSString *)url
{
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [req setHTTPMethod:@"GET"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req setTimeoutInterval:kDefaultRequestTimeout];
    
    return req;
}

//- (RACSignal *)getTournaments
//{
//    NSMutableDictionary* parameters = [NSMutableDictionary new];
//    
//    [parameters setObject:self.user[@"challongeAPIKey"] forKey:@"api_key"];
//    
//    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        [self.manager GET:@"tournaments" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
//         {
//             
//             for(NSDictionary* dict in responseObject)
//             {
//                 PFObject* tournament = [PFObject objectWithClassName:@"Tournament"];
//                 
//                 NSDictionary* tournamentDict = dict[@"tournament"];
//                 
//                 for(NSString* key in [tournamentDict allKeys])
//                 {
//                     if([key isEqualToString:@"id"])
//                     {
//                         tournament[@"tournament_id"] = tournamentDict[key];
//                     }
//                     else
//                     {
//                         tournament[key] = tournamentDict[key];
//                     }
//                 }
//                 
//                 tournament[@"Creator_Name"] = self.user.username;
//                 
////                 [tournament saveInBackground];
//             }
//             
//             NSArray* tournaments = [Tournament parseTournamentsFromJson:responseObject];
//             
//#if NETWORK_MANAGER_LOG_LEVEL >= LOG_LEVEL_VERBOSE
//             DLog(@"responseObject: %@", responseObject);
//             DLog(@"tournaments: %@", tournaments);
//#endif
//             
//             [subscriber sendNext:tournaments];
//             [subscriber sendCompleted];
//             
//         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//             
//#if NETWORK_MANAGER_LOG_LEVEL >= LOG_LEVEL_ERROR
//                 DLog(@"error: %@", error);
//#endif
//             
//             [subscriber sendError:error];
//         }];
//        
//        return nil;
//    }];
//    
//}

- (RACSignal *)importTournamentDetails:(int)tournametID
{
    NSMutableDictionary* parameters = [NSMutableDictionary new];
    
    [parameters setObject:self.user[@"challongeAPIKey"] forKey:@"api_key"];
    
    [parameters setObject:[NSNumber numberWithInt:1] forKey:@"include_participants"];
    
    [parameters setObject:[NSNumber numberWithInt:1] forKey:@"include_matches"];
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self.manager GET:[NSString stringWithFormat:@"tournaments/%i", tournametID] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSDictionary* participants = responseObject[@"tournament"][@"participants"];
             NSDictionary* matches = responseObject[@"tournament"][@"matches"];
             
             NSMutableArray* matchesAR = [NSMutableArray new];
             NSMutableArray* participantsAR = [NSMutableArray new];
             
             for(NSDictionary* dict in participants)
             {
                 NSMutableDictionary* participant = [NSMutableDictionary new];
                 
                 NSDictionary* participantDict = dict[@"participant"];
                 
                 for(NSString* key in [participantDict allKeys])
                 {
                     if([key isEqualToString:@"id"])
                     {
                         [participant setObject:participantDict[key] forKey:@"participant_id"];
                     }
                     else
                     {
                         [participant setObject:participantDict[key] forKey:key];
                     }
                 }
                 
                 [participantsAR addObject:participant];
             }
             
             for(NSDictionary* dict in matches)
             {
                 
                 NSMutableDictionary* match = [NSMutableDictionary new];
                 
                 NSDictionary* matchDict = dict[@"match"];
                 
                 for(NSString* key in [matchDict allKeys])
                 {
                     DLog(@"Match Key: %@", key);
                     if([key isEqualToString:@"id"])
                     {
                         [match setObject:matchDict[key] forKey:@"match_id"];
                     }
                     else
                     {
                         [match setObject:matchDict[key] forKey:key];
                     }
                 }
                 
                 [matchesAR addObject:match];
             }
             
             PFObject* tournament = [PFObject objectWithClassName:@"Tournament"];
             
             NSDictionary* tournamentDict = responseObject[@"tournament"];
             
             for(NSString* key in [tournamentDict allKeys])
             {
                 
                 if([key isEqualToString:@"id"])
                 {
                     tournament[@"tournament_id"] = tournamentDict[key];
                 }
                 else
                 if([key isEqualToString:@"matches"])
                 {
                     
                 }
                 else
                 if([key isEqualToString:@"participants"])
                 {
                     
                 }
                 else
                 {
                     tournament[key] = tournamentDict[key];
                 }
             }
             
             tournament[@"Matches"] = matchesAR;
             tournament[@"Participants"] = participantsAR;
             
             tournament[@"Creator_Name"] = self.user.username;
             [tournament saveInBackground];
             
             [subscriber sendCompleted];
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
#if NETWORK_MANAGER_LOG_LEVEL >= LOG_LEVEL_ERROR
             DLog(@"error: %@", error);
#endif
             
             [subscriber sendError:error];
         }];
        
        return nil;
    }];
}


- (RACSignal *)importChallongeTournaments
{
    NSMutableDictionary* parameters = [NSMutableDictionary new];
    
    [parameters setObject:self.user[@"challongeAPIKey"] forKey:@"api_key"];
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self.manager GET:@"tournaments" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             
             for(NSDictionary* dict in responseObject)
             {
                 PFObject* tournament = [PFObject objectWithClassName:@"Tournament"];
                 
                 NSDictionary* tournamentDict = dict[@"tournament"];
                 
                 for(NSString* key in [tournamentDict allKeys])
                 {
                     if([key isEqualToString:@"id"])
                     {
                         tournament[@"tournament_id"] = tournamentDict[key];
                     }
                     else
                     {
                         tournament[key] = tournamentDict[key];
                     }
                 }
                 
                 tournament[@"Creator_Name"] = self.user.username;
                 
                 [tournament saveInBackground];
             }
             
             for(NSDictionary* dict in responseObject)
             {
                 NSDictionary* tournamentDict = dict[@"tournament"];
                 [[self importTournamentDetails:[tournamentDict[@"id"] intValue]] subscribeCompleted:^{
                     
                     DLog(@"Complete");
                     
                 }];
             }
             
#if NETWORK_MANAGER_LOG_LEVEL >= LOG_LEVEL_VERBOSE
             DLog(@"responseObject: %@", responseObject);
#endif
             [subscriber sendCompleted];
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
#if NETWORK_MANAGER_LOG_LEVEL >= LOG_LEVEL_ERROR
             DLog(@"error: %@", error);
#endif
             
             [subscriber sendError:error];
         }];
        
        return nil;
    }];
    
}

- (RACSignal *)getTournamentList
{
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        PFQuery* query = [PFQuery queryWithClassName:@"Tournament"];
        
        [query whereKey:@"createdBy" equalTo:self.user.username];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray* tournamentList, NSError *error) {
            
            
            if(error)
            {
                [subscriber sendError:error];
            }
            else
            {
                [subscriber sendNext:tournamentList];
                [subscriber sendCompleted];
            }
            
        }];
        
        return nil;
    }];
}

- (RACSignal *)getTournamentDetail:(NSString*)objectID
{
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        PFQuery* query = [PFQuery queryWithClassName:@"Tournament"];
        
        [query getObjectInBackgroundWithId:objectID block:^(PFObject *tournament, NSError *error) {
            // Do something with the returned PFObject in the tournament variable.
            
            NSMutableDictionary* tournamentDetailsDict = [NSMutableDictionary new];
            
            for(NSString* key in [tournament allKeys])
            {
                [tournamentDetailsDict setObject:tournament[key] forKey:key];
            }
            
            Tournament* detailedTournament = [MTLJSONAdapter modelOfClass:[Tournament class] fromJSONDictionary:tournamentDetailsDict error:&error];
            
            for(Match* match in detailedTournament.tournamentMatches)
            {
                if(match.round > detailedTournament.maxNumberRounds)
                {
                    detailedTournament.maxNumberRounds = match.round;
                }
            }
            
            if(error)
            {
                [subscriber sendError:error];
            }
            else
            {
                [subscriber sendNext:detailedTournament];
                
                [subscriber sendCompleted];
            }
        }];
        
        return nil;
    }];
    
}

@end
