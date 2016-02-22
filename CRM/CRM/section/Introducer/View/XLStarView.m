//
//  XLStarView.m
//  CRM
//
//  Created by Argo Zhang on 16/2/19.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLStarView.h"
#import "TimStarView.h"
#import "XLStarSelectViewController.h"
#import "UIView+WXViewController.h"

@interface XLStarView ()<XLStarSelectViewControllerDelegate>

@property (nonatomic, strong)TimStarView *starView;

@end

@implementation XLStarView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)awakeFromNib{
    //初始化
    [self setUp];
}

- (void)setUp{
    if (self.starView == nil) {
        self.starView = [[TimStarView alloc] init];
        self.starView.userInteractionEnabled = NO;
        [self addSubview:self.starView];
    }
    
    //添加单击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
}

- (void)setLevel:(NSInteger)level{
    _level = level;
    
    self.starView.frame = CGRectMake((self.bounds.size.width - 75) / 2, (self.bounds.size.height - 15) / 2, 75, 15);
    self.starView.scale = level;
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    XLStarSelectViewController *selectVc = [[XLStarSelectViewController alloc] initWithStyle:UITableViewStyleGrouped];
    selectVc.delegate = self;
    [self.viewController.navigationController pushViewController:selectVc animated:YES];
}

- (void)starSelectViewController:(XLStarSelectViewController *)starSelectVc didSelectLevel:(NSInteger)level{
    [self setLevel:level];
}

@end
