//
//  TransitViewController.h
//  KotsuhiCalculator
//
//  Created by 藤原 達郎 on 2015/10/04.
//  Copyright (c) 2015年 Tatsuo Fujiwara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface TransitViewController : UIViewController <GADBannerViewDelegate>

@property (strong, nonatomic) GADBannerView *gadView;

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@property (strong, nonatomic) NSString* targetUrl;

- (IBAction)backButton:(id)sender;

@end
