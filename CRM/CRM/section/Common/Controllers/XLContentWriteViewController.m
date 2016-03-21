//
//  XLContentWriteViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/1/7.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLContentWriteViewController.h"
#import "XLTextViewPlaceHolder.h"
#import "NSString+Conversion.h"

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
}

- (void)initView{
    [super initView];
    
    XLTextViewPlaceHolder *textView = [[XLTextViewPlaceHolder alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, 150)];
    if (![self.currentContent isNotEmpty]) {
        textView.placeHolder = self.placeHolder;
    }
    textView.delegate = self;
    textView.text = self.currentContent;
    textView.returnKeyType = UIReturnKeyDone;
    self.textView = textView;
    [self.view addSubview:textView];
    
    //添加通知，监听textView的内容的变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged) name:UITextViewTextDidChangeNotification object:nil];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [self.textView resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
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
    
    if (self.limit != 0) {
        NSInteger number = [self.textView.text length];
        if (number > self.limit) {
            self.textView.text = [self.textView.text substringToIndex:self.limit];
            number = self.limit;
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
