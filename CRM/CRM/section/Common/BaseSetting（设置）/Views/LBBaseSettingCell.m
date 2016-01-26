//
//  LBBaseSettingCell.m
//  LBWeiBo
//
//  Created by apple on 15/10/5.
//  Copyright (c) 2015年 徐晓龙. All rights reserved.
//

#import "LBBaseSettingCell.h"
#import "LBBaseSetting.h"
#import "LBBadgeView.h"

@interface LBBaseSettingCell ()

@property (nonatomic, strong)UISwitch *switchView;
@property (nonatomic, strong)UIImageView *arrowView;
@property (nonatomic, strong)UIImageView *checkView;
@property (nonatomic, strong)LBBadgeView *badgeView;
@property (nonatomic, strong)UILabel *labelView;

@end

@implementation LBBaseSettingCell

#pragma mark - 懒加载
- (UISwitch *)switchView{
    if (!_switchView) {
        _switchView = [[UISwitch alloc] init];
    }
    return _switchView;
}
- (UIImageView *)arrowView{
    if (!_arrowView) {
        _arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_crm"]];
    }
    return _arrowView;
}
- (UIImageView *)checkView{
    if (!_checkView) {
        _checkView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_icon_checkmark"]];
    }
    return _checkView;
}
- (LBBadgeView *)badgeView{
    if (!_badgeView) {
        _badgeView = [LBBadgeView buttonWithType:UIButtonTypeCustom];
    }
    return _badgeView;
}
- (UILabel *)labelView{
    if (!_labelView) {
        _labelView = [[UILabel alloc] init];
        
        _labelView.font = [UIFont systemFontOfSize:16];
        _labelView.textAlignment = NSTextAlignmentCenter;
        _labelView.textColor = [UIColor redColor];
        
    }
    return _labelView;
}

#pragma mark - 类方法创建cell
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"cell";
    LBBaseSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}

#pragma mark - 对控件进行赋值
- (void)setItem:(LBSettingItem *)item{
    _item = item;
    
    //设置数据
    [self setUpData];
    //设置右侧视图
    [self setUpRightView];
}
//设置数据
- (void)setUpData{
    self.imageView.image = _item.image;
    self.textLabel.text = _item.title;
    self.detailTextLabel.text = _item.subTitle;
    
    if ([_item isKindOfClass:[LBLabelItem class]]) {
        LBLabelItem *item = (LBLabelItem *)_item;
        [self addSubview:self.labelView];
        self.labelView.text = item.text;
    }else{
        [self.labelView removeFromSuperview];
    }
}
//设置右侧视图
- (void)setUpRightView{
    //判断视图类型
    if ([_item isKindOfClass:[LBArrowItem class]]) {//箭头
        self.accessoryView = self.arrowView;
    }else if ([_item isKindOfClass:[LBSwitchItem class]]){//开关
        self.accessoryView = self.switchView;
    }else if ([_item isKindOfClass:[LBCheckItem class]]){ //打钩
        LBCheckItem *item = (LBCheckItem *)_item;
        if (item.isCheck == YES) {
            self.accessoryView = self.checkView;
        }else{
            self.accessoryView = nil;
        }
    }else if ([_item isKindOfClass:[LBBadgeItem class]]){ //badgeView
        LBBadgeItem *item = (LBBadgeItem *)_item;
        self.accessoryView = self.badgeView;
        self.badgeView.badgeValue = item.badgeValue;
    }else{
        self.accessoryView = nil;
    }
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.labelView.frame = self.bounds;
}
@end
