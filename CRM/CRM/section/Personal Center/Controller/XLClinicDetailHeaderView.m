//
//  XLClinicDetailHeaderView.m
//  CRM
//
//  Created by Argo Zhang on 16/5/24.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLClinicDetailHeaderView.h"

@implementation XLClinicDetailHeaderView

- (IBAction)phoneAction:(id)sender {
    if (self.clinicPhone.text.length == 0) {
        [SVProgressHUD showImage:nil status:@"诊所未设置联系电话"];
        return;
    }
    NSString *message = [NSString stringWithFormat:@"是否拨打电话:%@",self.clinicPhone.text];
    WS(weakSelf);
    TimAlertView *alertView = [[TimAlertView alloc] initWithTitle:nil message:message cancel:@"取消" certain:@"确定" cancelHandler:^{
    } comfirmButtonHandlder:^{
        NSString *number = weakSelf.clinicPhone.text;
        NSString *num = [[NSString alloc]initWithFormat:@"tel://%@",number];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
    }];
    [alertView show];
}
- (IBAction)locationAction:(id)sender {
}


@end
