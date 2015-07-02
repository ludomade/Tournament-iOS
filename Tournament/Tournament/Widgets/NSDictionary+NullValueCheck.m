//
//  NSDictionary+NullValueCheck.m
//  GameStop_iOS
//
//  Created by Andrew Wells on 7/14/14.
//  Copyright (c) 2014 Soap Creative. All rights reserved.
//

#import "NSDictionary+NullValueCheck.h"

#define DEFAULT_STRING_VALUE                @""
#define DEFAULT_NUM_VALUE                   0
#define DEFAULT_ARRAY_VALUE                 @[]
#define DEFAULT_DICTIONARY_VALUE            @{}
#define DEFAULT_BOOL_VALUE                  NO

@implementation NSDictionary (NullValueCheck)

- (BOOL)isEmpty
{
    return !self.count > 0;
}

- (BOOL)objNotNull:(id)obj
{
    return !([obj isKindOfClass:[NSNull class]]);
}

- (BOOL)objNull:(id)obj
{
    return [obj isKindOfClass:[NSNull class]];
}

- (BOOL)objIsString:(id)obj
{
    return [obj isKindOfClass:[NSString class]];
}

- (NSString*)getStringAttributeForKey:(NSString*)key
{
    if (!key)
    {
        return DEFAULT_STRING_VALUE;
    }
    
    if (![self objIsString:self[key]])
    {
        if ([self[key] isKindOfClass:[NSNumber class]])
        {
            return [self[key] stringValue];
        }
        else
        {
            return DEFAULT_STRING_VALUE;
        }
    }
    else
    if (!self[key])
    {
        return DEFAULT_STRING_VALUE;
    }
    
    NSString* retVal = self[key];
    return [retVal stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSArray*)getStringArrayAttributeForKey:(NSString*)key
{
    if (!key)
    {
        return DEFAULT_ARRAY_VALUE;
    }
    
    NSMutableArray* retVal;
    
    if (![self[key] isKindOfClass:[NSArray class]])
    {
        if ([self[key] isKindOfClass:[NSString class]])
        {
            return @[self[key]];
        }
        else
        if ([self[key] isKindOfClass:[NSNumber class]])
        {
            return @[[self[key] stringValue]];
        }
        else
        {
            return DEFAULT_ARRAY_VALUE;
        }
    }
    
    retVal = [self[key] mutableCopy];
    
    for (int i = 0; i < retVal.count; i++)
    {
        id obj = retVal[i];
        if (![self objIsString:obj])
        {
            [retVal setObject:DEFAULT_STRING_VALUE atIndexedSubscript:i];
        }
    }
    
    return [NSArray arrayWithArray:retVal];
}

- (NSArray*)getArrayAttributeForKey:(NSString*)key
{
    if (!key)
    {
        return DEFAULT_ARRAY_VALUE;
    }
    
    if (![self[key] isKindOfClass:[NSArray class]])
    {
        if ([self[key] isKindOfClass:[NSString class]])
        {
            return @[self[key]];
        }
        else
        if ([self[key] isKindOfClass:[NSNumber class]])
        {
            return @[[self[key] stringValue]];
        }
        else
        {
            return DEFAULT_ARRAY_VALUE;
        }
    }
    
    NSMutableArray* retArr = [self[key] mutableCopy];
    for (int i = (int)retArr.count - 1; i >= 0; i--)
    {
        if ([retArr[i] isKindOfClass:[NSNull class]])
        {
            [retArr removeObjectAtIndex:i];
        }
    }
    
    return retArr;
}

- (NSDictionary*)getDictionaryAttributeForKey:(NSString*)key
{
    if (!key)
    {
        return DEFAULT_DICTIONARY_VALUE;
    }
    
    if (![self[key] isKindOfClass:[NSDictionary class]])
    {
        return DEFAULT_DICTIONARY_VALUE;
    }
    
    return self[key];
}

- (double)getDoubleAttributeForKey:(NSString*)key
{
    if (!key)
    {
        return DEFAULT_NUM_VALUE;
    }
    
    if ([self[key] isKindOfClass:[NSNull class]])
    {
        return DEFAULT_NUM_VALUE;
    }
    else
    if ([self objIsString:self[key]])
    {
        return [self[key] doubleValue];
    }
    else
    if (!self[key])
    {
        return DEFAULT_NUM_VALUE;
    }
    
    return [self[key] doubleValue];
}

- (float)getFloatAttributeForKey:(NSString*)key
{
    if (!key)
    {
        return DEFAULT_NUM_VALUE;
    }
    
    if ([self[key] isKindOfClass:[NSNull class]])
    {
        return DEFAULT_NUM_VALUE;
    }
    else
    if ([self objIsString:self[key]])
    {
        return [self[key] floatValue];
    }
    else
    if (!self[key])
    {
        return DEFAULT_NUM_VALUE;
    }
    
    return [self[key] floatValue];

}

- (NSInteger)getIntegerAttributeForKey:(NSString*)key
{
    if (!key)
    {
        return DEFAULT_NUM_VALUE;
    }
    
    if ([self[key] isKindOfClass:[NSNull class]])
    {
        return DEFAULT_NUM_VALUE;
    }
    
    return [self[key] integerValue];
}

- (NSNumber*)getNumberAttributeForKey:(NSString*)key
{
    NSNumber* number = [NSNumber numberWithInt:DEFAULT_NUM_VALUE];
    if (!key)
    {
        
        return number;
    }
    
    if (![self[key] isKindOfClass:[NSNumber class]])
    {
        
        if ([self[key] isKindOfClass:[NSString class]])
        {
            number = [NSNumber numberWithFloat:[self[key] floatValue]];
            return number;
        }
        
        return number;
    }
    
    number = self[key];
    
    return number;
    
}

- (BOOL)getBOOLAttributeForKey:(NSString*)key
{
    if (!key)
        return DEFAULT_BOOL_VALUE;
    
    if ([self objNull:self[key]])
    {
        return DEFAULT_BOOL_VALUE;
    }
    
    return [self[key] boolValue];
    
}

- (NSArray*)getDictionaryArrayAttributeForKey:(NSString*)key
{
    if (!key)
    {
        return DEFAULT_ARRAY_VALUE;
    }
    
    NSMutableArray* retVal;
    
    if (![self[key] isKindOfClass:[NSArray class]])
    {
        if ([self[key] isKindOfClass:[NSDictionary class]])
        {
            NSDictionary* dic = [self getDictionaryAttributeForKey:key];
            return @[dic];
        }
        else
        if ([self[key] isKindOfClass:[NSString class]])
        {
            return @[self[key]];
        }
        else
        {
            return DEFAULT_ARRAY_VALUE;
        }
    }
    
    retVal = [self[key] mutableCopy];
    
    for (int i = (int)retVal.count - 1; i >= 0; i--)
    {
        id obj = retVal[i];
        if (![obj isKindOfClass:[NSDictionary class]])
        {
            [retVal removeObjectAtIndex:i];
        }
    }
    
    return [NSArray arrayWithArray:retVal];

}

- (NSDate*)getDateAttributeForKey:(NSString*)key
{
    if (!key)
    {
        return nil;
    }
    
    if ([self objNull:self[key]])
    {
        return nil;
    }
    
    long long milliseconds = [self[key] longLongValue];
    if (milliseconds == 0)
    {
        return nil;
    }
    
    return [NSDate dateWithTimeIntervalSince1970:milliseconds / 1000.0f];
    
}


@end
