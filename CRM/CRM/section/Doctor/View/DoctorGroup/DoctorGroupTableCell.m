//
//  DoctorGroupTableCell.m
//  CRM
//
//  Created by Argo Zhang on 15/12/8.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "DoctorGroupTableCell.h"

#define commenFont [UIFont systemFontOfSize:16]
#define commenColor MyColor(51, 51, 51)
#define Margin 10
#define RowHeight 44
#define DividerHeight 0.5

@interface DoctorGroupTableCell (){
    UILabel *_groupName;//分组的名称
    UILabel *_groupNum; //分组的数量
    UIView *_divider;//分割线
    
}

@end

@implementation DoctorGroupTableCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"group_cell";
    DoctorGroupTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
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
    
    //分组名称
    _groupName = [[UILabel alloc] init];
    _groupName.font = commenFont;
    _groupName.textColor = commenColor;
    [self.contentView addSubview:_groupName];
    
    //分组数量
    _groupNum = [[UILabel alloc] init];
    _groupNum.font = commenFont;
    _groupNum.textColor = commenColor;
    [self.contentView addSubview:_groupNum];
    
    //分割线
    _divider = [[UIView alloc] init];
    _divider.backgroundColor = MyColor(221, 221, 221);
    [self.contentView addSubview:_divider];
}

- (void)setModel:(DoctorGroupModel *)model{

    _model = model;
    
    CGSize groupSize = [self.model.group_name sizeWithFont:commenFont];
    _groupName.frame = CGRectMake(Margin, 0, groupSize.width, RowHeight);
    _groupName.text = self.model.group_name;
    
    NSString *numStr = [NSString stringWithFormat:@"(%d)",self.model.patient_count] ;
    CGSize numSize = [numStr sizeWithFont:commenFont];
    _groupNum.frame = CGRectMake(kScreenWidth - Margin - numSize.width, 0, numSize.width, RowHeight);
    _groupNum.text = numStr;
    
    _divider.frame = CGRectMake(0, RowHeight - DividerHeight, kScreenWidth, DividerHeight);
}
@end
