//
//  XLAdviseFeedBackViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/1/5.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLAdviseFeedBackViewController.h"
#import "XLTextViewPlaceHolder.h"

@interface XLAdviseFeedBackViewController ()<UITextViewDelegate>

@property (nonatomic, weak)XLTextViewPlaceHolder *textView;

@end

@implementation XLAdviseFeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏
    [self setUpNav];
}
#pragma mark - 设置导航栏
- (void)setUpNav{
    self.title = @"意见反馈";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    [self setRightBarButtonWithTitle:@"发送"];
}

- (void)initView{
    [super initView];
    
    XLTextViewPlaceHolder *textView = [[XLTextViewPlaceHolder alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, 200)];
    textView.placeHolder = @"请输入您的宝贵意见!";
    textView.delegate = self;
    self.textView = textView;
    [self.view addSubview:textView];
    
    //添加通知，监听textView的内容的变化
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChanged) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.textView becomeFirstResponder];
}


- (void)onRightButtonAction:(id)sender{
    if ([self.textView.text isNotEmpty]) {
        [SVProgressHUD showSuccessWithStatus:@"发送成功"];
        [self popViewControllerAnimated:YES];
    }else{
        [SVProgressHUD showErrorWithStatus:@"意见不能为空"];
    }
}


//监听textView内容的变化
- (void)textChanged{
    //判断是否有内容
    if (_textView.text.length) {
        //隐藏placeHolder
        _textView.hidePlaceHolder = YES;
    }else{
        _textView.hidePlaceHolder = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
