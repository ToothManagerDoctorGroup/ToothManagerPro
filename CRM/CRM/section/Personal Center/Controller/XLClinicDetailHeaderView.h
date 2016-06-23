//
//  XLClinicDetailHeaderView.h
//  CRM
//
//  Created by Argo Zhang on 16/5/24.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  诊所详情头视图
 */
@interface XLClinicDetailHeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *businessTime;//营业时间
@property (weak, nonatomic) IBOutlet UILabel *clinicPhone;//诊所电话
@property (weak, nonatomic) IBOutlet UILabel *clinicAddress;//诊所地址


@end
