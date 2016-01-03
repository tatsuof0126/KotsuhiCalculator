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

+ (NSDate*)getDate:(NSString*)year month:(NSString*)month day:(NSString*)day {
    NSString* dateStr = [NSString stringWithFormat:@"%@-%@-%@ 00:00", year, month, day];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:60 * 60 * 9]];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [formatter setCalendar:calendar];
    
    NSDate* retDate = [formatter dateFromString:dateStr];
    
    if(retDate == nil){
        return nil;
    }
    
    // 日付チェック（2月31日などをチェック）
    NSCalendar* checkCalendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:60 * 60 * 9]];
    NSDateComponents *dateComps = [checkCalendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:retDate];
    
    if([year integerValue] != dateComps.year ||
       [month integerValue] != dateComps.month ||
       [day integerValue] != dateComps.day){
        return nil;
    }
    
    return retDate;
}

+ (NSString*)replaceComma:(NSString*)sourceString {
    // 半角カンマを全角に置き換え
    return [sourceString stringByReplacingOccurrencesOfString:@"," withString:@"、"];
}

@end
