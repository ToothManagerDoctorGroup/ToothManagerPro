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
#import "UIImage+TTMAddtion.h"

@interface XLAppointDetailCell ()

@property (nonatomic, weak)UILabel *titleLabel;//标题
@property (nonatomic, weak)UILabel *contentLabel;//内容
@property (nonatomic, weak)UIView *lineView;//分割线
@property (nonatomic, weak)UIImageView *arrowView;//箭头

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
        self.selectionStyle = UITableViewCellSelectionStyleNone;
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
    contentLabel.textAlignment = NSTextAlignmentRight;
    self.contentLabel = contentLabel;
    [self.contentView addSubview:contentLabel];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHex:0xCCCCCC];
    self.lineView = lineView;
    [self.contentView addSubview:lineView];
    
    UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_crm"]];
    arrowView.hidden = YES;
    self.arrowView = arrowView;
    [self.contentView addSubview:arrowView];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat margin = 15;
    CGFloat rowH = 44;
    
    NSString *commonTitle = @"治疗项目";
    CGFloat commomW = [commonTitle sizeWithFont:[UIFont systemFontOfSize:15]].width;
    
    NSString *title = self.model.title;
    self.titleLabel.frame = CGRectMake(margin, 0, commomW, rowH);
    self.titleLabel.text = title;
    
    
   NSString *content = self.model.content;
    if (self.ShowAccessoryView) {
        self.arrowView.hidden = NO;
        CGFloat arrowW = 13;
        CGFloat arrowH = 18;
        CGFloat contentW = kScreenWidth - commomW - margin * 4 - arrowW;
        NSString *content = self.model.content;
        CGSize contentSize = [content sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(contentW, MAXFLOAT)];
        //有箭头
        self.arrowView.frame = CGRectMake(kScreenWidth - margin - arrowW, (rowH - arrowH) / 2, arrowW, arrowH);
        
        if (contentSize.height > rowH) {
            self.contentLabel.frame = CGRectMake(self.titleLabel.right + margin, 0, contentW, contentSize.height);
        }else{
            self.contentLabel.frame = CGRectMake(self.titleLabel.right + margin, 0, contentW, rowH);
        }
        
    }else{
        self.arrowView.hidden = YES;
        CGFloat contentW = kScreenWidth - commomW - margin * 3;
        CGSize contentSize = [content sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(contentW, MAXFLOAT)];
        
        if (contentSize.height > rowH) {
            self.contentLabel.frame = CGRectMake(self.titleLabel.right + margin, 0, contentW, contentSize.height);
        }else{
            self.contentLabel.frame = CGRectMake(self.titleLabel.right + margin, 0, contentW, rowH);
        }
    }
    self.contentLabel.text = content;
    
    self.lineView.frame = CGRectMake(0, self.height - 0.5, kScreenWidth, 0.5);
}

@end
