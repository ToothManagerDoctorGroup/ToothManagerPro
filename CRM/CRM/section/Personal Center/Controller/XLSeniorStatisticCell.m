//
//  XLSeniorStatisticCell.m
//  CRM
//
//  Created by Argo Zhang on 16/1/22.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLSeniorStatisticCell.h"
#import "UIColor+Extension.h"
#import "UIView+WXViewController.h"
#import "XLGroupManagerViewController.h"

@interface XLSeniorStatisticCell ()

@property (nonatomic, weak)UIImageView *btnImageView;
@property (nonatomic, weak)UILabel *titleLabel;
@property (nonatomic, weak)UILabel *contentLabel;
@property (nonatomic, weak)UIButton *detailBtn;

@end

@implementation XLSeniorStatisticCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"seniorStatistic_cell";
    XLSeniorStatisticCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //初始化
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self setUp];
        
    }
    return self;
}
#pragma mark - 初始化
- (void)setUp{
    UIImageView *btnImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"statistics_background"]];
    self.btnImageView = btnImageView;
    [self.contentView addSubview:btnImageView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor colorWithHex:0x00a0ea];
    titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel = titleLabel;
    [self.contentView addSubview:titleLabel];
    
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.textColor = [UIColor colorWithHex:0x00a0ea];
    contentLabel.font = [UIFont systemFontOfSize:24];
    self.contentLabel = contentLabel;
    [self.contentView addSubview:contentLabel];
    
    UIButton *detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [detailBtn setTitle:@"查看明细" forState:UIControlStateNormal];
    detailBtn.layer.cornerRadius = 5;
    detailBtn.layer.masksToBounds = YES;
    detailBtn.layer.borderWidth = 1;
    detailBtn.layer.borderColor = [UIColor colorWithHex:0x00a0ea].CGColor;
    [detailBtn setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
    detailBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.detailBtn = detailBtn;
    [detailBtn addTarget:self action:@selector(detailButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:detailBtn];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat imageW = 280;
    CGFloat imageH = 222;
    CGFloat imageX = (kScreenWidth - 280) / 2;
    CGFloat imageY = 40;
    self.btnImageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
    
    CGSize titleSize = [self.title sizeWithFont:[UIFont systemFontOfSize:15]];
    self.titleLabel.frame = CGRectMake(0, 0, titleSize.width, titleSize.height);
    self.titleLabel.center = CGPointMake(self.btnImageView.center.x, self.btnImageView.center.y - 30);
    self.titleLabel.text = self.title;

    NSString *countStr = [NSString stringWithFormat:@"%lu",(unsigned long)self.dataList.count];
    CGSize countSize = [countStr sizeWithFont:[UIFont systemFontOfSize:24]];
    self.contentLabel.frame = CGRectMake(0, 0, countSize.width, countSize.height);
    self.contentLabel.center = CGPointMake(self.btnImageView.center.x, self.btnImageView.center.y);
    
    self.contentLabel.text = countStr;

    self.detailBtn.frame = CGRectMake((kScreenWidth - 150) / 2, self.btnImageView.bottom + 20, 150, 40);

}

#pragma mark - 详情按钮点击
- (void)detailButtonClick{
    XLGroupManagerViewController *mangerVc = [[XLGroupManagerViewController alloc] init];
    mangerVc.isAnalyse = YES;
    mangerVc.analyseList = self.dataList;
    mangerVc.title = self.title;
    [self.viewController.navigationController pushViewController:mangerVc animated:YES];
    
}


@end
