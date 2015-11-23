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
    self.view.backgroundColor = [UIColor whiteColor];
    
    //初始化子控件
    [self setUpSubViews];
}
- (void)setUpSubViews{
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, 200)];
    _textView.backgroundColor = MyColor(237, 237, 237);
    _textView.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_textView];
}

#pragma mark -保存按钮点击事件
- (void)onRightButtonAction:(id)sender{
    NSLog(@"保存");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
