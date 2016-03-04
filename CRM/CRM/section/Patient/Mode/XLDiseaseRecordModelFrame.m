//
//  XLDiseaseRecordModelFrame.m
//  CRM
//
//  Created by Argo Zhang on 16/3/3.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLDiseaseRecordModelFrame.h"
#import "NSString+TTMAddtion.h"
#import "XLDiseaseRecordModel.h"

#define CommonFont [UIFont systemFontOfSize:15]
#define Margin 10
#define ImageWidth 60
#define ImageHeight 60
#define ArrowWidth 13
#define ArrowHeight 18

@implementation XLDiseaseRecordModelFrame

- (void)setModel:(XLDiseaseRecordModel *)model{
    _model = model;
    
    //计算frame
    CGFloat imageW = 10;
    CGFloat imageH = imageW;
    self.leftImageViewFrame = CGRectMake(Margin, Margin * 2 + 4, imageW, imageH);
    
    CGSize timeSize = [model.time measureFrameWithFont:CommonFont size:CGSizeMake(MAXFLOAT, MAXFLOAT)].size;
    self.timeLabelFrame = CGRectMake(CGRectGetMaxX(_leftImageViewFrame) + Margin, Margin * 2, timeSize.width, timeSize.height);
    
    //计算详情视图frame
    [self setUpDetailViewFrame];
}

- (void)setUpDetailViewFrame{
    CGSize typeSize = [self.model.type measureFrameWithFont:CommonFont size:CGSizeMake(MAXFLOAT, MAXFLOAT)].size;
    CGFloat detailW = kScreenWidth - Margin * 4;
    CGFloat detailH = 50;
    CGFloat detailX = Margin * 3;
    CGFloat detailY = CGRectGetMaxY(_timeLabelFrame) + Margin;
    
    CGFloat typeW = typeSize.width;
    CGFloat typeH = typeSize.height;
    CGFloat typeX = Margin;
    CGFloat typeY = (detailH - typeSize.height) / 2;
    
    CGFloat arrowX = detailW - ArrowWidth - Margin;
    CGFloat arrowY = (detailH - ArrowHeight) / 2;
    
    if (self.model.images.count > 0) {
        typeY = Margin;
        self.typeLabelFrame = CGRectMake(typeX, typeY, typeW,typeH);
        
        //获取一行最大宽度
        CGFloat maxW = detailW - Margin * 2 - ArrowWidth;
        //获取一行最多显示几张图片
        NSInteger count = maxW / (ImageWidth + Margin);
        //计算总共显示几行
        NSInteger rows = self.model.images.count % count == 0 ? self.model.images.count / count : self.model.images.count / count + 1;
        
        //计算图片视图的frame
        CGFloat imagesViewX = 0;
        CGFloat imagesViewY = CGRectGetMaxY(_typeLabelFrame);
        CGFloat imagesViewW = detailW - ArrowWidth - Margin * 2;
        CGFloat imagesViewH = rows * (ImageWidth + Margin);
        self.diseaseRecordImageViewFrame = CGRectMake(imagesViewX, imagesViewY, imagesViewW, imagesViewH);
        
        detailH = CGRectGetMaxY(_diseaseRecordImageViewFrame) + Margin;
        self.diseaseRecordDetailFrame = CGRectMake(detailX, detailY, detailW, detailH);
        
        arrowY = (detailH - ArrowHeight) / 2;
        self.arrowViewFrame = CGRectMake(arrowX, arrowY, ArrowWidth, ArrowHeight);
        
    }else{
        
        self.diseaseRecordDetailFrame = CGRectMake(detailX, detailY, detailW, detailH);
        self.typeLabelFrame = CGRectMake(typeX, typeY, typeW, typeH);
        self.arrowViewFrame = CGRectMake(arrowX,arrowY, ArrowWidth, ArrowHeight);
    }
    
    self.cellHeight = CGRectGetMaxY(_diseaseRecordDetailFrame);
    
    self.leftLineViewFrame = CGRectMake(10 + 5 - 1, 0, 2, self.cellHeight);
}

@end
