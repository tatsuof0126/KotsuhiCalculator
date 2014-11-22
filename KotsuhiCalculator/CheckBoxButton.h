//
//  CheckBoxButton.h
//  KotsuhiCalculator
//
//  Created by 藤原 達郎 on 2014/11/06.
//  Copyright (c) 2014年 Tatsuo Fujiwara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckBoxButton : UIButton

@property (nonatomic, assign) BOOL checkBoxSelected;

- (void)setState;

- (void)checkboxPush:(CheckBoxButton*)button;

@end
