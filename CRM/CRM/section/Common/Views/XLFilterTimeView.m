//
//  XLFilterTimeView.m
//  CRM
//
//  Created by Argo Zhang on 16/4/6.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLFilterTimeView.h"
#import "NSString+TTMAddtion.h"
#import "UIImage+TTMAddtion.h"
#import "UIColor+Extension.h"
#import "TimPickerTextField.h"
#import "MyDateTool.h"

#define Normal_Height 50
#define CommonWidth 50
#define BUTTON_WIDTH 70
#define BUTTON_HEIGHT 30
#define LINE_HEIGHT .5
#define BUTTON_TITLE_COLOR_NORMAL [UIColor colorWithHex:0x333333]
#define BUTTON_TITLE_COLOR_SELECT [UIColor colorWithHex:0xffffff]

@interface XLFilterTimeView ()<TimPickerTextFieldDelegate,UITextFieldDelegate>{
    UIView *_dividerView;
    
    
}

@property (nonatomic, strong)UILabel *titleLabel;

@property (nonatomic, strong)NSArray *sourceArray;

@property (nonatomic, weak)UIButton *selectBtn;

@end

@implementation XLFilterTimeView
- (instancetype)initWithSourceArray:(NSArray *)sourceArray{
    if (self = [super init]) {
        self.sourceArray = sourceArray;
        self.backgroundColor = [UIColor whiteColor];
        //初始化
        [self setUp];
    }
    return self;
}

#pragma mark - 初始化子视图
- (void)setUp{
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, CommonWidth, Normal_Height)];
    _titleLabel.text = @"时间：";
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.textColor = [UIColor colorWithHex:0x888888];
    [self addSubview:_titleLabel];
    
    //分割线
    _dividerView = [[UIView alloc] init];
    _dividerView.backgroundColor = [UIColor colorWithHex:0xcccccc];
    [self addSubview:_dividerView];
    
    //设置按钮
    for (int i = 0; i < self.sourceArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 300 + i;
        [btn setTitle:self.sourceArray[i] forState:UIControlStateNormal];
        //初始化
        [btn setTitleColor:BUTTON_TITLE_COLOR_NORMAL forState:UIControlStateNormal];
        [btn setTitleColor:BUTTON_TITLE_COLOR_SELECT forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageWithFileName:@"filter_btn_bg_grey"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithFileName:@"filter_btn_bg_blue"] forState:UIControlStateSelected];
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    
    //开始时间
    _startTimeField = [[TimPickerTextField alloc] init];
    _startTimeField.placeholder = @"开始时间";
    _startTimeField.hidden = YES;
    _startTimeField.textAlignment = NSTextAlignmentCenter;
    _startTimeField.textColor = [UIColor colorWithHex:0x333333];
    _startTimeField.font = [UIFont systemFontOfSize:15];
    _startTimeField.layer.cornerRadius = 5;
    _startTimeField.layer.masksToBounds = YES;
    _startTimeField.layer.borderWidth = 1;
    _startTimeField.layer.borderColor = [UIColor colorWithHex:0xdddddd].CGColor;
    _startTimeField.mode = TextFieldInputModeDatePicker;
    _startTimeField.dateMode = TextFieldDateModeDate;
    _startTimeField.isBirthDay = YES;
    _startTimeField.clearButtonMode = UITextFieldViewModeNever;
    _startTimeField.actiondelegate = self;
    [self addSubview:_startTimeField];
    
    //结束时间
    _endTimeField = [[TimPickerTextField alloc] init];
    _endTimeField.placeholder = @"结束时间";
    _endTimeField.hidden = YES;
    _endTimeField.textAlignment = NSTextAlignmentCenter;
    _endTimeField.textColor = [UIColor colorWithHex:0x333333];
    _endTimeField.font = [UIFont systemFontOfSize:15];
    _endTimeField.layer.cornerRadius = 5;
    _endTimeField.layer.masksToBounds = YES;
    _endTimeField.layer.borderWidth = 1;
    _endTimeField.layer.borderColor = [UIColor colorWithHex:0xdddddd].CGColor;
    _endTimeField.mode = TextFieldInputModeDatePicker;
    _endTimeField.dateMode = TextFieldDateModeDate;
    _endTimeField.isBirthDay = YES;
    _endTimeField.clearButtonMode = UITextFieldViewModeNever;
    _endTimeField.actiondelegate = self;
    [self addSubview:_endTimeField];
    
    //设置子控件frame
    [self setUpSubviewFrame];
}

#pragma mark - 设置子控件frame
- (void)setUpSubviewFrame{
    
    _titleLabel.frame = CGRectMake(10, 0, CommonWidth, Normal_Height);
    
    CGFloat margin = 10;
    CGFloat btnSuperWidth = kScreenWidth - margin - CommonWidth;
    //判断当前一行可以显示几个按钮
    int maxCols = (int)btnSuperWidth / (int)(BUTTON_WIDTH + margin);//一行最多显示几列
    //设置子控件
    for (int i = 0; i < self.sourceArray.count; i++) {
        UIButton *btn = [self viewWithTag:300 + i];
        CGFloat marginX = 15;
        //计算总共显示几行
        if (self.sourceArray.count <= maxCols) {
            btn.frame = CGRectMake(i * (BUTTON_WIDTH + marginX), margin, BUTTON_WIDTH, BUTTON_HEIGHT);
        }else{
            NSInteger row = i / maxCols;
            NSInteger col = i % maxCols;
            
            CGFloat btnX = (BUTTON_WIDTH + marginX) * col + self.titleLabel.right;
            CGFloat btnY = margin + (margin + BUTTON_HEIGHT) * row;
            
            btn.frame = CGRectMake(btnX, btnY, BUTTON_WIDTH, BUTTON_HEIGHT);
        }
    }
    
    if (self.isCustomTime) {
        CGFloat fieldW = 110;
        CGFloat fieldH = 30;
        _startTimeField.frame = CGRectMake(self.titleLabel.right, [self mesureHeightWithSourceArray:self.sourceArray], fieldW, fieldH);
        _startTimeField.hidden = NO;
        _endTimeField.frame = CGRectMake(_startTimeField.right + 20, _startTimeField.top, fieldW, fieldH);
        _endTimeField.hidden = NO;
        
        _dividerView.frame = CGRectMake(0, _startTimeField.bottom + 15 - LINE_HEIGHT, kScreenWidth, LINE_HEIGHT);
    }else{
        _startTimeField.hidden = YES;
        _endTimeField.hidden = YES;
        _dividerView.frame = CGRectMake(0, [self mesureHeightWithSourceArray:self.sourceArray] - LINE_HEIGHT, kScreenWidth, LINE_HEIGHT);
    }
}

#pragma mark - 计算当前控件的高度
- (CGFloat)mesureHeightWithSourceArray:(NSArray *)sourceArray{
    CGFloat margin = 10;
    CGFloat btnSuperWidth = kScreenWidth - margin - CommonWidth;
    //判断当前一行可以显示几个按钮
    int maxCols = (int)btnSuperWidth / (int)(BUTTON_WIDTH + margin);//一行最多显示几列
    //计算总共显示几行
    if (sourceArray.count <= maxCols) {
        return Normal_Height;
    }else{
        int rows = (int)sourceArray.count % maxCols == 0 ? (int)sourceArray.count / maxCols : (int)sourceArray.count / maxCols + 1;
        return rows * (BUTTON_HEIGHT + margin) + margin;
    }
}

- (CGFloat)fixHeight{
    
    return self.isCustomTime ? [self mesureHeightWithSourceArray:self.sourceArray] + 45 : [self mesureHeightWithSourceArray:self.sourceArray];
}

- (void)buttonAction:(UIButton *)button{
    
    if (self.selectBtn == button) {
        button.selected = NO;
        self.selectBtn = nil;
        self.isCustomTime = NO;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(filterTimeView:timeState:)]) {
            [self.delegate filterTimeView:self timeState:FilterTimeStateUnSelect];
        }
    }else{
        self.selectBtn.selected = NO;
        button.selected = YES;
        self.selectBtn = button;
        
        if (button.tag == 300 + self.sourceArray.count - 1) {
            self.isCustomTime = button.isSelected;
        }else{
            self.isCustomTime = NO;
            _startTimeField.text = @"";
            _endTimeField.text = @"";
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(filterTimeView:timeState:)]) {
            switch (button.tag - 300) {
                case 0:
                    [self.delegate filterTimeView:self timeState:FilterTimeStateDay];
                    break;
                case 1:
                    [self.delegate filterTimeView:self timeState:FilterTimeStateWeek];
                    break;
                case 2:
                    [self.delegate filterTimeView:self timeState:FilterTimeStateMonth];
                    break;
                case 3:
                    [self.delegate filterTimeView:self timeState:FilterTimeStateCustom];
                    break;
            }
        }
    }
    
}

- (void)setIsCustomTime:(BOOL)isCustomTime{
    _isCustomTime = isCustomTime;
    
    [self setUpSubviewFrame];
}

#pragma mark - 重置
- (void)reset{
    self.selectBtn.selected = NO;
    self.isCustomTime = NO;
    _startTimeField.text = @"";
    _endTimeField.text = @"";
}


@end
