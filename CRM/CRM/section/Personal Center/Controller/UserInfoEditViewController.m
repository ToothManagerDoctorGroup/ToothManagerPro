//
//  UserInfoEditViewController.m
//  CRM
//
//  Created by Argo Zhang on 15/11/23.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "UserInfoEditViewController.h"

@interface UserInfoEditViewController (){
    UITextView *_textView;
}

@end

@implementation UserInfoEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super initView];
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    [self setRightBarButtonWithTitle:@"保存"];
    
    //初始化子控件
    [self setUpSubViews];
}
- (void)setUpSubViews{
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, 200)];
    _textView.backgroundColor = MyColor(237, 237, 237);
    _textView.font = [UIFont systemFontOfSize:14];
    _textView.text = self.targetStr;
    [self.view addSubview:_textView];
}

#pragma mark -保存按钮点击事件
- (void)onRightButtonAction:(id)sender{
    
    if ([self.delegate respondsToSelector:@selector(editViewController:didUpdateUserInfoWithStr:type:)]) {
        if ([self.title isEqualToString:@"个人简介"]) {
            [self.delegate editViewController:self didUpdateUserInfoWithStr:_textView.text type:EditViewControllerTypeDescription];
        }else {
            [self.delegate editViewController:self didUpdateUserInfoWithStr:_textView.text type:EditViewControllerTypeSkill];
        }
    }
    
    [self popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
