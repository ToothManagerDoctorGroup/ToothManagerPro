//
//  AddButtonFooterView.m
//  CRM
//
//  Created by TimTiger on 5/29/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "AddButtonFooterView.h"

@implementation AddButtonFooterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setView {
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(230, 0, 30, 30);
    [addButton setImage:[UIImage imageNamed:@"btn_more"] forState:UIControlStateNormal];
    [addButton setImageEdgeInsets:UIEdgeInsetsMake(15/2, 15/2, 15/2, 15/2)];
    [addButton addTarget:self action:@selector(addButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addButton];
    UIView *separatorLine = [[UIView alloc]initWithFrame:CGRectMake(0,29.5,320, 0.5)];
    separatorLine.backgroundColor = [UIColor whiteColor];
    [self addSubview:separatorLine];
}

- (void)addButtonAction:(id)sender {
    
}

@end
