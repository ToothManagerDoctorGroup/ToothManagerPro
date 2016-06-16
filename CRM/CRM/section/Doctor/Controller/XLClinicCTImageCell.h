//
//  XLClinicCTImageCell.h
//  CRM
//
//  Created by Argo Zhang on 16/5/23.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XLClinicCTImageCellModel;
@interface XLClinicCTImageCell : UICollectionViewCell

@property (nonatomic, strong)XLClinicCTImageCellModel *model;

@end


@interface XLClinicCTImageCellModel : NSObject

@property (nonatomic, copy)NSString *urlStr;//图片地址
@property (nonatomic, assign,getter=isSelect)BOOL select;//是否被选中

@end