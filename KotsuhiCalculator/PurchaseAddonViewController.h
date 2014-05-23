//
//  PurchaseAddonViewController.h
//  KotsuhiCalculator
//
//  Created by 藤原 達郎 on 2014/05/22.
//  Copyright (c) 2014年 Tatsuo Fujiwara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InAppPurchaseProtocol.h"

@interface PurchaseAddonViewController : UIViewController <InAppPurchaseProtocol>

@property (strong, nonatomic) IBOutlet UITableView *addonTableView;

@property BOOL doingPurchase;
@property (strong, nonatomic) UIActivityIndicatorView* actIndView;

- (IBAction)backButton:(id)sender;

@end
