//
//  ConfigManager.h
//  KotsuhiCalculator
//
//  Created by 藤原 達郎 on 2014/05/22.
//  Copyright (c) 2014年 Tatsuo Fujiwara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConfigManager : NSObject

+ (BOOL)isRemoveAdsFlg;

+ (void)setRemoveAdsFlg:(BOOL)removeAdsFlg;

+ (BOOL)isSendMailFlg;

+ (void)setSendMailFlg:(BOOL)sendMailFlg;

+ (NSString*)getDefaultTransportation;

+ (void)setDefaultTransportation:(NSString*)transportation;

+ (NSString*)getDefaultPurpose;

+ (void)setDefaultPurpose:(NSString*)purpose;

+ (BOOL)isICCardSearch;

+ (void)setICCardSearch:(BOOL)icCardSearch;

+ (NSString*)getDefaultSendTo;

+ (void)setDefaultSendTo:(NSString*)sendTo;

+ (BOOL)isForWindows;

+ (void)setForWindows:(BOOL)forWindows;

+ (BOOL)isDayOrderAsc;

+ (void)setDayOrderAsc:(BOOL)dayOrderAsc;

@end
