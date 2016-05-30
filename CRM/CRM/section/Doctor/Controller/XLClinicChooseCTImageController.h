//
//  XLClinicChooseCTImageController.h
//  CRM
//
//  Created by Argo Zhang on 16/5/23.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "TimViewController.h"
/**
 *  选择CT图片
 */
@class XLClinicChooseCTImageController;
@protocol XLClinicChooseCTImageControllerDelegate <NSObject>

@optional
- (void)clinicChooseCTImageController:(XLClinicChooseCTImageController *)chooseCTVc didSelectImages:(NSArray *)images;

@end

@interface XLClinicChooseCTImageController : TimViewController

@property (nonatomic, weak)id<XLClinicChooseCTImageControllerDelegate> delegate;

@property (nonatomic, copy)NSString *patientId;

@property (nonatomic, strong)NSArray *selectImages;

@end
