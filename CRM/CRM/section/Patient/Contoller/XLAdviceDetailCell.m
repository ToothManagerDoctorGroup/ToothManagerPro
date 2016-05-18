//
//  XLAdviceDetailCell.m
//  CRM
//
//  Created by Argo Zhang on 16/4/26.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLAdviceDetailCell.h"
#import "UIColor+Extension.h"
#import "UIView+SDAutoLayout.h"
#import "XLAdviceDetailModel.h"

#define CONTENT_TITLE_FONT [UIFont systemFontOfSize:15]
#define CONTENT_TITLE_COLOR [UIColor colorWithHex:0x333333]
#define MARGIN_X 15
#define MARGIN_Y 10

@interface XLAdviceDetailCell ()
@property (nonatomic, weak)UILabel *contentLabel;
@end

@implementation XLAdviceDetailCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"advice_detail_cell";
    XLAdviceDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //初始化子视图
        [self setUpViews];
    }
    return self;
}
#pragma mark - 初始化子视图
- (void)setUpViews{
    self.backgroundColor = [UIColor whiteColor];
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.textColor = CONTENT_TITLE_COLOR;
    contentLabel.font = CONTENT_TITLE_FONT;
    contentLabel.numberOfLines = 0;
    self.contentLabel = contentLabel;
    [self.contentView addSubview:contentLabel];
    
    contentLabel.sd_layout
    .leftSpaceToView(self.contentView,MARGIN_X)
    .rightSpaceToView(self.contentView,MARGIN_X)
    .topSpaceToView(self.contentView,MARGIN_Y)
    .autoHeightRatio(0);
}


- (void)setModel:(XLAdviceDetailModel *)model{
    _model = model;

    
    self.contentLabel.text = model.a_content;
    
    [self setupAutoHeightWithBottomView:self.contentLabel bottomMargin:MARGIN_Y];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (CGFloat)contentMaxWidth{
    return kScreenWidth - MARGIN_X * 2;
}

@end
