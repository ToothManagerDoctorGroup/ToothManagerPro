//
//  PatientDetailHeadInfoView.h
//  CRM
//
//  Created by Argo Zhang on 15/11/20.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBTableMode.h"
/**
 *  患者详情页头视图上的详情数据
 */
@interface PatientDetailHeadInfoView : UIView


@property (nonatomic,retain)Patient *detailPatient;
@property (nonatomic, copy)NSString *introducerName;
@property (nonatomic, copy)NSString *transferStr;

- (CGFloat)getTotalHeight;

@end
