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

- (UIView *)createNoSearchResultAlertViewWithImageName:(NSString *)imageName showButton:(BOOL)showButton{
    
    UIImage *image = [UIImage imageWithFileName:imageName];
    UIImageView *noResultView = [[UIImageView alloc] initWithImage:image];
    [self addSubview:noResultView];
    
    CGFloat noResX = (kScreenWidth - image.size.width) / 2;
    CGFloat noResY = 120;
    CGFloat noResW = image.size.width;
    CGFloat noResH = image.size.height;
    if (showButton) {
        noResY -= 60;
        noResultView.frame = CGRectMake(noResX, noResY, noResW, noResH);
    }else{
        noResultView.frame = CGRectMake(noResX, noResY, noResW, noResH);
    }
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
        
        CGFloat buttonW = 270;
        CGFloat buttonH = 40;
        CGFloat buttonX = (kScreenWidth - 270) / 2;
        CGFloat buttonY = noResY + noResH + 20;
        
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
    }
    
    return noResultView;
}

- (void)createNoResultAlertViewWithImageName:(NSString *)imageName showButton:(BOOL)showButton ifNecessaryForRowCount:(NSUInteger) rowCount{
    self.backgroundView = nil;
    if(rowCount == 0) {
        UIView *bgView = [[UIView alloc] init];
        self.backgroundView = bgView;
        
        UIImageView *noResultView = [[UIImageView alloc] initWithImage:[UIImage imageWithFileName:imageName]];
        [bgView addSubview:noResultView];
        
        if (showButton) {
            [noResultView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(bgView);
                make.centerY.equalTo(bgView).with.offset(-60);
            }];
        }else{
            [noResultView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(bgView);
            }];
        }
        if (showButton) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@"邀请好友加入" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            button.layer.cornerRadius = 5;
            button.layer.masksToBounds = YES;
            button.backgroundColor = [UIColor colorWithHex:NAVIGATIONBAR_BACKGROUNDCOLOR];
            [bgView addSubview:button];
            
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(bgView);
                make.top.mas_equalTo(noResultView.mas_bottom).with.offset(20);
                make.size.mas_equalTo(CGSizeMake(270, 40));
            }];
        }
        
    }
}


- (void)createNoResultAlertHeaderViewWithImageName:(NSString *)imageName showButton:(BOOL)showButton ifNecessaryForRowCount:(NSUInteger)rowCount{
        if(rowCount == 0) {
            UIView *bgView = [[UIView alloc] init];
            bgView.frame = CGRectMake(0, 0, self.width, self.height);
            
            UIImageView *noResultView = [[UIImageView alloc] initWithImage:[UIImage imageWithFileName:imageName]];
            [bgView addSubview:noResultView];
            
            if (showButton) {
                [noResultView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(bgView);
                    make.centerY.equalTo(bgView).with.offset(-60);
                }];
            }else{
                [noResultView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.equalTo(bgView);
                }];
            }
            if (showButton) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button setTitle:@"邀请好友加入" forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                button.titleLabel.font = [UIFont systemFontOfSize:15];
                button.layer.cornerRadius = 5;
                button.layer.masksToBounds = YES;
                button.backgroundColor = [UIColor colorWithHex:NAVIGATIONBAR_BACKGROUNDCOLOR];
                [bgView addSubview:button];
                
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(bgView);
                    make.top.mas_equalTo(noResultView.mas_bottom).with.offset(20);
                    make.size.mas_equalTo(CGSizeMake(270, 40));
                }];
            }
            
            self.tableHeaderView = bgView;
            NSLog(@"bgView:%@",NSStringFromCGRect(bgView.frame));
        }else{
            self.tableHeaderView = nil;
        }
}

@end
