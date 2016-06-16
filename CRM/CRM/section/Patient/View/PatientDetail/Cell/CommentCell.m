//
//  CommentCell.m
//  CRM
//
//  Created by Argo Zhang on 15/11/20.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "CommentCell.h"
#import "CommentModelFrame.h"
#import "CommentModel.h"
#import "UIImageView+WebCache.h"
#import "UIColor+Extension.h"

#define CommenTitleColor MyColor(69, 69, 70)
#define DoctorNameFont [UIFont systemFontOfSize:14]
#define SendTimeFont [UIFont systemFontOfSize:12]
#define ContentFont [UIFont systemFontOfSize:16]

@interface CommentCell ()

@property (nonatomic, weak)UIImageView *headImageView;//头像
@property (nonatomic, weak)UILabel *doctorNameLabel;//发送人
@property (nonatomic, weak)UILabel *sendTimeLabel;//发送时间
@property (nonatomic, weak)UILabel *contentLabel;//发送内容

@end

@implementation CommentCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"medical_cell";
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //初始化
        [self setUpSubViews];
    }
    
    return self;
}

#pragma mark -初始化子控件
- (void)setUpSubViews{
    //头像
    UIImageView *headImageView = [[UIImageView alloc] init];
    headImageView.layer.cornerRadius = 25;
    headImageView.layer.masksToBounds = YES;
    headImageView.layer.borderWidth = 1;
    headImageView.layer.borderColor = [UIColor colorWithHex:0xdddddd].CGColor;
    self.headImageView = headImageView;
    [self.contentView addSubview:headImageView];
    
    //发送人
    UILabel *doctorNameLabel = [[UILabel alloc] init];
    doctorNameLabel.textColor = CommenTitleColor;
    doctorNameLabel.font = DoctorNameFont;
    self.doctorNameLabel = doctorNameLabel;
    [self.contentView addSubview:doctorNameLabel];
    
    //发送时间
    UILabel *sendTimeLabel = [[UILabel alloc] init];
    sendTimeLabel.textColor = [UIColor colorWithHex:0x888888];
    sendTimeLabel.font = SendTimeFont;
    self.sendTimeLabel = sendTimeLabel;
    [self.contentView addSubview:sendTimeLabel];
    
    //发送内容
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.textColor = CommenTitleColor;
    contentLabel.font = ContentFont;
    contentLabel.numberOfLines = 0;
    self.contentLabel = contentLabel;
    [self.contentView addSubview:contentLabel];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];

    NSURL *imageUrl = [NSURL URLWithString:self.modelFrame.headImg_url];
    [self.headImageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"header_defult"]];
    self.headImageView.frame = self.modelFrame.headImgFrame;
    
    self.doctorNameLabel.text = self.modelFrame.model.doctor_name;
    self.doctorNameLabel.frame = self.modelFrame.nameFrame;
    
    self.sendTimeLabel.text = self.modelFrame.model.creation_date;
    self.sendTimeLabel.frame = self.modelFrame.timeFrame;
    
    self.contentLabel.text = self.modelFrame.model.cons_content;
    self.contentLabel.frame = self.modelFrame.contentFrame;
    
}

@end
