//
//  XLDiseaseRecordDetailView.m
//  CRM
//
//  Created by Argo Zhang on 16/3/3.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLDiseaseRecordDetailView.h"
#import "UIColor+Extension.h"
#import "XLDiseaseRecordImageView.h"
#import "XLDiseaseRecordModelFrame.h"
#import "XLDiseaseRecordModel.h"

#define TypeFont [UIFont systemFontOfSize:15]
#define TypeColor [UIColor colorWithHex:0x333333]
@interface XLDiseaseRecordDetailView ()

@property (nonatomic, weak)UILabel *typeLabel;//类型
@property (nonatomic, weak)UIImageView *arrowView;//箭头
@property (nonatomic, weak)XLDiseaseRecordImageView *imageViews;//图片视图


@end

@implementation XLDiseaseRecordDetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        self.layer.borderColor = [UIColor colorWithHex:0xCCCCCC].CGColor;
        self.layer.borderWidth = 1;
        self.backgroundColor = [UIColor whiteColor];
        [self setUp];
    }
    return self;
}
#pragma mark - 初始化
- (void)setUp{
    //类型
    UILabel *typeLabel = [[UILabel alloc] init];
    typeLabel.font = TypeFont;
    typeLabel.textColor = TypeColor;
    self.typeLabel = typeLabel;
    [self addSubview:typeLabel];
    
    //箭头
    UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_crm"]];
    self.arrowView = arrowView;
    [self addSubview:arrowView];
    
    //图片视图
    XLDiseaseRecordImageView *imageViews = [[XLDiseaseRecordImageView alloc] init];
    self.imageViews = imageViews;
    [self addSubview:imageViews];
}

- (void)setModelFrame:(XLDiseaseRecordModelFrame *)modelFrame{
    _modelFrame = modelFrame;
    
    XLDiseaseRecordModel *model = modelFrame.model;
    
    self.typeLabel.frame = modelFrame.typeLabelFrame;
    self.typeLabel.text = model.type;
    self.arrowView.frame = modelFrame.arrowViewFrame;
    
    self.imageViews.frame = modelFrame.diseaseRecordImageViewFrame;
    self.imageViews.images = modelFrame.model.images;
}

@end
