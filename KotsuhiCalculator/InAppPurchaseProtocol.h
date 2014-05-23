//
//  InAppPurchaseProtocol.h
//  KotsuhiCalculator
//
//  Created by 藤原 達郎 on 2014/05/22.
//  Copyright (c) 2014年 Tatsuo Fujiwara. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol InAppPurchaseProtocol <NSObject>

- (void)endConnecting;

- (void)endPurchase;

@end
