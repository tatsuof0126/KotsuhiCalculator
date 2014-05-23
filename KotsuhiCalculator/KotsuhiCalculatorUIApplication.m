//
//  KotsuhiCalculatorUIApplication.m
//  KotsuhiCalculator
//
//  Created by 藤原 達郎 on 2014/05/24.
//  Copyright (c) 2014年 Tatsuo Fujiwara. All rights reserved.
//

#import "KotsuhiCalculatorUIApplication.h"

@implementation KotsuhiCalculatorUIApplication

@synthesize targetUrl;

- (BOOL)openURL:(NSURL *)url
{
    targetUrl = url;
    
    NSString* messageStr;
    
    if([[url absoluteString] hasPrefix:@"itms-apps://"] == YES){
        messageStr = @"AppStoreを起動します";
    } else if([[url absoluteString] hasPrefix:@"http://"] == YES ||
              [[url absoluteString] hasPrefix:@"https://"] == YES ){
        //        messageStr = @"Safariを起動します";
        [super openURL:targetUrl];
        return YES;
    } else {
        messageStr = @"アプリを起動します";
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
        message:messageStr delegate:self cancelButtonTitle:@"キャンセル" otherButtonTitles:@"OK", nil];
    [alert show];
    
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1){
        [super openURL:targetUrl];
    }
}

@end
