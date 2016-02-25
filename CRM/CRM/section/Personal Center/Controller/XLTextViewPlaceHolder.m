//
//  XLTextViewPlaceHolder.m
//  CRM
//
//  Created by Argo Zhang on 16/1/5.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLTextViewPlaceHolder.h"

@interface XLTextViewPlaceHolder ()

@property (nonatomic, weak)UILabel *placeHolderLabel;

@end

@implementation XLTextViewPlaceHolder
#pragma mark - 懒加载
- (UILabel *)placeHolderLabel{
    if (!_placeHolderLabel) {
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = MyColor(187, 187, 187);
        _placeHolderLabel = label;
        [self addSubview:label];
    }
    return _placeHolderLabel;
}

#pragma mark - 重写初始化方法
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //设置默认的字体大小
        self.font = [UIFont systemFontOfSize:15];
        
    }
    return self;
}


- (void)setPlaceHolder:(NSString *)placeHolder{
    _placeHolder = placeHolder;
    
    //对占位符控件进行赋值
    self.placeHolderLabel.text = placeHolder;
    //自适应
    [self.placeHolderLabel sizeToFit];
}

#pragma mark - 重写font的set方法，设置占位符控件的字体大小
- (void)setFont:(UIFont *)font{
    [super setFont:font];
    
    self.placeHolderLabel.font = font;
    //当改变字体大小的时候要重新计算label的大小
    [self.placeHolderLabel sizeToFit];
}

#pragma mark - 设置子控件的frame
- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.placeHolderLabel.origin = CGPointMake(5, 8);
}

#pragma mark - 判断是否隐藏placeHolderLabel
- (void)setHidePlaceHolder:(BOOL)hidePlaceHolder{
    _hidePlaceHolder = hidePlaceHolder;
    
    self.placeHolderLabel.hidden = hidePlaceHolder;
}



@end
