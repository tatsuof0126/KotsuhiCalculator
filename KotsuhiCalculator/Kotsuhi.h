//
//  Kotsuhi.h
//  KotsuhiCalculator
//
//  Created by 藤原 達郎 on 2014/05/06.
//  Copyright (c) 2014年 Tatsuo Fujiwara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Kotsuhi : NSObject

@property (strong, nonatomic, readwrite) NSString *UUID;
@property int kotsuhiid;
@property int year;
@property int month;
@property int day;

@property (strong, nonatomic, readwrite) NSString *visit;
@property (strong, nonatomic, readwrite) NSString *departure;
@property (strong, nonatomic, readwrite) NSString *arrival;
@property (strong, nonatomic, readwrite) NSString *transportation;
@property int amount;
@property (strong, nonatomic, readwrite) NSString *purpose;
@property (strong, nonatomic, readwrite) NSString *route;
@property BOOL roundtrip;

- (NSData*)getKotsuhiNSData;

+ (Kotsuhi*)makeKotsuhi:(NSData*)data;

- (NSComparisonResult)compareDate:(Kotsuhi*)data;

- (int)getTripAmount;
- (NSString*)getRoundTripString;
- (NSString*)getTripArrow;

@end
