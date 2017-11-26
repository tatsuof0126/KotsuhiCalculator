//
//  Utility.m
//  KotsuhiCalculator
//
//  Created by 藤原 達郎 on 2014/05/06.
//  Copyright (c) 2014年 Tatsuo Fujiwara. All rights reserved.
//

#import "Utility.h"

@implementation Utility

+ (void)showAlert:(NSString*)message {
    [self showAlert:@"" message:message];
}

+ (void)showAlert:(NSString*)title message:(NSString*)message {
    UIAlertView *alert = [ [UIAlertView alloc] initWithTitle:title
                                                     message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

/*
+ (NSDate*)getDate:(NSString*)year month:(NSString*)month day:(NSString*)day {
    NSString* dateStr = [NSString stringWithFormat:@"%@-%@-%@ 00:00", year, month, day];
    
    // NSLog(@"%@/%@/%@",year, month, day);
    
    // Dateオブジェクトに変換して正しい日時かをチェック
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [formatter setLocale:[NSLocale systemLocale]];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [formatter setCalendar:calendar];
    
    NSDate* retDate = [formatter dateFromString:dateStr];
    
    if(retDate == nil){
        return nil;
    }
    
    // 日付チェック（2月31日などをチェック）
    NSCalendar* checkCalendar = [NSCalendar currentCalendar];
    [checkCalendar setTimeZone:[NSTimeZone systemTimeZone]];
    NSDateComponents* dateComps = [checkCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:retDate];
    
    if([year integerValue] != dateComps.year ||
       [month integerValue] != dateComps.month ||
       [day integerValue] != dateComps.day){
        return nil;
    }
    
    // NSLog(@" -> %@", [retDate description]);
    
    return retDate;
}
*/

+ (NSDate*)getDate:(NSString*)year month:(NSString*)month day:(NSString*)day {
    NSString* dateStr = [NSString stringWithFormat:@"%@-%@-%@ 00:00", year, month, day];
    
    // NSLog(@"%@/%@/%@ -> %@",year, month, day, dateStr);
    
    // Dateオブジェクトに変換して正しい日時かをチェック
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [formatter setLocale:[NSLocale systemLocale]];
    // [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [formatter setCalendar:calendar];
    
    NSDate* retDate = [formatter dateFromString:dateStr];
    
    if(retDate == nil){
        return nil;
    }
    
    // NSLog(@"retDate -> %@", [retDate description]);
    
    // 日付チェック（2月31日などをチェック）
    // NSCalendar* checkCalendar = [NSCalendar currentCalendar];
    NSCalendar* checkCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [checkCalendar setTimeZone:[NSTimeZone systemTimeZone]];
    NSDateComponents* dateComps = [checkCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:retDate];
    
    // NSLog(@"%@ <-> %d", year, (int)dateComps.year);
    // NSLog(@"%@ <-> %d", month, (int)dateComps.month);
    // NSLog(@"%@ <-> %d", day, (int)dateComps.day);
    
    // if([year integerValue] != dateComps.year ||
    //    [month integerValue] != dateComps.month ||
    //    [day integerValue] != dateComps.day){
    //     return nil;
    // }
    
    if([month integerValue] != dateComps.month ||
       [day integerValue] != dateComps.day){
        return nil;
    }
    
    // NSLog(@"retDate -> %@", [retDate description]);
    
    return retDate;
}

/*
+ (NSDate*)getDate:(NSString*)year month:(NSString*)month day:(NSString*)day {
    NSString* dateStr = [NSString stringWithFormat:@"%@-%@-%@ 00:00", year, month, day];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    // [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:60 * 60 * 9]];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [formatter setCalendar:calendar];
    
    NSDate* retDate = [formatter dateFromString:dateStr];
    
    if(retDate == nil){
        return nil;
    }
    
    // NSLog(@"Date : %@", [retDate description]);
    
    // 日付チェック（2月31日などをチェック）
    NSCalendar* checkCalendar = [NSCalendar currentCalendar];
    // [checkCalendar setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:60 * 60 * 9]];
    NSDateComponents *dateComps = [checkCalendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:retDate];
    
    if([year integerValue] != dateComps.year ||
       [month integerValue] != dateComps.month ||
       [day integerValue] != dateComps.day){
        return nil;
    }
    
    return retDate;
}
*/

+ (NSString*)replaceComma:(NSString*)sourceString {
    // 半角カンマを全角に置き換え
    return [sourceString stringByReplacingOccurrencesOfString:@"," withString:@"、"];
}

@end
