//
//  ScheduleDateButton.m
//  CRM
//
//  Created by Argo Zhang on 15/12/14.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "ScheduleDateButton.h"

@interface ScheduleDateButton (){
    UILabel *_dateLabel;//年月
    UIButton *_arrowButton;//箭头按钮
    
}

@end

@implementation ScheduleDateButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化
        [self setUp];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp{
    
    //添加单击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
    
    _dateLabel = [[UILabel alloc] init];
    _dateLabel.textColor = [UIColor blackColor];
    _dateLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:_dateLabel];
    
    _arrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_arrowButton setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
    [_arrowButton setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState:UIControlStateSelected];
    [self addSubview:_arrowButton];
}

- (void)setTitle:(NSString *)title{
    _title = title;
    
    CGSize titleSize = [title sizeWithFont:[UIFont systemFontOfSize:16]];
    _dateLabel.frame = CGRectMake(0, (self.height - titleSize.height) / 2, titleSize.width, titleSize.height);
    _dateLabel.text = title;
    
    _arrowButton.frame = CGRectMake(_dateLabel.right + 5, (self.height - 7) / 2, 13, 7);
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    _arrowButton.selected = !_arrowButton.isSelected;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickDateButton)]) {
        [self.delegate didClickDateButton];
    }
    
}

- (void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    
    _arrowButton.selected = isSelected;
}



@end
