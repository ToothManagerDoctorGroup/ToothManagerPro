//
//  XLAddressMapViewController.m
//  CRM
//
//  Created by Argo Zhang on 15/12/26.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "XLAddressMapViewController.h"

@interface XLAddressMapViewController ()

@end

@implementation XLAddressMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"地址搜索";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
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

@end
