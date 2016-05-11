//
//  UITableView+NoResultAlert.m
//  CRM
//
//  Created by Argo Zhang on 16/4/22.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "UITableView+NoResultAlert.h"
#import "UIImage+TTMAddtion.h"
#import "UIColor+Extension.h"
#import "CRMMacro.h"
#import <Masonry.h>

@implementation UITableView (NoResultAlert)

- (UIView *)createNoResultAlertViewWithImageName:(NSString *)imageName top:(CGFloat)top showButton:(BOOL)showButton buttonClickBlock:(ButtonClickBlock)buttonClickBlock{
    
    UIImageView *noResultView = [[UIImageView alloc] initWithImage:[UIImage imageWithFileName:imageName]];
    noResultView.hidden = YES;
    [self addSubview:noResultView];
    
    WS(weakSelf);
    [noResultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.mas_equalTo(top);
    }];
    
    if (showButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"邀请好友加入" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        button.hidden = YES;
        button.backgroundColor = [UIColor colorWithHex:NAVIGATIONBAR_BACKGROUNDCOLOR];
        [self addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf);
            make.top.mas_equalTo(noResultView.mas_bottom).with.offset(20);
            make.size.mas_equalTo(CGSizeMake(270, 40));
        }];
    }
    
    return noResultView;
}

@end
