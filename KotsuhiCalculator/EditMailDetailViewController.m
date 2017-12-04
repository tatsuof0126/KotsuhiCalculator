//
//  EditMailDetailViewController.m
//  KotsuhiCalculator
//
//  Created by 藤原 達郎 on 2017/11/27.
//  Copyright © 2017年 Tatsuo Fujiwara. All rights reserved.
//

#import "EditMailDetailViewController.h"

@interface EditMailDetailViewController ()

@end

@implementation EditMailDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
