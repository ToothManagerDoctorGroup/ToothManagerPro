//
//  CustomAlertView.m
//  CRM
//
//  Created by Argo Zhang on 15/12/8.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "CustomAlertView.h"
#import "UIColor+Extension.h"
#import "YYKeyboardManager.h"

#define CommenFont [UIFont systemFontOfSize:16]
#define ContentFont [UIFont systemFontOfSize:15]
#define TipFont [UIFont systemFontOfSize:14]
#define ContentColor MyColor(187, 187, 187)

#define Margin 10

@interface CustomAlertView ()<YYKeyboardObserver>{
    UIView *_topView; //标题栏视图
    UIView *_bottomView; //内容栏视图
    
    UILabel *_alertLabel;//提醒标题
    UITextField *_contentField;//内容为输入框模式
    UIView *_lineView;//输入框下的分割线
    
    UILabel *_contentLabel;//内容为Label模式
    
    UIButton *_cancleButton;//取消按钮
    UIButton *_certainButton;//确定按钮
    
    UILabel *_tipLabel;//提示内容
}

@property (nonatomic, weak)UIView *cover;
@end

@implementation CustomAlertView

- (void)dealloc{
    [[YYKeyboardManager defaultManager] removeObserver:self];
    
    NSLog(@"弹出框被销毁了");
}

- (instancetype)initWithAlertTitle:(NSString *)alertTitle cancleTitle:(NSString *)cancleTitle certainTitle:(NSString *)certainTitle{
    if (self = [super init]) {
        
        self.alertTitle = alertTitle;
        self.cancleTitle = cancleTitle;
        self.certainTitle = certainTitle;
        
        [[YYKeyboardManager defaultManager] addObserver:self];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        self.type = CustomAlertViewLabel;
        self.frame = CGRectMake((kScreenWidth - 200) / 2, (kScreenHeight - 250) / 2, 200, 160);
        //初始化
        [self setUp];
    }
    return self;
}

#pragma mark - 初始化
- (void)setUp{
    
    _topView = [[UIView alloc] init];
    _topView.backgroundColor = MyColor(19, 151, 232);
    [self addSubview:_topView];
    
    //提醒标题
    _alertLabel = [[UILabel alloc] init];
    _alertLabel.font = CommenFont;
    _alertLabel.textColor = [UIColor whiteColor];
    [_topView addSubview:_alertLabel];
    
    _bottomView = [[UIView alloc] init];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_bottomView];
    
    //内容为输入框模式
    _contentField = [[UITextField alloc] init];
    _contentField.font = ContentFont;
    _contentField.placeholder = @"请输入分组名称";
    _contentField.returnKeyType = UIReturnKeyDone;
    [_bottomView addSubview:_contentField];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = [UIColor colorWithHex:0xcccccc];
    [_bottomView addSubview:_lineView];
    
    //内容为Label模式
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.textColor = ContentColor;
    _contentLabel.font = TipFont;
    _contentLabel.textAlignment = NSTextAlignmentCenter;
    _contentLabel.numberOfLines = 0;
    [_bottomView addSubview:_contentLabel];
    
    //取消按钮
    _cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _cancleButton.backgroundColor = MyColor(187, 187, 187);
    [_cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    _cancleButton.layer.cornerRadius = 5;
    _cancleButton.layer.masksToBounds = YES;
    _cancleButton.titleLabel.font = TipFont;
    [_cancleButton addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_cancleButton];
    
    //确定按钮
    _certainButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_certainButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _certainButton.backgroundColor = MyColor(19, 151, 232);
    [_certainButton setTitle:@"确定" forState:UIControlStateNormal];
    _certainButton.layer.cornerRadius = 5;
    _certainButton.layer.masksToBounds = YES;
    _certainButton.titleLabel.font = TipFont;
    [_certainButton addTarget:self action:@selector(certainAction) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_certainButton];
    
    //提示内容
    _tipLabel = [[UILabel alloc] init];
    _tipLabel.textColor = ContentColor;
    _tipLabel.font = TipFont;
    [_bottomView addSubview:_tipLabel];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat buttonW = 70;
    CGFloat buttonH = 30;
    
    _topView.frame = CGRectMake(0, 0, self.width, 44);
    
    _alertLabel.frame = CGRectMake(Margin, 0, self.width - Margin * 2, _topView.height);
    if (self.alertTitle) {
        _alertLabel.text = self.alertTitle;
    }else{
        _alertLabel.text = @"提示";
    }
    
    _bottomView.frame = CGRectMake(0, _topView.bottom, self.width, self.height - 44);
    if (self.type == CustomAlertViewLabel) {
        _contentLabel.frame = CGRectMake(Margin * 2, Margin * 2, self.width - Margin * 4, 35);
        _cancleButton.frame = CGRectMake(Margin * 2, _contentLabel.bottom + Margin * 2, buttonW, buttonH);
        
        _certainButton.frame = CGRectMake(self.width - Margin * 2 - buttonW, _cancleButton.top, buttonW, buttonH);
    }else{
        _contentField.frame = CGRectMake(Margin * 2, Margin * 2, self.width - Margin * 4, 30);
        _lineView.frame = CGRectMake(Margin * 2, _contentField.bottom - 1, _contentField.width, 1);
        
        _cancleButton.frame = CGRectMake(Margin * 2, _contentField.bottom + Margin * 2, buttonW, buttonH);
        
        _certainButton.frame = CGRectMake(self.width - Margin * 2 - buttonW, _cancleButton.top, buttonW, buttonH);
    }
}

- (void)setCancleTitle:(NSString *)cancleTitle{
    _cancleTitle = cancleTitle;
    
    [_cancleButton setTitle:cancleTitle forState:UIControlStateNormal];
}

- (void)setCertainTitle:(NSString *)certainTitle{
    _certainTitle = certainTitle;
    
    [_certainButton setTitle:certainTitle forState:UIControlStateNormal];
}

- (void)setAlertTitle:(NSString *)alertTitle{
    _alertTitle = alertTitle;
    
    _alertLabel.text = alertTitle;
}

- (void)setTipContent:(NSString *)tipContent{
    _tipContent = tipContent;
    if (self.type == CustomAlertViewLabel) {
        _contentLabel.text = _tipContent;
    }else{
        _contentField.text = _tipContent;
    }
    
}

- (void)setCertainColor:(UIColor *)certainColor{
    _certainColor = certainColor;
    
    _certainButton.backgroundColor = certainColor;
}

- (void)setPlaceHolder:(NSString *)placeHolder{
    _placeHolder = placeHolder;
    
    _contentField.placeholder = placeHolder;
}

- (void)show{
    //创建蒙板
    UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    cover.backgroundColor = [UIColor lightGrayColor];
    cover.alpha = 0.5;
    self.cover = cover;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:cover];
    //创建
    [keyWindow addSubview:self];
    
    if (self.type == CustomAlertViewTextField) {
        [_contentField becomeFirstResponder];
    }
}

- (void)cancleAction{
    [self.cover removeFromSuperview];
    [self removeFromSuperview];
}

- (void)certainAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(alertView:didClickCertainButtonWithContent:)]) {
        [self.delegate alertView:self didClickCertainButtonWithContent:_contentField.text];
    }
    [self.cover removeFromSuperview];
    [self removeFromSuperview];
    
    
}

- (void)keyboardChangedWithTransition:(YYKeyboardTransition)transition{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [UIView animateWithDuration:transition.animationCurve delay:0 options:transition.animationOption animations:^{
        CGRect kbFrame = [[YYKeyboardManager defaultManager] convertRect:transition.toFrame toView:keyWindow];
        CGRect textframe = self.frame;
        textframe.origin.y = kbFrame.origin.y - textframe.size.height;
        self.frame = textframe;
    } completion:^(BOOL finished) {
        
    }];
}

@end
