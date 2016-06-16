//
//  MenuView.m
//  CRM
//
//  Created by lsz on 15/11/12.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "MenuView.h"
#import "CommonMacro.h"

@implementation MenuView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)init{
    self = [super init];
    
    UIButton *yuyueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [yuyueBtn setFrame:CGRectMake(0, 0, 104, 44)];
    [yuyueBtn setTitle:@"添加预约" forState:UIControlStateNormal];
    [yuyueBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [yuyueBtn addTarget:self action:@selector(yuyueClick) forControlEvents:UIControlEventTouchUpInside];
    [yuyueBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [self addSubview:yuyueBtn];
    
    UIButton *huanzheBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [huanzheBtn setFrame:CGRectMake(0, 44, 104, 44)];
    [huanzheBtn setTitle:@"添加患者" forState:UIControlStateNormal];
    [huanzheBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [huanzheBtn addTarget:self action:@selector(huanzheClick) forControlEvents:UIControlEventTouchUpInside];
    [huanzheBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [self addSubview:huanzheBtn];
    
    UIImageView *xianView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44, 104, 1)];
    [xianView setImage:[UIImage imageNamed:@"menuXian"]];
    [self addSubview:xianView];
    return self;
}


-(void)drawRect:(CGRect)rect{

}
-(void)yuyueClick{
    NSLog(@"添加预约");
    [self.delegate yuyueButtonDidSelected];
//    [self removeFromSuperview];
}
-(void)huanzheClick{
    NSLog(@"添加患者");
    [self.delegate huanzheButtonDidSeleted];
//    [self removeFromSuperview];
}
@end
