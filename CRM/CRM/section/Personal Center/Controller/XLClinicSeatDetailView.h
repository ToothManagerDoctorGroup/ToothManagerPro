//
//  XLClinicSeatDetailView.h
//  CRM
//
//  Created by Argo Zhang on 16/5/24.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLClinicSeatDetailView : UIView
@property (weak, nonatomic) IBOutlet UILabel *brandLabel;//品牌
@property (weak, nonatomic) IBOutlet UILabel *modelTypeLabel;//型号
@property (weak, nonatomic) IBOutlet UILabel *waterLabel;//用水
@property (weak, nonatomic) IBOutlet UILabel *powerLabel;//功率
@property (weak, nonatomic) IBOutlet UILabel *lightLabel;//光固灯
@property (weak, nonatomic) IBOutlet UILabel *seatPriceLabel;//椅位价格
@property (weak, nonatomic) IBOutlet UILabel *assistPriceLabel;//助手价格


@end
