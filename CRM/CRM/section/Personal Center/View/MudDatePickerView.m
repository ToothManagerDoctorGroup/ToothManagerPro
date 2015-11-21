//
//  MudDatePickerView.m
//  CRM
//
//  Created by doctor on 15/4/28.
//  Copyright (c) 2015年 TimTiger. All rights reserved.
//

#import "MudDatePickerView.h"
#import "CommonMacro.h"

@implementation MudDatePickerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRed:62.0/255.0f green:155.0/255.0f blue:225.0/255.0f alpha:0.9];
        
        self.datePicker =[[UIDatePicker alloc] initWithFrame:CGRectMake(0.0f, 44, SCREEN_WIDTH, 216.0f)];
        [self.datePicker setDatePickerMode:UIDatePickerModeDate];
        self.datePicker.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        self.datePicker.datePickerMode = UIDatePickerModeDate;
        self.datePicker.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
        
        UIButton *OKbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        OKbutton.frame = CGRectMake(self.frame.size.width-60.0f, 7.0f, 50.0f, 30.0f);
        [OKbutton setTitle:@"确定" forState:UIControlStateNormal];
        [OKbutton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        OKbutton.titleLabel.textColor = [UIColor whiteColor];
        OKbutton.tag = 0;
        [OKbutton addTarget:self action:@selector(OKOrCancelEvnet:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(10.0f, 7.0f, 50.0f, 30.0f);
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        cancelButton.titleLabel.textColor = [UIColor whiteColor];
        cancelButton.tag = 1;
        [cancelButton addTarget:self action:@selector(OKOrCancelEvnet:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:OKbutton];
        [self addSubview:cancelButton];
        [self addSubview:self.datePicker];
    }
    return self;
}

- (void)OKOrCancelEvnet:(UIButton *)sender
{
    switch (sender.tag) {
        case 0:
        {
            //确定
            if (self.delegate && [self.delegate respondsToSelector:@selector(certainButtonOnClickedWithDateString:)]) {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                NSString *dateString = [dateFormatter stringFromDate:self.datePicker.date];
                [self.delegate certainButtonOnClickedWithDateString:dateString];
            }
        }
            break;
        case 1:
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(cancelButtonOnClicked)]) {
                [self.delegate cancelButtonOnClicked];
            }
        }
            break;
        default:
            break;
    }
}

- (void)setDate:(NSDate *)date
{
    [self.datePicker setDate:date animated:YES];
}

@end
