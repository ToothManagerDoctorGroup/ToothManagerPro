//
//  XLPatientDetailHeaderView.h
//  CRM
//
//  Created by Argo Zhang on 16/3/1.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBTableMode.h"
/**
 *  患者详情父视图
 */
@interface XLPatientDetailHeaderView : UIView

@property (nonatomic,retain)Patient *detailPatient;//患者模型
@property (nonatomic, copy)NSString *transferStr;
@property (nonatomic, assign)BOOL isWeixin;//是否绑定微信

- (CGFloat)getTotalHeight;


@end
