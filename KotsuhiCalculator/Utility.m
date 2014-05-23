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
    NSString *dateStr = [NSString stringWithFormat:@"%@-%@-%@ 00:00", year, month, day];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [formatter setLocale:[NSLocale systemLocale]];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [formatter setCalendar:calendar];
    
    NSDate *date = [formatter dateFromString:dateStr];
       
    return date;
}

@end
