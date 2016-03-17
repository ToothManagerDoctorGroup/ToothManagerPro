//
//  XLAlertBaseView.m
//  CRM
//
//  Created by Argo Zhang on 16/3/17.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLAlertBaseView.h"
#import "UIColor+Extension.h"

#define TitleFont [UIFont boldSystemFontOfSize:20]
#define TextColor [UIColor colorWithHex:0x333333]

#define ContentFont [UIFont systemFontOfSize:15]
@interface XLAlertBaseView ()<UITextViewDelegate>

@end

@implementation XLAlertBaseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = TitleFont;
        _titleLabel.textColor = TextColor;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        _contentTextView = [[UITextView alloc] initWithFrame:CGRectZero];
        _contentTextView.textColor = TextColor;
        _contentTextView.font = ContentFont;
        _contentTextView.backgroundColor = [UIColor clearColor];
        [_contentTextView sizeToFit];
        _contentTextView.returnKeyType = UIReturnKeyDone;
        _contentTextView.delegate =self;
        _contentTextView.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_contentTextView];
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    _titleLabel.frame = CGRectMake(0, 0, self.width, 30);
    _contentTextView.frame = CGRectMake(0, _titleLabel.bottom, self.width, self.height - _titleLabel.height);
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [self.contentTextView resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

@end
