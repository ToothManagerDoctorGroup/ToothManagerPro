//
//  XLContactCell.m
//  CRM
//
//  Created by Argo Zhang on 16/3/15.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLContactCell.h"
#import "UIView+SDAutoLayout.h"
#import "XLContactModel.h"
#import "XLContactsManager.h"

@interface XLContactCell (){
    UIImageView *_iconImageView;
    UILabel *_nameLabel;
    UIButton *_addButton;
}

@end

@implementation XLContactCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"contact_cell";
    XLContactCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 这行代是为了解决tableview开启了字母序列索引之后cell会向左缩进一段距离的问题
        self.contentView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
        
        [self setupView];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    frame.size.width = [UIScreen mainScreen].bounds.size.width;
    [super setFrame:frame];
}


- (void)setupView
{
    _iconImageView = [UIImageView new];
    _iconImageView.image = [UIImage imageNamed:@"user_icon"];
    [self.contentView addSubview:_iconImageView];
    
    _nameLabel = [UILabel new];
    _nameLabel.textColor = [UIColor darkGrayColor];
    _nameLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_nameLabel];
    
    _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addButton setTitle:@"添加" forState:UIControlStateNormal];
    _addButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_addButton setTitle:@"已添加" forState:UIControlStateDisabled];
    [_addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    _addButton.backgroundColor = MyColor(20, 152, 236);
    _addButton.layer.cornerRadius = 3;
    _addButton.layer.masksToBounds = YES;
    [self.contentView addSubview:_addButton];
    [_addButton addTarget:self action:@selector(addUserAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    CGFloat margin = 8;
    
    _iconImageView.sd_layout
    .leftSpaceToView(self.contentView, margin)
    .widthIs(35)
    .heightEqualToWidth()
    .centerYEqualToView(self.contentView);
    
    _nameLabel.sd_layout
    .leftSpaceToView(_iconImageView, margin)
    .centerYEqualToView(_iconImageView)
    .rightSpaceToView(self.contentView, margin)
    .heightIs(30);
    
    _addButton.sd_layout
    .rightSpaceToView(self.contentView,margin * 2)
    .widthIs(50)
    .heightIs(25)
    .centerYEqualToView(self.contentView);
}

- (void)setContact:(XLContact *)contact{
    _contact = contact;
    
//    _iconImageView.image = contact.image;
    _nameLabel.text = contact.fullName;
    
    if (contact.hasAdd) {
        _addButton.enabled = NO;
        _addButton.backgroundColor = [UIColor grayColor];
    }else{
        _addButton.enabled = YES;
        _addButton.backgroundColor = MyColor(20, 152, 236);
    }
}


- (void)addUserAction:(UIButton *)button{
    button.enabled = NO;
    _addButton.backgroundColor = [UIColor grayColor];
    if ([self.delegate respondsToSelector:@selector(ContactCell:didclickAddButton:)]) {
        [self.delegate ContactCell:self didclickAddButton:button];
    }
}

+ (CGFloat)fixedHeight
{
    return 50;
}


@end
