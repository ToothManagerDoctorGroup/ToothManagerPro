//
//  XLCommonDoctorCell.m
//  CRM
//
//  Created by Argo Zhang on 16/3/18.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLCommonDoctorCell.h"
#import "UIView+SDAutoLayout.h"
#import "XLAvatarView.h"

@interface XLCommonDoctorCell (){
    XLAvatarView *_iconImageView; //头像
    UILabel *_nameLabel; //名称
    UILabel *_contentLabel;//内容
    UIButton *_addButton;//添加按钮
}

@end

@implementation XLCommonDoctorCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"common_doctor_cell";
    XLCommonDoctorCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUp];
    }
    return self;
}
#pragma mark - 初始化
- (void)setUp{
    _iconImageView = [[XLAvatarView alloc] init];
    [self.contentView addSubview:_iconImageView];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont systemFontOfSize:17];
    _nameLabel.textColor = MyColor(15, 166, 255);
    [self.contentView addSubview:_nameLabel];
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.font = [UIFont systemFontOfSize:14];
    _contentLabel.textColor = MyColor(15, 166, 255);
    [self.contentView addSubview:_contentLabel];
    
    _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
}


@end
