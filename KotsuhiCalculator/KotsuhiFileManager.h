//
//  KotsuhiFileManager.h
//  KotsuhiCalculator
//
//  Created by 藤原 達郎 on 2014/05/08.
//  Copyright (c) 2014年 Tatsuo Fujiwara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Kotsuhi.h"
#import "MyPattern.h"
#import "DataItem.h"

@interface KotsuhiFileManager : NSObject

+ (Kotsuhi*)loadKotsuhi:(int)kotsuhiid;

+ (void)saveKotsuhi:(Kotsuhi*)kotsuhi;

+ (void)removeKotsuhi:(int)kotsuhiid;

+ (NSArray*)loadKotsuhiList;

+ (NSArray*)loadUntreatedList;

+ (MyPattern*)loadMyPattern:(int)mypatternid;

+ (void)saveMyPattern:(MyPattern*)myPattern;

+ (void)removeMyPattern:(int)mypatternid;

+ (NSArray*)loadMyPatternList;

+ (NSArray*)loadDataItemList;

+ (void)saveDataItemList:(NSArray*)dataItemList;

+ (void)makeSampleData;

@end
