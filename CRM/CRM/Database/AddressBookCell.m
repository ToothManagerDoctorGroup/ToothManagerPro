//
//  AddressBookCell.m
//  CRM
//
//  Created by Argo Zhang on 15/12/11.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "AddressBookCell.h"
#import "DBManager+Patients.h"
#import "UIColor+Extension.h"


@interface AddressBookCell (){
    UIImageView *_iconView;//头像
    UILabel *_nameLabel; //姓名
    UILabel *_phoneLabel; //电话
    UIButton *_addButton; //添加按钮
}

@end

@implementation AddressBookCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"address_cell";
    AddressBookCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
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
    _iconView = [[UIImageView alloc] init];
    _iconView.layer.cornerRadius = 20;
    _iconView.layer.masksToBounds = YES;
    _iconView.layer.borderWidth = 1;
    _iconView.layer.borderColor = [UIColor colorWithHex:0xdddddd].CGColor;
    [self.contentView addSubview:_iconView];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:_nameLabel];
    
    _phoneLabel = [[UILabel alloc] init];
    _phoneLabel.textColor = [UIColor blackColor];
    _phoneLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_phoneLabel];
    
    _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addButton setTitle:@"添加" forState:UIControlStateNormal];
    [_addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_addButton setTitle:@"已添加" forState:UIControlStateDisabled];
    [_addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    _addButton.backgroundColor = MyColor(20, 152, 236);
    _addButton.layer.cornerRadius = 6;
    _addButton.layer.masksToBounds = YES;
    [_addButton addTarget:self action:@selector(addUserAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_addButton];
}

- (void)setModel:(AddressBookCellMode *)model{
    _model = model;
    
    CGFloat margin = 10;
    CGFloat imgW = 40;
    CGFloat imgH = imgW;
    
    _iconView.frame = CGRectMake(margin, 5, imgW, imgH);
    
    if (model.image) {
        _iconView.image = model.image;
    }else{
        _iconView.image = [UIImage imageNamed:@"user_icon"];
    }
    
    CGSize nameSize = [model.name sizeWithFont:[UIFont systemFontOfSize:16]];
    _nameLabel.frame = CGRectMake(_iconView.right + margin, 5, nameSize.width, nameSize.height);
    _nameLabel.text = model.name;
    
    CGSize phoneSize = [model.phone sizeWithFont:[UIFont systemFontOfSize:14]];
    _phoneLabel.frame = CGRectMake(_iconView.right + margin, _nameLabel.bottom + 5, phoneSize.width, phoneSize.height);
    _phoneLabel.text = model.phone;
    
    _addButton.frame = CGRectMake(kScreenWidth - margin - 70, 10, 70, 30);
    
    if (model.hasAdded) {
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
    if ([self.delegate respondsToSelector:@selector(addressBookCell:didclickAddButton:)]) {
        [self.delegate addressBookCell:self didclickAddButton:button];
    }
}

@end
