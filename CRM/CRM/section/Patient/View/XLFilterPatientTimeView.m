//
//  XLFilterPatientTimeView.m
//  CRM
//
//  Created by Argo Zhang on 16/4/1.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLFilterPatientTimeView.h"
#import "UIColor+Extension.h"
#import "TimPickerTextField.h"
#import "NSString+TTMAddtion.h"
#import "MyDateTool.h"

#define BUTTON_TITLE_COLOR [UIColor colorWithHex:0x333333]
#define BUTTON_TITLE_FONT [UIFont systemFontOfSize:14]
#define BUTTON_BACKGROUNDCOLOR [UIColor colorWithHex:0xeeeeee]
#define ROWCOUNT 2

@interface XLFilterPatientTimeView ()<TimPickerTextFieldDelegate>

@property (nonatomic, strong)NSArray *buttonTitles;
@property (nonatomic, strong)UILabel *targetLabel;
@property (nonatomic, strong)TimPickerTextField *startTimeField;
@property (nonatomic, strong)TimPickerTextField *endTimeField;

@end

@implementation XLFilterPatientTimeView

- (UILabel *)targetLabel{
    if (!_targetLabel) {
        _targetLabel = [[UILabel alloc] init];
        _targetLabel.font = BUTTON_TITLE_FONT;
        _targetLabel.textColor = [UIColor colorWithHex:0x888888];
        _targetLabel.textAlignment = NSTextAlignmentCenter;
        _targetLabel.text = @"自定义时间段";
        [self addSubview:_targetLabel];
    }
    return _targetLabel;
}

- (TimPickerTextField *)startTimeField{
    if (!_startTimeField) {
        _startTimeField = [[TimPickerTextField alloc] init];
        //开始时间
        _startTimeField.placeholder = @"开始时间";
        _startTimeField.textAlignment = NSTextAlignmentCenter;
        _startTimeField.textColor = BUTTON_TITLE_COLOR;
        _startTimeField.font = BUTTON_TITLE_FONT;
        _startTimeField.layer.cornerRadius = 5;
        _startTimeField.layer.masksToBounds = YES;
        _startTimeField.layer.borderWidth = 1;
        _startTimeField.layer.borderColor = [UIColor colorWithHex:0xcccccc].CGColor;
        _startTimeField.mode = TextFieldInputModeDatePicker;
        _startTimeField.dateMode = TextFieldDateModeDate;
        _startTimeField.isBirthDay = YES;
        _startTimeField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _startTimeField.actiondelegate = self;
        [self addSubview:_startTimeField];
        
    }
    return _startTimeField;
}

- (TimPickerTextField *)endTimeField{
    if (!_endTimeField) {
        _endTimeField = [[TimPickerTextField alloc] init];
        //结束时间
        _endTimeField.placeholder = @"结束时间";
        _endTimeField.textColor = BUTTON_TITLE_COLOR;
        _endTimeField.font = BUTTON_TITLE_FONT;
        _endTimeField.textAlignment = NSTextAlignmentCenter;
        _endTimeField.layer.cornerRadius = 5;
        _endTimeField.layer.masksToBounds = YES;
        _endTimeField.layer.borderWidth = 1;
        _endTimeField.mode = TextFieldInputModeDatePicker;
        _endTimeField.dateMode = TextFieldDateModeDate;
        _endTimeField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _endTimeField.isBirthDay = YES;
        _endTimeField.actiondelegate = self;
        _endTimeField.layer.borderColor = [UIColor colorWithHex:0xcccccc].CGColor;
        [self addSubview:_endTimeField];
    }
    return _endTimeField;
}

- (NSArray *)buttonTitles{
    if (!_buttonTitles) {
        _buttonTitles = @[@"今日",@"本周",@"本月"];
    }
    return _buttonTitles;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp{
    for (int i = 0; i < self.buttonTitles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 100 + i;
        [button setTitle:self.buttonTitles[i] forState:UIControlStateNormal];
        [button setTitleColor:BUTTON_TITLE_COLOR forState:UIControlStateNormal];
        button.titleLabel.font = BUTTON_TITLE_FONT;
        button.backgroundColor = BUTTON_BACKGROUNDCOLOR;
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    
    //添加标签视图
    [self targetLabel];
    [self startTimeField];
    [self endTimeField];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat buttonW = 100;
    CGFloat buttonH = 35;
    CGFloat marginY = 20;
    CGFloat marginX = (self.width - ROWCOUNT * buttonW) / 3;
    
    CGFloat buttonX = 0;
    CGFloat buttonY = 0;
    
    for (int i = 0; i < self.buttonTitles.count; i++) {
        UIButton *button = [self viewWithTag:100 + i];
        
        NSInteger index_x = i / ROWCOUNT;
        NSInteger index_y = i % ROWCOUNT;
        
        buttonX = marginX + index_y * (buttonW + marginX);
        buttonY = marginY + index_x * (buttonH + marginY);
        
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
    }
    
    NSInteger cols = self.buttonTitles.count / 2 == 0 ? self.buttonTitles.count / 2 : self.buttonTitles.count / 2 + 1;
    CGFloat targetX = 0;
    CGFloat targetY = (marginY + buttonH) * cols + 10;
    CGSize targetSize = [self.targetLabel.text measureFrameWithFont:BUTTON_TITLE_FONT size:CGSizeMake(MAXFLOAT, MAXFLOAT)].size;
    self.targetLabel.frame = CGRectMake(targetX, targetY, self.width, targetSize.height);
    
    CGFloat startW = buttonW * 2 + marginX;
    CGFloat startH = 35;
    CGFloat startX = (self.width - startW) / 2;
    self.startTimeField.frame = CGRectMake(startX, self.targetLabel.bottom + 10, startW, startH);
    self.endTimeField.frame = CGRectMake(startX, self.startTimeField.bottom + 10, startW, startH);
}

#pragma mark - 按钮点击事件
- (void)buttonAction:(UIButton *)button{
    NSString *startTime;
    NSString *endTime;
    if (button.tag == 100) {
        //今日
        startTime = [MyDateTool stringWithDateWithSec:[NSDate date]];
        endTime = startTime;
    }else if (button.tag == 101){
        //本周
        startTime = [MyDateTool stringWithDateWithSec:[MyDateTool getMondayDateWithCurrentDate:[NSDate date]]];
        endTime = [MyDateTool stringWithDateWithSec:[MyDateTool getSundayDateWithCurrentDate:[NSDate date]]];
    }else{
        //本月
        startTime = [MyDateTool getMonthBeginWith:[NSDate date]];
        endTime = [MyDateTool getMonthEndWith:startTime];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(filterPatientTimeView:startTime:endTime:)]) {
        [self.delegate filterPatientTimeView:self startTime:startTime endTime:endTime];
    }
}
#pragma mark - TimPickerTextFieldDelegate
- (void)pickerViewFinish:(UIPickerView *)pickerView{
    if ([self.startTimeField.text isNotEmpty] && [self.endTimeField.text isNotEmpty]) {
        //判断开始时间和结束时间
        //比较两个日期的大小
        NSComparisonResult result = [MyDateTool compareStartDateStr:self.startTimeField.text endDateStr:self.endTimeField.text];
        if (result == NSOrderedDescending) {
            [SVProgressHUD showImage:nil status:@"起始时间不能大于终止时间"];
            return;
        }
        NSString *startTime = [NSString stringWithFormat:@"%@ 00:00:00",self.startTimeField.text];
        NSString *endTime = [NSString stringWithFormat:@"%@ 00:00:00",self.endTimeField.text];
        if (self.delegate && [self.delegate respondsToSelector:@selector(filterPatientTimeView:startTime:endTime:)]) {
            [self.delegate filterPatientTimeView:self startTime:startTime endTime:endTime];
        }
    }
}


@end
