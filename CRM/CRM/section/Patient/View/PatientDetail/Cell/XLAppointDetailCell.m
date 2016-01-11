//
//  XLAppointDetailCell.m
//  CRM
//
//  Created by Argo Zhang on 16/1/4.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLAppointDetailCell.h"
#import "UIColor+Extension.h"
#import "XLAppointDetailModel.h"

@interface XLAppointDetailCell ()

@property (nonatomic, weak)UILabel *titleLabel;//标题
@property (nonatomic, weak)UILabel *contentLabel;//内容
@property (nonatomic, weak)UIView *lineView;//分割线

@end

@implementation XLAppointDetailCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"detail_cell";
    XLAppointDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
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

- (void)setUp{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor colorWithHex:0x888888];
    titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel = titleLabel;
    [self.contentView addSubview:titleLabel];
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.textColor = [UIColor colorWithHex:0x333333];
    contentLabel.font = [UIFont systemFontOfSize:15];
    contentLabel.numberOfLines = 0;
    self.contentLabel = contentLabel;
    [self.contentView addSubview:contentLabel];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = MyColor(238, 238, 238);
    self.lineView = lineView;
    [self.contentView addSubview:lineView];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat margin = 10;
    CGFloat rowH = 40;
    
    NSString *commonTitle = @"治疗项目";
    CGFloat commomW = [commonTitle sizeWithFont:[UIFont systemFontOfSize:15]].width;
    
    NSString *title = self.model.title;
    self.titleLabel.frame = CGRectMake(margin, 0, commomW, rowH);
    self.titleLabel.text = title;
    
    
    CGFloat contentW = kScreenWidth - commomW - margin * 3;
    NSString *content = self.model.content;
    CGSize contentSize = [content sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(contentW, MAXFLOAT)];
    if (contentSize.height > rowH) {
        self.contentLabel.frame = CGRectMake(self.titleLabel.right + margin, 0, contentW, contentSize.height);
    }else{
        self.contentLabel.frame = CGRectMake(self.titleLabel.right + margin, 0, contentW, rowH);
    }
    
    self.contentLabel.text = content;
    
    self.lineView.frame = CGRectMake(0, self.height - 1, kScreenWidth, 1);
}

@end
