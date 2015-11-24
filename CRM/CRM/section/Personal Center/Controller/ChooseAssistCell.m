//
//  ChooseAssistCell.m
//  CRM
//
//  Created by Argo Zhang on 15/11/24.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "ChooseAssistCell.h"
#import "AssistCountModel.h"
#import "MaterialCountModel.h"

#define CommenTitleColor [UIColor blackColor]
#define CommenTitleFont [UIFont systemFontOfSize:12]

@interface ChooseAssistCell (){
    UILabel *_assistNameLabel; //名称
    UILabel *_priceLabel; //价格
    UIButton *_addButton; //加号
    UIButton *_reduceButton; //减号
    UILabel *_totalNumLabel; //总数量
}

@property (nonatomic, assign)NSInteger currentNum;

@end

@implementation ChooseAssistCell

+ (instancetype)assistCellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"choose_assist_cell";
    ChooseAssistCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //初始化
        [self setUp];
    }
    return self;
}

#pragma mark -初始化
- (void)setUp{
    _assistNameLabel = [[UILabel alloc] init];
    _assistNameLabel.textColor = CommenTitleColor;
    _assistNameLabel.font = CommenTitleFont;
    [self.contentView addSubview:_assistNameLabel];
    
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.textColor = CommenTitleColor;
    _priceLabel.font = CommenTitleFont;
    [self.contentView addSubview:_priceLabel];
    
    _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _addButton.tag = 110;
    [_addButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_addButton setBackgroundImage:[UIImage imageNamed:@"num_add"] forState:UIControlStateNormal];
    [_addButton addTarget:self action:@selector(addNumAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_addButton];
    
    _reduceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_reduceButton setBackgroundImage:[UIImage imageNamed:@"num_reduce"] forState:UIControlStateNormal];
    _reduceButton.tag = 100;
    [_reduceButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_reduceButton addTarget:self action:@selector(reduceNumAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_reduceButton];
    
    _totalNumLabel = [[UILabel alloc] init];
    _totalNumLabel.textColor = CommenTitleColor;
    _totalNumLabel.layer.cornerRadius = 5;
    _totalNumLabel.layer.masksToBounds = YES;
    _totalNumLabel.textAlignment = NSTextAlignmentCenter;
    _totalNumLabel.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _totalNumLabel.layer.borderWidth = .8;
    _totalNumLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_totalNumLabel];
    
    self.currentNum = [_totalNumLabel.text integerValue];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    
    CGFloat Margin = 10;
    CGFloat buttonW = 20;
    CGFloat buttonH = buttonW;
    NSString *name;
    if (self.assistModel) {
        name = self.assistModel.assist_name;
    }else{
        name = self.materialModel.mat_name;
    }
    CGSize nameSize = [name sizeWithFont:CommenTitleFont];
    _assistNameLabel.frame = CGRectMake(Margin, 0, nameSize.width, 40);
    _assistNameLabel.text = name;
    
    //加号按钮
    _addButton.frame = CGRectMake(kScreenWidth - buttonW - Margin, 10, buttonW, buttonH);
    //总个数
    _totalNumLabel.frame = CGRectMake(_addButton.left - 6 - 30, 7, 30, 26);
    
    if (self.assistModel) {
        _totalNumLabel.text = [NSString stringWithFormat:@"%ld",(long)self.assistModel.num];
    }else{
        _totalNumLabel.text = [NSString stringWithFormat:@"%ld",(long)self.materialModel.num];
    }
    
    //减号按钮
    _reduceButton.frame = CGRectMake(_totalNumLabel.left - 6 - buttonW, 10, buttonW, buttonH);
    
    //价格
    NSString *price;
    if (self.assistModel) {
        price = [NSString stringWithFormat:@"￥%@元",self.assistModel.assist_price];
    }else{
        price = [NSString stringWithFormat:@"￥%@元",self.materialModel.mat_price];
    }
    CGSize priceSize = [price sizeWithFont:CommenTitleFont];
    _priceLabel.frame = CGRectMake(_reduceButton.left - Margin - priceSize.width, 0, priceSize.width, 40);
    _priceLabel.text = price;
}

#pragma mark -加总数
- (void)addNumAction:(UIButton *)btn{
    //获取当前文本框的值
    if ([self.delegate respondsToSelector:@selector(btnClick:andFlag:)]) {
        [self.delegate btnClick:self andFlag:(int)btn.tag];
    }
}

- (void)reduceNumAction:(UIButton *)btn{
    
    if ([self.delegate respondsToSelector:@selector(btnClick:andFlag:)]) {
        [self.delegate btnClick:self andFlag:(int)btn.tag];
    }
}

@end
