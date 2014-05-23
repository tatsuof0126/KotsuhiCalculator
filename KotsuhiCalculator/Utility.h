//
//  Utility.h
//  KotsuhiCalculator
//
//  Created by 藤原 達郎 on 2014/05/06.
//  Copyright (c) 2014年 Tatsuo Fujiwara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject

+ (void)showAlert:(NSString*)message;

+ (void)showAlert:(NSString*)title message:(NSString*)message;

+ (NSDate*)getDate:(NSString*)year month:(NSString*)month day:(NSString*)day;

@end
