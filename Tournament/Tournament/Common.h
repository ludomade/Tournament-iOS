//
//  Common.h
//  Tournament
//
//  Created by Eugene Heckert on 5/7/15.
//  Copyright (c) 2015 Eugene Heckert. All rights reserved.
//

#ifndef Tournament_Common_h
#define Tournament_Common_h


#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...);
#endif

// ALog always displays output regardless of the DEBUG setting
#define ALog(fmt, ...)       NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);


//A test to see if you phone has the screen size of the iPhone 5
#define IS_IPHONE_5_OR_GREATER  (([[UIScreen mainScreen] bounds].size.height >= 568.0f)? YES : NO)

//A test to see if you phone has the screen size of the iPhone 5
#define IS_IPHONE_6_OR_GREATER  (([[UIScreen mainScreen] respondsToSelector:@selector(nativeScale)]) ? ((([UIScreen mainScreen].nativeScale > [UIScreen mainScreen].scale) || [[UIScreen mainScreen] bounds].size.height >= 736.0f)? YES : NO) : NO)

//A nice way to do programmatic color codes
#define RGB(x)                  ((x)/255.0)

#ifdef DEBUG

#define PREFILL_LOGIN       1

#else

#define PREFILL_LOGIN       0

#endif

#endif

#define LUDOMADE_YELLOW     [UIColor colorWithRed:RGB(255.0f) green:RGB(191.0f) blue:RGB(0.0f) alpha:1.0f]
#define LUDOMADE_SLATE      [UIColor colorWithRed:RGB(26.0f) green:RGB(23.0f) blue:RGB(24.0f) alpha:1.0f]
#define LIGHT_GREY          [UIColor colorWithRed:RGB(79.0f) green:RGB(79.0f) blue:RGB(79.0f) alpha:1.0f]

#define NAV_ARROW_TAG                   3939

//Segue
#define TOURNAMENT_SINGLE_ELIMINATION_BRACKET_SEGUE                 @"To Single Elimination Bracket Segue"
#define TOURNAMENT_DOUBLE_ELIMINATION_BRACKET_SEGUE                 @"To Double Elimination Bracket Segue"
#define TOURNAMENT_SWISS_BRACKET_SEGUE                              @"To Swiss Bracket Segue"
#define TOURNAMENT_ROUND_ROBIN_BRACKET_SEGUE                        @"To Round Robin Bracket Segue"
