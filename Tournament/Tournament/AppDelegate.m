//
//  AppDelegate.m
//  Tournament
//
//  Created by Eugene Heckert on 5/7/15.
//  Copyright (c) 2015 Eugene Heckert. All rights reserved.
//
#import <Parse/Parse.h>
#import <ParseCrashReporting/ParseCrashReporting.h>

#import "AppDelegate.h"

#import "Tournament.h"
#import "User.h"
#import "Match.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    //[self clearUserDefaults];
    
    [self loadSubclasses];
    
    [Parse enableLocalDatastore];
    
    [ParseCrashReporting enable];
    
    NSDictionary* keysDictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"keys" ofType:@"plist"]];
    
    NSString* applicationId = keysDictionary[@"parseApplicationId"];
    NSString* clientKey = keysDictionary[@"parseClientKey"];
    
    [Parse setApplicationId:applicationId clientKey:clientKey];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    [[User currentUser] fetch];
    
//    [PFUser currentUser].password = @"123456";
    
//    [PFUser logOut];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void) clearUserDefaults
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary* dict = [defaults dictionaryRepresentation];
    
    for(NSString* key in dict)
    {
        [defaults removeObjectForKey:key];
    }
    
    [defaults synchronize];
}

- (void) loadSubclasses
{
    [Tournament registerSubclass];
    [User registerSubclass];
//    [Match registerSubclass];
}

@end
