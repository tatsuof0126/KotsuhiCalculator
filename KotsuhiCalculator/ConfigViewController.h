//
//  ConfigViewController.h
//  KotsuhiCalculator
//
//  Created by 藤原 達郎 on 2014/03/28.
//  Copyright (c) 2014年 Tatsuo Fujiwara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NADView.h"

@interface ConfigViewController : UIViewController <NADViewDelegate>

@property (nonatomic, retain) NADView* nadView;

@property (strong, nonatomic) IBOutlet UILabel *reviewLabel;

@property (strong, nonatomic) IBOutlet UILabel *otherappLabel;

@property (strong, nonatomic) IBOutlet UINavigationItem *inputNavi;

@property (strong, nonatomic) IBOutlet UILabel *versionName;

@end
