//
//  InAppPurchaseManager.h
//  KotsuhiCalculator
//
//  Created by 藤原 達郎 on 2014/05/22.
//  Copyright (c) 2014年 Tatsuo Fujiwara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "InAppPurchaseProtocol.h"

@interface InAppPurchaseManager : NSObject <SKProductsRequestDelegate,SKPaymentTransactionObserver>
{
    SKProductsRequest* myProductRequest;
}

@property (strong, nonatomic) id<InAppPurchaseProtocol> source;

- (BOOL)canMakePurchases;

- (void)requestProductData:(NSString*)productId;

- (void)restoreProduct;

@end
