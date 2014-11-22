//
//  MyPattern.m
//  KotsuhiCalculator
//
//  Created by 藤原 達郎 on 2014/05/08.
//  Copyright (c) 2014年 Tatsuo Fujiwara. All rights reserved.
//

#import "MyPattern.h"

#define SAVE_VERSION 2

@implementation MyPattern

@synthesize mypatternid;
@synthesize patternName;
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
        mypatternid = 0;
        patternName = @"";
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

- (NSData*)getMyPatternNSData {
    if( SAVE_VERSION == 1 ||
        SAVE_VERSION == 2){
        return [self getMyPatternNSDataV1];
    } else {
        return [self getMyPatternNSDataV1];
    }
}

- (NSData*)getMyPatternNSDataV1 {
    NSMutableString* mypatternStr = [NSMutableString string];
    
    // １行目：ファイル形式バージョン（V1）、mypatternid、UUID
    [mypatternStr appendString:[NSString stringWithFormat:@"V%d,%d\n",SAVE_VERSION,mypatternid]];
    
    // ２行目：パターン名
    [mypatternStr appendString:[NSString stringWithFormat:@"%@\n",patternName]];
    
    // ３行目：訪問先
    [mypatternStr appendString:[NSString stringWithFormat:@"%@\n",visit]];
    
    // ４行目：出発地
    [mypatternStr appendString:[NSString stringWithFormat:@"%@\n",departure]];
    
    // ５行目：到着地
    [mypatternStr appendString:[NSString stringWithFormat:@"%@\n",arrival]];
    
    // ６行目：交通手段
    [mypatternStr appendString:[NSString stringWithFormat:@"%@\n",transportation]];
    
    // ７行目：金額
    [mypatternStr appendString:[NSString stringWithFormat:@"%d\n",amount]];
    
    // ８行目：目的補足
    [mypatternStr appendString:[NSString stringWithFormat:@"%@\n",purpose]];
    
    // ９行目：経路
    [mypatternStr appendString:[NSString stringWithFormat:@"%@\n",route]];
    
    if (SAVE_VERSION == 2){
        // １０行目：往復フラグ（V2のみ）
        [mypatternStr appendString:[NSString stringWithFormat:@"%d\n",roundtrip]];
    }

//    NSLog(@"mypatternStr : %@", mypatternStr);
    
    NSData* data = [mypatternStr dataUsingEncoding:NSUTF8StringEncoding];
    
    return data;
}

+ (MyPattern*)makeMyPattern:(NSData*)data {
    NSString* mypatternStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSArray* mypatternStrArray = [mypatternStr componentsSeparatedByString:@"\n"];
    
    //    NSLog(@"resultStr : %@", resultStr);
    
    @try {
        // １行目にファイル形式があるはず
        NSString* headerStr = [mypatternStrArray objectAtIndex:0];
        NSArray* headerStrArray = [headerStr componentsSeparatedByString:@","];
        NSString* versionStr = [headerStrArray objectAtIndex:0];
        
        if([versionStr isEqualToString:@"V1"] == YES ||
           [versionStr isEqualToString:@"V2"] == YES){
            // "V1"という文字列ならV1形式
            // "V2"という文字列ならV2形式（同じメソッドで処理）
            return [self makeKotsuhiV1:mypatternStrArray];
        } else {
            // どのバージョンでもない場合はV1形式と見なす
            return [self makeKotsuhiV1:mypatternStrArray];
        }
    }
    @catch (NSException *exception) {
        //        NSLog(@"例外名：%@", exception.name);
        //        NSLog(@"理由：%@", exception.reason);
    }
    
    // 例外が発生したらnilを返す
    return nil;
}

+ (MyPattern*)makeKotsuhiV1:(NSArray*)mypatternStrArray {
    MyPattern* myPattern = [[MyPattern alloc] init];
    
    // １行目はヘッダー情報（V1orV2,mypatternid）
    NSString* headerStr = [mypatternStrArray objectAtIndex:0];
    NSArray* headerStrArray = [headerStr componentsSeparatedByString:@","];
    myPattern.mypatternid = [[headerStrArray objectAtIndex:1] intValue];
    
    // ２行目：パターン名
    myPattern.patternName = [mypatternStrArray objectAtIndex:1];
    
    // ３行目：訪問先
    myPattern.visit = [mypatternStrArray objectAtIndex:2];
    
    // ４行目：出発地
    myPattern.departure = [mypatternStrArray objectAtIndex:3];
    
    // ５行目：到着地
    myPattern.arrival = [mypatternStrArray objectAtIndex:4];
    
    // ６行目：交通手段
    myPattern.transportation = [mypatternStrArray objectAtIndex:5];
    
    // ７行目：金額
    myPattern.amount = [[mypatternStrArray objectAtIndex:6] intValue];
    
    // ８行目：目的補足
    myPattern.purpose = [mypatternStrArray objectAtIndex:7];
    
    // ９行目：経路
    myPattern.route = [mypatternStrArray objectAtIndex:8];
    
    if ([mypatternStrArray count] >= 10){
        // １０行目：往復フラグ
        myPattern.roundtrip = [[mypatternStrArray objectAtIndex:9] isEqualToString:@"1"];
    }
    
    return myPattern;
}

- (NSComparisonResult)compareMyPatternId:(MyPattern*)data {
    if (self.mypatternid > data.mypatternid){
        return NSOrderedAscending;
    } else if (self.mypatternid == data.mypatternid) {
        return NSOrderedSame;
    } else {
        return NSOrderedDescending;
    }
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
