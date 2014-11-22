//
//  MyPattern.h
//  KotsuhiCalculator
//
//  Created by 藤原 達郎 on 2014/05/08.
//  Copyright (c) 2014年 Tatsuo Fujiwara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyPattern : NSObject

@property int mypatternid;

@property (strong, nonatomic, readwrite) NSString *patternName;
@property (strong, nonatomic, readwrite) NSString *visit;
@property (strong, nonatomic, readwrite) NSString *departure;
@property (strong, nonatomic, readwrite) NSString *arrival;
@property (strong, nonatomic, readwrite) NSString *transportation;
@property int amount;
@property (strong, nonatomic, readwrite) NSString *purpose;
@property (strong, nonatomic, readwrite) NSString *route;
@property BOOL roundtrip;

- (NSData*)getMyPatternNSData;

+ (MyPattern*)makeMyPattern:(NSData*)data;

- (NSComparisonResult)compareMyPatternId:(MyPattern*)data;

- (int)getTripAmount;
- (NSString*)getRoundTripString;
- (NSString*)getTripArrow;

@end
