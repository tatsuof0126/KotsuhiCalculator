//
//  Kotsuhi.m
//  KotsuhiCalculator
//
//  Created by 藤原 達郎 on 2014/05/06.
//  Copyright (c) 2014年 Tatsuo Fujiwara. All rights reserved.
//

#import "Kotsuhi.h"

#define SAVE_VERSION 2

@implementation Kotsuhi

@synthesize UUID;
@synthesize kotsuhiid;
@synthesize year;
@synthesize month;
@synthesize day;
@synthesize visit;
@synthesize departure;
@synthesize arrival;
@synthesize transportation;
@synthesize amount;
@synthesize purpose;
@synthesize route;
@synthesize roundtrip;

- (id)init {
    if(self = [super init]){
        UUID = @"";
        kotsuhiid = 0;
        year = 0;
        month = 0;
        day = 0;
        visit = @"";
        departure = @"";
        arrival = @"";
        transportation = @"";
        amount = 0;
        purpose = @"";
        route = @"";
        roundtrip = NO;
    }
    return self;
}

- (NSData*)getKotsuhiNSData {
    if( SAVE_VERSION == 1 ||
        SAVE_VERSION == 2){
        return [self getKotsuhiNSDataV1];
    } else {
        return [self getKotsuhiNSDataV1];
    }
}

// V1とV2に対応
- (NSData*)getKotsuhiNSDataV1 {
    NSMutableString* kotsuhiStr = [NSMutableString string];
    
    if (UUID == nil || [UUID isEqualToString:@""] || [UUID isEqualToString:@"(null)"]) {
        // UUIDを作成
        CFUUIDRef uuidObj = CFUUIDCreate(nil);
        UUID = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
        CFRelease(uuidObj);
    }
    
    // １行目：ファイル形式バージョン（V1,V2）、kotsuhiid、UUID
    [kotsuhiStr appendString:[NSString stringWithFormat:@"V%d,%d,%@\n",SAVE_VERSION,kotsuhiid,UUID]];

    // ２行目：日付（年、月、日）
    [kotsuhiStr appendString:[NSString stringWithFormat:@"%d,%d,%d\n",year,month,day]];
    
    // ３行目：訪問先
    [kotsuhiStr appendString:[NSString stringWithFormat:@"%@\n",visit]];
    
    // ４行目：出発地
    [kotsuhiStr appendString:[NSString stringWithFormat:@"%@\n",departure]];
    
    // ５行目：到着地
    [kotsuhiStr appendString:[NSString stringWithFormat:@"%@\n",arrival]];
    
    // ６行目：交通手段
    [kotsuhiStr appendString:[NSString stringWithFormat:@"%@\n",transportation]];
    
    // ７行目：金額
    [kotsuhiStr appendString:[NSString stringWithFormat:@"%d\n",amount]];
    
    // ８行目：目的補足
    [kotsuhiStr appendString:[NSString stringWithFormat:@"%@\n",purpose]];
    
    // ９行目：経路
    [kotsuhiStr appendString:[NSString stringWithFormat:@"%@\n",route]];
    
    if (SAVE_VERSION == 2){
        // １０行目：往復フラグ（V2のみ）
        [kotsuhiStr appendString:[NSString stringWithFormat:@"%d\n",roundtrip]];
    }
    
//    NSLog(@"kotsuhiStr : %@", kotsuhiStr);

    NSData* data = [kotsuhiStr dataUsingEncoding:NSUTF8StringEncoding];
    
    return data;
}


+ (Kotsuhi*)makeKotsuhi:(NSData*)data {
    NSString* kotsuhiStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSArray* kotsuhiStrArray = [kotsuhiStr componentsSeparatedByString:@"\n"];
    
//    NSLog(@"kotsuhiStr \n%@", kotsuhiStr);
    
    @try {
        // １行目にファイル形式とUUIDがあるはず
        NSString* headerStr = [kotsuhiStrArray objectAtIndex:0];
        NSArray* headerStrArray = [headerStr componentsSeparatedByString:@","];
        NSString* versionStr = [headerStrArray objectAtIndex:0];
        
        if([versionStr isEqualToString:@"V1"] == YES ||
           [versionStr isEqualToString:@"V2"] == YES ){
            // "V1"という文字列ならV1形式
            // "V2"という文字列ならV2形式（同じメソッドで処理）
            return [self makeKotsuhiV1:kotsuhiStrArray];
        } else {
            // どのバージョンでもない場合はV1形式と見なす
            return [self makeKotsuhiV1:kotsuhiStrArray];
        }
    }
    @catch (NSException *exception) {
        //        NSLog(@"例外名：%@", exception.name);
        //        NSLog(@"理由：%@", exception.reason);
    }
    
    // 例外が発生したらnilを返す
    return nil;
}

+ (Kotsuhi*)makeKotsuhiV1:(NSArray*)kotsuhiStrArray {
    Kotsuhi* kotsuhi = [[Kotsuhi alloc] init];

    // １行目はヘッダー情報（V1,kotsuhiid,UUID）
    NSString* headerStr = [kotsuhiStrArray objectAtIndex:0];
    NSArray* headerStrArray = [headerStr componentsSeparatedByString:@","];
    kotsuhi.kotsuhiid = [[headerStrArray objectAtIndex:1] intValue];
    kotsuhi.UUID = [headerStrArray objectAtIndex:2];
    
    // ２行目：日付（年,月,日）
    NSString* dayStr = [kotsuhiStrArray objectAtIndex:1];
    NSArray* dayStrArray = [dayStr componentsSeparatedByString:@","];
    kotsuhi.year = [[dayStrArray objectAtIndex:0] intValue];
    kotsuhi.month = [[dayStrArray objectAtIndex:1] intValue];
    kotsuhi.day = [[dayStrArray objectAtIndex:2] intValue];
    
    // ３行目：訪問先
    kotsuhi.visit = [kotsuhiStrArray objectAtIndex:2];
    
    // ４行目：出発地
    kotsuhi.departure = [kotsuhiStrArray objectAtIndex:3];

    // ５行目：到着地
    kotsuhi.arrival = [kotsuhiStrArray objectAtIndex:4];

    // ６行目：交通手段
    kotsuhi.transportation = [kotsuhiStrArray objectAtIndex:5];

    // ７行目：金額
    kotsuhi.amount = [[kotsuhiStrArray objectAtIndex:6] intValue];

    // ８行目：目的補足
    kotsuhi.purpose = [kotsuhiStrArray objectAtIndex:7];

    // ９行目：経路
    kotsuhi.route = [kotsuhiStrArray objectAtIndex:8];
    
    if ([kotsuhiStrArray count] >= 10){
        // １０行目：往復フラグ
        kotsuhi.roundtrip = [[kotsuhiStrArray objectAtIndex:9] isEqualToString:@"1"];
    }
    
    return kotsuhi;
}

- (NSComparisonResult)compareDate:(Kotsuhi*)data {
    if (self.year > data.year) {
        return NSOrderedAscending;
    } else if (self.year < data.year) {
        return NSOrderedDescending;
    }
    
    if (self.month > data.month) {
        return NSOrderedAscending;
    } else if (self.month < data.month) {
        return NSOrderedDescending;
    }
    
    if (self.day > data.day) {
        return NSOrderedAscending;
    } else if (self.day < data.day) {
        return NSOrderedDescending;
    }
    
    // 年月日すべて一緒ならkotsuhiidで判断
    if (self.kotsuhiid > data.kotsuhiid) {
        return NSOrderedAscending;
    } else if (self.kotsuhiid < data.kotsuhiid) {
        return NSOrderedDescending;
    }
    
    return NSOrderedSame;
}

- (int)getTripAmount {
    if(roundtrip == YES){
        return amount * 2;
    } else {
        return amount;
    }
}

- (NSString*)getRoundTripString {
    if(roundtrip == YES){
        return @"(往復)";
    } else {
        return @"";
    }
}

- (NSString*)getTripArrow {
    if(roundtrip == YES){
        return @"⇔";
    } else {
        return @"→";
    }
}

@end
