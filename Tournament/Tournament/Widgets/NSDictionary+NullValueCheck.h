//
//  NSDictionary+NullValueCheck.h
//  GameStop_iOS
//
//  Created by Andrew Wells on 7/14/14.
//  Copyright (c) 2014 Soap Creative. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (NullValueCheck)

- (BOOL)isEmpty;

- (NSString*)getStringAttributeForKey:(NSString*)key;

- (NSDictionary*)getDictionaryAttributeForKey:(NSString*)key;

// Numbers
- (NSInteger)getIntegerAttributeForKey:(NSString*)key;
- (NSNumber*)getNumberAttributeForKey:(NSString*)key;
- (double)getDoubleAttributeForKey:(NSString*)key;
- (float)getFloatAttributeForKey:(NSString*)key;

// Arrays
- (NSArray*)getArrayAttributeForKey:(NSString*)key;
- (NSArray*)getStringArrayAttributeForKey:(NSString*)key;
- (NSArray*)getDictionaryArrayAttributeForKey:(NSString*)key;

- (NSDate*)getDateAttributeForKey:(NSString*)key;

- (BOOL)getBOOLAttributeForKey:(NSString*)key;

@end
