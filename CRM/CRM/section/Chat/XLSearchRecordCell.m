//
//  XLSearchRecordCell.m
//  CRM
//
//  Created by Argo Zhang on 16/5/5.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLSearchRecordCell.h"
#import "UIColor+Extension.h"
#import <UIView+SDAutoLayout.h>
#import "MyDateTool.h"
#import "XLChatModel.h"
#import "AccountManager.h"

#define COMMON_TEXT_FONT [UIFont systemFontOfSize:15]
#define NAME_TEXT_COLOR [UIColor colorWithHex:0x333333]
#define CONTENT_TEXT_COLOR [UIColor colorWithHex:0x888888]
#define TIME_TEXT_FONT [UIFont systemFontOfSize:12]
#define CONTENT_SEARCH_TEXT_COLOR [UIColor colorWithHex:0x00a0ea]

#define Margin 10

@interface XLSearchRecordCell ()

@property (nonatomic, strong)UIImageView *avatarView;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, strong)UILabel *contentLabel;

@end

@implementation XLSearchRecordCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"search_record_cell";
    XLSearchRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpSubViews];
    }
    return self;
}
//初始化
- (void)setUpSubViews{
    [self.contentView addSubview:self.avatarView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.contentLabel];
    
    //设置约束
    [self setUpFrames];
}

- (void)setUpFrames{
    self.avatarView.sd_layout
    .widthIs(40)
    .heightIs(40)
    .topSpaceToView(self.contentView,Margin)
    .leftSpaceToView(self.contentView,Margin);
    
    self.nameLabel.sd_layout
    .leftSpaceToView(self.avatarView,Margin)
    .topSpaceToView(self.contentView,Margin);
    
    self.timeLabel.sd_layout
    .rightSpaceToView(self.contentView,Margin)
    .centerYEqualToView(self.nameLabel)
    .leftSpaceToView(self.nameLabel,Margin)
    .widthIs(130)
    .heightIs(20);
    
    self.contentLabel.sd_layout
    .topSpaceToView(self.nameLabel,Margin)
    .leftSpaceToView(self.avatarView,Margin)
    .rightSpaceToView(self.contentView,Margin)
    .autoHeightRatio(0);
    
    [self setupAutoHeightWithBottomView:self.contentLabel bottomMargin:Margin];
}

- (void)setModel:(XLChatModel *)model{
    _model = model;
    
    if ([model.sender_id isEqualToString:[AccountManager currentUserid]]) {
        self.avatarView.image = [UIImage imageNamed:@"user_icon"];
        self.nameLabel.text = model.sender_name;
    }else{
        self.avatarView.image = [UIImage imageNamed:@"patient_head"];
        self.nameLabel.text = model.sender_name;
    }
    self.timeLabel.text = [MyDateTool stringWithDateNoSec:[MyDateTool dateWithStringWithSec:model.send_time]];
    self.contentLabel.text = model.content;
}

- (void)setSearchText:(NSString *)seachText model:(XLChatModel *)model{
    if ([seachText isNotEmpty]) {
        NSRange range = [model.content rangeOfString:seachText];
        if (range.location != NSNotFound) {
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:model.content];
            [attrStr addAttribute:NSForegroundColorAttributeName value:CONTENT_SEARCH_TEXT_COLOR range:range];
            self.contentLabel.attributedText = attrStr;
        }
    }
}

+ (CGFloat)contentMaxWidth{
    return kScreenWidth - Margin * 3 - 40;
}

#pragma mark - ********************* Lazy Method ***********************
- (UIImageView *)avatarView{
    if (!_avatarView) {
        _avatarView = [[UIImageView alloc] init];
        _avatarView.layer.cornerRadius = 20;
        _avatarView.layer.masksToBounds = YES;
        _avatarView.layer.borderWidth = 1;
        _avatarView.layer.borderColor = CONTENT_TEXT_COLOR.CGColor;
    }
    return _avatarView;
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = NAME_TEXT_COLOR;
        _nameLabel.font = COMMON_TEXT_FONT;
        [_nameLabel sizeToFit];
    }
    return _nameLabel;
}
- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = CONTENT_TEXT_COLOR;
        _timeLabel.font = TIME_TEXT_FONT;
        _timeLabel.textAlignment = NSTextAlignmentRight;
        [_timeLabel sizeToFit];
    }
    return _timeLabel;
}
- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = CONTENT_TEXT_COLOR;
        _contentLabel.font = COMMON_TEXT_FONT;
    }
    return _contentLabel;
}



@end
