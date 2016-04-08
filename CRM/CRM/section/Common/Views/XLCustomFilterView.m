//
//  XLCustomFilterView.m
//  CRM
//
//  Created by Argo Zhang on 16/3/31.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLCustomFilterView.h"
#import "UIColor+Extension.h"
#import "XLFilterCell.h"

#define LeftButtonWidth 90
#define LeftButtonHeight 50
#define LeftButtonColorNormal [UIColor colorWithHex:0xeeeeee]
#define LeftButtonColorSelect [UIColor colorWithHex:0xffffff]
#define LeftButtonTitleColorSelect [UIColor colorWithHex:0x00a0ea]
#define LeftButtonTitleColorNormal [UIColor colorWithHex:0x888888]
#define LeftButtonTitleFont [UIFont systemFontOfSize:14]

@interface XLCustomFilterView ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_leftTableView;
    UIView *_rightMenuView;
}

@property (nonatomic, assign)NSInteger preIndex;

@end

@implementation XLCustomFilterView

- (instancetype)initWithFrame:(CGRect)frame dataSource:(id<XLCustomFilterViewDataSource>)dataSource delegate:(id<XLCustomFilterViewDelegate>)delegate{
    if (self = [super initWithFrame:frame]) {
        self.dataSource = dataSource;
        self.delegate = delegate;
        [self setUp];
    }
    return self;
}

#pragma mark - 初始化
- (void)setUp{
    _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, LeftButtonWidth, self.frame.size.height) style:UITableViewStylePlain];
    _leftTableView.backgroundColor = LeftButtonColorNormal;
    _leftTableView.delegate = self;
    _leftTableView.dataSource = self;
    _leftTableView.rowHeight = LeftButtonHeight;
    _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_leftTableView];
    
    _rightMenuView = [[UIView alloc] initWithFrame:CGRectMake(_leftTableView.right, 0, self.frame.size.width - LeftButtonWidth, self.frame.size.height)];
    _rightMenuView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_rightMenuView];
    
    //默认选中第二个
    self.preIndex = 1;
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:self.preIndex inSection:0];
    [_leftTableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    XLFilterCell *preCell = [_leftTableView cellForRowAtIndexPath:selectedIndexPath];
    preCell.buttonTitleLabel.textColor = LeftButtonTitleColorSelect;
    //设置关联视图为第二个视图
    [_rightMenuView addSubview:[self.dataSource customFilterView:self viewForItemAtIndex:selectedIndexPath.row]];
}

#pragma mark - 刷新数据源
- (void)reloadData{
    [_leftTableView reloadData];
}

#pragma mark - UITableViewDataSource/Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSource numberOfItemsInCustomFilterView:self];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XLFilterCell *cell = [XLFilterCell cellWithTableView:tableView];
    
    cell.title = [self.dataSource customFilterView:self titleForItemAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //获取上一个被点击的cell
    NSIndexPath *preIndexPath = [NSIndexPath indexPathForRow:self.preIndex inSection:0];
    XLFilterCell *preCell = [tableView cellForRowAtIndexPath:preIndexPath];
    preCell.buttonTitleLabel.textColor = LeftButtonTitleColorNormal;
    
    XLFilterCell *curCell = [tableView cellForRowAtIndexPath:indexPath];
    curCell.buttonTitleLabel.textColor = LeftButtonTitleColorSelect;
    self.preIndex = indexPath.row;
    
    [_rightMenuView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_rightMenuView addSubview:[self.dataSource customFilterView:self viewForItemAtIndex:indexPath.row]];
    
    //调用代理
    if (self.delegate && [self.delegate respondsToSelector:@selector(customFilterView:didSelectItem:)]) {
        [self.delegate customFilterView:self didSelectItem:indexPath.row];
    }
}

@end
