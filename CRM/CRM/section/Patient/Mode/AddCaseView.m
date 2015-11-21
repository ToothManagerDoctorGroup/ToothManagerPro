//
//  AddCaseView.m
//  CRM
//
//  Created by mac on 14-5-13.
//  Copyright (c) 2014年 TimTiger. All rights reserved.
//

#import "AddCaseView.h"

@implementation AddCaseView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    //contentView是整个cell的最下面一层
    
    UIView *viewBg = [[UIView alloc]initWithFrame:CGRectMake(20, 0, self.bounds.size.width-40, self.bounds.size.height)];
    viewBg.backgroundColor = [UIColor blackColor];
    viewBg.alpha = 0.3f;
    viewBg.layer.cornerRadius = 3.0f;
    [self addSubview:viewBg];
    
    addCaseImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    addCaseImageView.image = [UIImage imageNamed:@"btn_new_big_"];
    addCaseImageView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    [self addSubview:addCaseImageView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
