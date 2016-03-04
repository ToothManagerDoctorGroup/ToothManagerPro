//
//  XLDiseaseRecordModelFrame.h
//  CRM
//
//  Created by Argo Zhang on 16/3/3.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  病程记录
 */
@class XLDiseaseRecordModel;
@interface XLDiseaseRecordModelFrame : NSObject

@property (nonatomic, strong)XLDiseaseRecordModel *model;


@property (nonatomic, assign)CGRect leftImageViewFrame;
@property (nonatomic, assign)CGRect leftLineViewFrame;
@property (nonatomic, assign)CGRect timeLabelFrame;

/**
 *  包含子视图
 */
@property (nonatomic, assign)CGRect diseaseRecordDetailFrame;
@property (nonatomic, assign)CGRect typeLabelFrame;
@property (nonatomic, assign)CGRect diseaseRecordImageViewFrame;
@property (nonatomic, assign)CGRect arrowViewFrame;

//cell的高度
@property (nonatomic, assign)CGFloat cellHeight;

@end
