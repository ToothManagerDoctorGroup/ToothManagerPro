//
//  SysMessageCell.m
//  CRM
//
//  Created by Argo Zhang on 15/12/16.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "SysMessageCell.h"
#import "SysMessageModel.h"

#define TitleFont [UIFont systemFontOfSize:15]
#define TitleColor [UIColor blackColor]
#define CommenFont [UIFont systemFontOfSize:13]
#define CommenColor MyColor(100, 100, 100)

@interface SysMessageCell ()

@property (nonatomic, weak)UILabel *titleLabel;
@property (nonatomic, weak)UILabel *timeLabel;
@property (nonatomic, weak)UILabel *contentLabel;
@property (nonatomic, weak)UIView *divider;

@end

@implementation SysMessageCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"sys_message";
    SysMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //初始化
        [self setUp];
    }
    return self;
}
#pragma mark - 初始化
- (void)setUp{
    //标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = TitleFont;
    titleLabel.textColor = TitleColor;

    self.titleLabel = titleLabel;
    [self.contentView addSubview:titleLabel];
    
    //时间
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = CommenFont;
    timeLabel.textColor = CommenColor;

    self.timeLabel = timeLabel;
    [self.contentView addSubview:timeLabel];
    
    //内容
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = CommenFont;
    contentLabel.textColor = CommenColor;
    self.contentLabel = contentLabel;
    [self.contentView addSubview:contentLabel];
    
    //分割线
    UIView *divider = [[UIView alloc] init];
    divider.backgroundColor = MyColor(225, 225, 226);
    self.divider = divider;
    [self.contentView addSubview:divider];
}

- (void)setModel:(SysMessageModel *)model{
    _model = model;
    
    if ([model.message_type isEqualToString:AttainNewFriend]) {
        self.titleLabel.text = @"新增好友";
    }else{
        self.titleLabel.text = @"新增患者";
    }
    
    self.timeLabel.text = self.model.create_time;
    
    self.contentLabel.text = self.model.message_content;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat margin = 10;
    CGSize titleSize = [self.titleLabel.text sizeWithFont:TitleFont];
    self.titleLabel.frame = CGRectMake(margin, margin / 2, titleSize.width, 20);
    
    
    CGSize timeSize = [self.model.create_time sizeWithFont:CommenFont];
    self.timeLabel.frame = CGRectMake(kScreenWidth - timeSize.width - margin, margin / 2, timeSize.width, 20);
    
    self.contentLabel.frame = CGRectMake(margin, self.titleLabel.bottom + margin, kScreenWidth - margin * 2, 20);
    
    self.divider.frame = CGRectMake(0, self.height - 1, kScreenWidth, 1);
}

@end
