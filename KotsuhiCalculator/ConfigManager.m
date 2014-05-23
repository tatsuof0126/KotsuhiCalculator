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
    return [defaults boolForKey:@"REMOVEADSFLG"];
}

+ (void)setRemoveAdsFlg:(BOOL)removeAdsFlg {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:removeAdsFlg forKey:@"REMOVEADSFLG"];
    [defaults synchronize];
}

@end
