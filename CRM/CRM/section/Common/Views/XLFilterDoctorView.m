//
//  XLFilterDoctorView.m
//  CRM
//
//  Created by Argo Zhang on 16/4/6.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLFilterDoctorView.h"
#import "UIColor+Extension.h"
#import "UIImage+TTMAddtion.h"
#import "XLFilterDoctorListView.h"
#import "XLThreaterSelectViewController.h"
#import "UIView+WXViewController.h"

#define Normal_Height 60
#define CommonWidth 50
#define LINE_HEIGHT .5

@interface XLFilterDoctorView ()<XLThreaterSelectViewControllerDelegate,XLFilterDoctorListViewDelegate>{
    UIView *_dividerViewBottom;
    UIView *_dividerViewMid;
    
    UIView *_chooseSuperView;
    UILabel *_tintLabel;
    UIImageView *_arrowImageView;
    
    XLFilterDoctorListView *_listView;
}

@property (nonatomic, strong)UILabel *titleLabel;

@property (nonatomic, strong)NSArray *selectDoctors;

@end

@implementation XLFilterDoctorView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setUp];
    }
    return self;
}

#pragma mark - 初始化
- (void)setUp{
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"医生：";
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.textColor = [UIColor colorWithHex:0x888888];
    [self addSubview:_titleLabel];
    
    //分割线
    _dividerViewBottom = [[UIView alloc] init];
    _dividerViewBottom.backgroundColor = [UIColor colorWithHex:0xcccccc];
    [self addSubview:_dividerViewBottom];
    
    _chooseSuperView = [[UIView alloc] init];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_chooseSuperView addGestureRecognizer:tap];
    [self addSubview:_chooseSuperView];
    
    _tintLabel = [[UILabel alloc] init];
    _tintLabel.text = @"请选择修复医生";
    _tintLabel.font = [UIFont systemFontOfSize:15];
    _tintLabel.textColor = [UIColor colorWithHex:0xbbbbbb];
    [_chooseSuperView addSubview:_tintLabel];
    
    _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_crm"]];
    [_chooseSuperView addSubview:_arrowImageView];
    
    //分割线
    _dividerViewMid = [[UIView alloc] init];
    _dividerViewMid.backgroundColor = [UIColor colorWithHex:0xcccccc];
    [_chooseSuperView addSubview:_dividerViewMid];
    
    _listView = [[XLFilterDoctorListView alloc] init];
    _listView.delegate = self;
    [self addSubview:_listView];
    
    //设置frame
    [self setUpSubviewFrame];
}

#pragma mark - tapAction
- (void)tapAction:(UITapGestureRecognizer *)tap{
    XLThreaterSelectViewController *threaterVc = [[XLThreaterSelectViewController alloc] init];
    threaterVc.hidesBottomBarWhenPushed = YES;
    threaterVc.existMembers = self.selectDoctors;
    threaterVc.delegate = self;
    [self.viewController.navigationController pushViewController:threaterVc animated:YES];
}

#pragma mark - 设置子控件frame
- (void)setUpSubviewFrame{
    
    CGFloat margin = 10;
    CGFloat arrowW = 13;
    CGFloat arrowH = 18;
    
    _titleLabel.frame = CGRectMake(margin, 0, CommonWidth, Normal_Height);
    _chooseSuperView.frame = CGRectMake(_titleLabel.right, 0, kScreenWidth - _titleLabel.right, Normal_Height);
    _arrowImageView.frame = CGRectMake(_chooseSuperView.width - margin - arrowW, (_chooseSuperView.height - arrowH) / 2, arrowW, arrowH);
    _tintLabel.frame = CGRectMake(0, 0, _arrowImageView.left - margin, Normal_Height);
    _dividerViewMid.frame = CGRectMake(0, _chooseSuperView.height - LINE_HEIGHT, _chooseSuperView.width, LINE_HEIGHT);
    
    _listView.frame = CGRectMake(_titleLabel.right, _dividerViewMid.bottom, _chooseSuperView.width, [_listView fixHeigthWithWidth:_chooseSuperView.width]);
    _dividerViewBottom.frame = CGRectMake(0, [self fixHeight] - LINE_HEIGHT, kScreenWidth, LINE_HEIGHT);
}


- (void)setSelectDoctors:(NSArray *)selectDoctors{
    _selectDoctors = selectDoctors;
    
    [_listView.sourceArray removeAllObjects];
    _listView.sourceArray = [selectDoctors mutableCopy];
    //重新设置frame
    [self setUpSubviewFrame];
}

- (CGFloat)fixHeight{
    return [_listView fixHeigthWithWidth:_chooseSuperView.width] + Normal_Height;
}

#pragma mark - XLThreaterSelectViewControllerDelegate
- (void)threaterSelectViewController:(XLThreaterSelectViewController *)selectVc didSelectDoctors:(NSArray *)selectDocs{
    self.selectDoctors = selectDocs;
    [self setUpDelegateWithArray:selectDocs];
}

#pragma mark - XLFilterDoctorListViewDelegate
- (void)filterDoctorListView:(XLFilterDoctorListView *)listView didChooseDoctors:(NSArray *)doctors{
    _selectDoctors = doctors;
    [self setUpDelegateWithArray:doctors];
}
//设置代理
- (void)setUpDelegateWithArray:(NSArray *)array{
    //刷新视图
    if (self.delegate && [self.delegate respondsToSelector:@selector(filterDoctorView:didSelectDoctors:)]) {
        [self.delegate filterDoctorView:self didSelectDoctors:array];
    }
}

#pragma mark - 重置
- (void)reset{
    self.selectDoctors = @[];
}

@end
