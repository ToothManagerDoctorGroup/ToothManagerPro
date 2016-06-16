//
//  XLAdviseFeedBackViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/1/5.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLAdviseFeedBackViewController.h"
#import "XLTextViewPlaceHolder.h"
#import "DoctorTool.h"
#import "AccountManager.h"
#import "CRMHttpRespondModel.h"
#import "UIColor+Extension.h"

@interface XLAdviseFeedBackViewController ()<UITextViewDelegate>

@property (nonatomic, weak)XLTextViewPlaceHolder *textView;

@property (nonatomic, weak)UILabel *statusLabel;//字数限制

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
    
    XLTextViewPlaceHolder *textView = [[XLTextViewPlaceHolder alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, 150)];
    textView.placeHolder = @"请输入您的宝贵意见!";
    textView.delegate = self;
    textView.returnKeyType = UIReturnKeyDone;
    self.textView = textView;
    [self.view addSubview:textView];
    
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 100 - 10, textView.bottom + 10, 100, 30)];
    statusLabel.font = [UIFont systemFontOfSize:15];
    statusLabel.textColor = [UIColor colorWithHex:0x888888];
    statusLabel.textAlignment = NSTextAlignmentRight;
    statusLabel.text = @"0/255";
    self.statusLabel = statusLabel;
    [self.view addSubview:statusLabel];
    
    //添加通知，监听textView的内容的变化
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChanged) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.textView becomeFirstResponder];
}


- (void)onRightButtonAction:(id)sender{
    if ([self.textView.text isNotEmpty]) {
        [SVProgressHUD showWithStatus:@"正在发送"];
        [DoctorTool sendAdviceWithDoctorId:[AccountManager currentUserid] content:self.textView.text success:^(CRMHttpRespondModel *respond) {
            if ([respond.code integerValue] == 200) {
                [SVProgressHUD showSuccessWithStatus:@"发送成功，感谢您的宝贵意见!"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self popViewControllerAnimated:YES];
                });
            }else{
                [SVProgressHUD showErrorWithStatus:@"发送失败"];
            }
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"发送失败"];
            if (error) {
                NSLog(@"error:%@",error);
            }
        }];
        
    }else{
        [SVProgressHUD showErrorWithStatus:@"内容不能为空"];
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
    
    NSInteger number = [self.textView.text length];
    if (number > 255) {
        self.textView.text = [self.textView.text substringToIndex:255];
        number = 255;
    }
    self.statusLabel.text = [NSString stringWithFormat:@"%ld/255",(long)number];
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [self.textView resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
