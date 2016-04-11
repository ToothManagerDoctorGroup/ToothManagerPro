//
//  XLEditGroupCell.m
//  CRM
//
//  Created by Argo Zhang on 16/3/25.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLEditGroupCell.h"
#import "UIView+SDAutoLayout.h"
#import "DoctorGroupModel.h"
#import "UIColor+Extension.h"

#define TitleFont [UIFont systemFontOfSize:15]
#define TitleColor [UIColor colorWithHex:0x333333]
@interface XLEditGroupCell (){
    UILabel *_titleLabel;
    UIButton *_selectButton;
}

@end
@implementation XLEditGroupCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"editgroup_cell";
    XLEditGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //初始化
        [self  setUp];
    }
    return  self;
}
#pragma mark - 初始化
- (void)setUp{
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = TitleFont;
    _titleLabel.textColor = TitleColor;
    [self.contentView addSubview:_titleLabel];
    
    _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_selectButton setImage:[UIImage imageNamed:@"no-choose"] forState:UIControlStateNormal];
    [_selectButton setImage:[UIImage imageNamed:@"choose-blue"] forState:UIControlStateSelected];
    [_selectButton addTarget:self action:@selector(selectAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_selectButton];
    
    CGFloat margin = 15;
    
    _selectButton.sd_layout
    .widthIs(56)
    .heightIs(50)
    .topSpaceToView(self.contentView,0)
    .rightSpaceToView(self.contentView,0);
    
    _titleLabel.sd_layout
    .heightIs(50)
    .leftSpaceToView(self.contentView,margin)
    .topSpaceToView(self.contentView,0)
    .rightSpaceToView(_selectButton,20);
}

- (void)setModel:(DoctorGroupModel *)model{
    _model = model;
    
    _titleLabel.text = [NSString stringWithFormat:@"%@(%d)",model.group_name,model.patient_count];
    _selectButton.selected = model.isSelect;
}

+ (NSInteger)fixHeight{
    return 50.0f;
}

- (void)selectAction{
    //选中
    _selectButton.selected = !_selectButton.isSelected;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(editGroupCell:didSelect:)]) {
        [self.delegate editGroupCell:self didSelect:_selectButton.isSelected];
    }
}

- (void)selectOption{
    [self selectAction];
}


@end
