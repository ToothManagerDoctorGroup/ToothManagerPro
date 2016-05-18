//
//  XLServerTeamButton.m
//  CRM
//
//  Created by Argo Zhang on 16/3/2.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLServerTeamButton.h"
#import "UIColor+Extension.h"

#define CommonFont [UIFont systemFontOfSize:15]
#define CommonColor [UIColor colorWithHex:0x333333]
#define DividerHeight 1
#define DividerColor [UIColor colorWithHex:0xCCCCCC]

@interface XLServerTeamButton ()

@property (nonatomic, weak)UIImageView *iconView;//图片
@property (nonatomic, weak)UILabel *titleLabel;//标题
@property (nonatomic, weak)UILabel *teamCoutLabel;//团队成员数
@property (nonatomic, weak)UIImageView *arrowView;//箭头

@end

@implementation XLServerTeamButton
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

#pragma mark - 初始化
- (void)setUp{
    //图片
    UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"team_team"]];
    self.iconView = iconView;
    [self addSubview:iconView];
    
    //标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = CommonColor;
    titleLabel.font = CommonFont;
    self.titleLabel = titleLabel;
    [self addSubview:titleLabel];
    
    //团队成员数
    UILabel *teamCoutLabel = [[UILabel alloc] init];
    teamCoutLabel.textColor = CommonColor;
    teamCoutLabel.font = CommonFont;
    self.teamCoutLabel = teamCoutLabel;
    [self addSubview:teamCoutLabel];
    
    //箭头
    UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_crm"]];
    self.arrowView = arrowView;
    [self addSubview:arrowView];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    //添加两个分割线
    for (int i = 0; i < 2; i++) {
        UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(0, i * (self.height - DividerHeight), kScreenWidth, DividerHeight)];
        divider.backgroundColor = DividerColor;
        [self addSubview:divider];
    }
    
    //图片
    CGFloat margin = 10;
    CGFloat iconW = 25;
    CGFloat iconH = 18;
    CGFloat iconX = margin;
    CGFloat iconY = (self.height - iconH - DividerHeight * 2) / 2;
    self.iconView.frame = CGRectMake(iconX, iconY, iconW, iconH);
    
    //标题
    NSString *title = @"服务团队";
    CGSize titleSize = [title sizeWithFont:CommonFont];
    CGFloat titleX = self.iconView.right + 5;
    CGFloat titleY = (self.height - DividerHeight * 2 - titleSize.height) / 2;
    CGFloat titleW = titleSize.width;
    CGFloat titleH = titleSize.height;
    self.titleLabel.frame = CGRectMake(titleX, titleY, titleW, titleH);
    self.titleLabel.text = title;
    
    //箭头
    CGFloat arrowW = 13;
    CGFloat arrowH = 18;
    CGFloat arrowY = (self.height - DividerHeight * 2 - arrowH) / 2;
    CGFloat arrowX = self.width - margin - arrowW;
    self.arrowView.frame = CGRectMake(arrowX, arrowY, arrowW, arrowH);
    
}

- (void)setMemberNum:(NSInteger)memberNum{
    _memberNum = memberNum;
    
    CGFloat arrowX = self.width - 10 - 13;
    //团队成员数
    NSString *teamCount = [NSString stringWithFormat:@"%ld人",(long)self.memberNum];
    CGSize teamCountSize = [teamCount sizeWithFont:CommonFont];
    CGFloat teamCountW = teamCountSize.width;
    CGFloat teamCountH = teamCountSize.height;
    CGFloat teamCountX = arrowX - 10 - teamCountW;
    CGFloat teamCountY = (self.height - DividerHeight * 2 - teamCountSize.height) / 2;
    self.teamCoutLabel.frame = CGRectMake(teamCountX, teamCountY, teamCountW, teamCountH);
    self.teamCoutLabel.text = teamCount;
//    self.teamCoutLabel.text = [NSString stringWithFormat:@"%ld人",(long)memberNum];
}

@end
