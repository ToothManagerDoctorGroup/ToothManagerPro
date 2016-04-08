
//
//  XLFilterCell.m
//  CRM
//
//  Created by Argo Zhang on 16/3/31.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLFilterCell.h"
#import "UIColor+Extension.h"


#define LeftButtonWidth 90
#define LeftButtonHeight 50
#define LeftButtonColorNormal [UIColor colorWithHex:0xeeeeee]
#define LeftButtonColorSelect [UIColor colorWithHex:0xffffff]
#define LeftButtonTitleColorSelect [UIColor colorWithHex:0x00a0ea]
#define LeftButtonTitleColorNormal [UIColor colorWithHex:0x888888]
#define LeftButtonTitleFont [UIFont systemFontOfSize:14]

@interface XLFilterCell ()

@end

@implementation XLFilterCell

- (UILabel *)buttonTitleLabel{
    if (!_buttonTitleLabel) {
        _buttonTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, LeftButtonWidth, LeftButtonHeight)];
        _buttonTitleLabel.textColor = LeftButtonTitleColorNormal;
        _buttonTitleLabel.font = LeftButtonTitleFont;
        _buttonTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _buttonTitleLabel;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"filter_cell";
    XLFilterCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = LeftButtonColorNormal;
        [self.contentView addSubview:self.buttonTitleLabel];
        
        UIView *selectView = [[UIView alloc] initWithFrame:self.frame];
        self.selectedBackgroundView = selectView;
        selectView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    
    self.buttonTitleLabel.text = title;
}

@end
