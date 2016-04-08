//
//  XLRecordCell.m
//  CRM
//
//  Created by Argo Zhang on 15/12/25.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "XLRecordCell.h"
#import "DBTableMode.h"
#import "UIColor+Extension.h"
#import "MyDateTool.h"

#define CommenFont [UIFont systemFontOfSize:12]

@interface XLRecordCell ()

@property (nonatomic, weak)UIImageView *headImageView;//头像
@property (nonatomic, weak)UILabel *nameLabel;//姓名
@property (nonatomic, weak)UILabel *timeLabel;//时间
@property (nonatomic, weak)UIButton *contentButton;//内容

@end

@implementation XLRecordCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"record_cell";
    XLRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = [UIColor clearColor];
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

- (void)setUp{
    UIImageView *headImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user_icon"]];
    headImageView.layer.cornerRadius = 20;
    headImageView.layer.masksToBounds = YES;
    self.headImageView = headImageView;
    headImageView.layer.borderColor = [UIColor colorWithHex:0xdddddd].CGColor;
    headImageView.layer.borderWidth = 1;
    [self.contentView addSubview:headImageView];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = MyColor(51, 51, 51);
    nameLabel.font = CommenFont;
    self.nameLabel = nameLabel;
    [self.contentView addSubview:nameLabel];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.textColor = MyColor(51, 51, 51);
    timeLabel.font = CommenFont;
    self.timeLabel = timeLabel;
    [self.contentView addSubview:self.timeLabel];
    
    UIButton *contentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //设置字体大小
    [contentButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    //设置自动换行
    contentButton.titleLabel.numberOfLines = 0;
    //设置文字的内边距(同时可以增大背景图片的宽度和高度)
    contentButton.titleEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15);
    self.contentButton = contentButton;
    [contentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.contentView addSubview:contentButton];
}

- (void)setRecord:(MedicalRecord *)record{
    _record = record;
    
    CGFloat marginY = 10;
    CGFloat marginX = 15;
    CGFloat imageW = 40;
    CGFloat imageH = 40;
    
    self.headImageView.frame = CGRectMake(marginX, marginY, imageW, imageH);
    
    NSString *name = record.doctor_name;
    CGSize nameSize = [name sizeWithFont:CommenFont];
    self.nameLabel.frame = CGRectMake(self.headImageView.right + marginY, marginY, nameSize.width, 20);
    self.nameLabel.text = name;
    
    
    NSString *time = [MyDateTool stringWithDateNoSec:[MyDateTool dateWithStringWithSec:record.creation_date]];
    CGSize timeSize = [time sizeWithFont:CommenFont];
    self.timeLabel.frame = CGRectMake(kScreenWidth - timeSize.width - marginX, marginY, timeSize.width, 20);
    self.timeLabel.text = time;
    
    
    CGSize contentSize = [record.record_content sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kScreenWidth - 15 * 2 - 10 - 40 - 35, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    self.contentButton.frame = CGRectMake(self.headImageView.right + marginY, self.nameLabel.bottom, contentSize.width + 35, contentSize.height + 30);
    [self.contentButton setTitle:record.record_content forState:UIControlStateNormal];
    UIImage *imageNor = [UIImage imageNamed:@"chat_recive_nor"];
    //设置图片以平铺对方式拉伸
    imageNor = [imageNor stretchableImageWithLeftCapWidth:imageNor.size.width * 0.5 topCapHeight:imageNor.size.height * 0.5];
    [self.contentButton setBackgroundImage:imageNor forState:UIControlStateNormal];
}


@end
