//
//  XLMaterialExpenseCell.m
//  CRM
//
//  Created by Argo Zhang on 16/3/4.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLMaterialExpenseCell.h"
#import "UIColor+Extension.h"
#import "DBTableMode.h"

#define CommonFont [UIFont systemFontOfSize:15]
#define CommonColor [UIColor colorWithHex:0x333333]
@interface XLMaterialExpenseCell ()

@property (nonatomic, weak)UILabel *nameLabel;
@property (nonatomic, weak)UILabel *numLabel;

@end

@implementation XLMaterialExpenseCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"material_expense_cell";
    XLMaterialExpenseCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
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
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = CommonFont;
    nameLabel.textColor = CommonColor;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel = nameLabel;
    [self.contentView addSubview:nameLabel];
    
    UILabel *numLabel = [[UILabel alloc] init];
    numLabel.font = CommonFont;
    numLabel.textColor = CommonColor;
    numLabel.textAlignment = NSTextAlignmentCenter;
    self.numLabel = numLabel;
    [self.contentView addSubview:numLabel];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat commonW = kScreenWidth / 2;
    
    self.nameLabel.frame = CGRectMake(0, 0, commonW, self.height);
    self.numLabel.frame = CGRectMake(self.nameLabel.right, 0, commonW, self.height);
}

- (void)setExpense:(MedicalExpense *)expense{
    _expense = expense;
    
    self.nameLabel.text = expense.mat_name;
    self.numLabel.text = [NSString stringWithFormat:@"%ld",(long)expense.expense_num];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
