//
//  ConfigManager.m
//  KotsuhiCalculator
//
//  Created by 藤原 達郎 on 2014/05/22.
//  Copyright (c) 2014年 Tatsuo Fujiwara. All rights reserved.
//

#import "ConfigManager.h"

@implementation ConfigManager

+ (BOOL)isRemoveAdsFlg {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"REMOVEADSFLG"] == nil){
        [self setRemoveAdsFlg:NO];
    }
    return [defaults boolForKey:@"REMOVEADSFLG"];
}

+ (void)setRemoveAdsFlg:(BOOL)removeAdsFlg {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:removeAdsFlg forKey:@"REMOVEADSFLG"];
    [defaults synchronize];
}

+ (BOOL)isSendMailFlg {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"SENDMAILFLG"] == nil){
        [self setSendMailFlg:NO];
    }
    return [defaults boolForKey:@"SENDMAILFLG"];
}

+ (void)setSendMailFlg:(BOOL)sendMailFlg {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:sendMailFlg forKey:@"SENDMAILFLG"];
    [defaults synchronize];
}

+ (NSString*)getDefaultTransportation {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"TRANSPORTATION"] == nil){
        [self setDefaultTransportation:@"電車"];
    }
    return [defaults stringForKey:@"TRANSPORTATION"];
}

+ (void)setDefaultTransportation:(NSString*)transportation {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:transportation forKey:@"TRANSPORTATION"];
    [defaults synchronize];
}

+ (NSString*)getDefaultPurpose {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"PURPOSE"] == nil){
        [self setDefaultPurpose:@"会議"];
    }
    return [defaults stringForKey:@"PURPOSE"];
}

+ (void)setDefaultPurpose:(NSString*)purpose {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:purpose forKey:@"PURPOSE"];
    [defaults synchronize];
}

+ (NSString*)getDefaultDeparture {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"DEPARTURE"] == nil){
        [self setDefaultDeparture:@""];
    }
    return [defaults stringForKey:@"DEPARTURE"];
}

+ (void)setDefaultDeparture:(NSString*)departure {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:departure forKey:@"DEPARTURE"];
    [defaults synchronize];
}

+ (BOOL)isICCardSearch {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:@"ICCARDSEARCH"];
}

+ (void)setICCardSearch:(BOOL)icCardSearch {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:icCardSearch forKey:@"ICCARDSEARCH"];
    [defaults synchronize];
}

+ (NSString*)getDefaultSendTo {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"SENDTO"] == nil){
        [self setDefaultSendTo:@""];
    }
    return [defaults stringForKey:@"SENDTO"];
}

+ (void)setDefaultSendTo:(NSString*)sendTo {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:sendTo forKey:@"SENDTO"];
    [defaults synchronize];
}

+ (BOOL)isForWindows {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"FORWINDOWS"] == nil){
        [self setForWindows:YES];
    }
    return [defaults boolForKey:@"FORWINDOWS"];
}

+ (void)setForWindows:(BOOL)forWindows {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:forWindows forKey:@"FORWINDOWS"];
    [defaults synchronize];
}

+ (BOOL)isDayOrderAsc {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"DAYORDER"] == nil){
        [self setDayOrderAsc:YES];
    }
    return [defaults boolForKey:@"DAYORDER"];
}

+ (void)setDayOrderAsc:(BOOL)dayOrderAsc {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:dayOrderAsc forKey:@"DAYORDER"];
    [defaults synchronize];
}

@end
