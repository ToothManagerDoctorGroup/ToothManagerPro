//
//  XLDiseaseRecordCell.m
//  CRM
//
//  Created by Argo Zhang on 16/3/3.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLDiseaseRecordCell.h"
#import "XLDiseaseRecordModel.h"
#import "XLDiseaseRecordDetailView.h"
#import "UIColor+Extension.h"
#import "XLDiseaseRecordModelFrame.h"

#define TimeFont [UIFont systemFontOfSize:15]
#define TimeColor [UIColor colorWithHex:0x888888]
@interface XLDiseaseRecordCell ()
/**
 *  左侧标识视图
 */
@property (nonatomic, weak)UIImageView *leftImageView;
@property (nonatomic, weak)UIView *leftLineView;

@property (nonatomic, weak)UILabel *timeLabel;//时间视图

@property (nonatomic, weak)XLDiseaseRecordDetailView *detailView;//病程详情视图

@end

@implementation XLDiseaseRecordCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"disease_cell";
    XLDiseaseRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.backgroundView = nil;
        [self setUp];
    }
    return self;
}

#pragma mark - 初始化
- (void)setUp{
    UIView *leftLineView = [[UIView alloc] init];
    leftLineView.backgroundColor = [UIColor colorWithHex:0x59c0f2];
    self.leftLineView = leftLineView;
    [self.contentView addSubview:leftLineView];
    
    UIImageView *leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"team_yuandian"]];
    self.leftImageView = leftImageView;
    [self.contentView addSubview:leftImageView];
    
    //时间视图
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = TimeFont;
    timeLabel.textColor = TimeColor;
    self.timeLabel = timeLabel;
    [self.contentView addSubview:timeLabel];
    
    //病程详情视图
    XLDiseaseRecordDetailView *detailView = [[XLDiseaseRecordDetailView alloc] init];
    self.detailView = detailView;
    [self.contentView addSubview:detailView];
}


- (void)setModelFrame:(XLDiseaseRecordModelFrame *)modelFrame{
    _modelFrame = modelFrame;
    
    XLDiseaseRecordModel *model = modelFrame.model;
    
    self.leftImageView.frame = modelFrame.leftImageViewFrame;
    self.leftLineView.frame = modelFrame.leftLineViewFrame;
    self.timeLabel.frame = modelFrame.timeLabelFrame;
    self.timeLabel.text = model.time;
    
    self.detailView.frame = modelFrame.diseaseRecordDetailFrame;
    self.detailView.modelFrame = modelFrame;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
