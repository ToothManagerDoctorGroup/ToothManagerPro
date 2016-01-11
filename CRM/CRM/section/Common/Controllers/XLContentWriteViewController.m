//
//  XLContentWriteViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/1/7.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLContentWriteViewController.h"
#import "XLTextViewPlaceHolder.h"

@interface XLContentWriteViewController ()<UITextViewDelegate>

@property (nonatomic, weak)XLTextViewPlaceHolder *textView;

@end

@implementation XLContentWriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏
    [self setUpNav];
}
#pragma mark - 设置导航栏
- (void)setUpNav{
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    [self setRightBarButtonWithTitle:@"保存"];
    self.view.backgroundColor = MyColor(238, 238, 238);
}

- (void)initView{
    [super initView];
    
    XLTextViewPlaceHolder *textView = [[XLTextViewPlaceHolder alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, 200)];
    textView.placeHolder = @"请填写备注信息!";
    textView.delegate = self;
    textView.text = self.currentContent;
    self.textView = textView;
    [self.view addSubview:textView];
    
    [self textChanged];
    
    //添加通知，监听textView的内容的变化
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChanged) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.textView becomeFirstResponder];
}


- (void)onRightButtonAction:(id)sender{
    if ([self.delegate respondsToSelector:@selector(contentWriteViewController:didWriteContent:)]) {
        [self.delegate contentWriteViewController:self didWriteContent:self.textView.text];
    }
    [self popViewControllerAnimated:YES];
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
