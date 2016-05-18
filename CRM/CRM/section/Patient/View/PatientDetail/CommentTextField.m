//
//  CommentTextField.m
//  CRM
//
//  Created by Argo Zhang on 15/11/20.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "CommentTextField.h"

@interface CommentTextField ()

@end

@implementation CommentTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化
        [self setUp];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        //初始化
        [self setUp];
    }
    return self;
}

- (void)setUp{
    self.placeholder = @"请输入300字以内会诊信息";
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor whiteColor];
    self.returnKeyType = UIReturnKeySend;
    self.enablesReturnKeyAutomatically = YES;
}

@end
