//
//  ChairDetailView.h
//  CRM
//
//  Created by Argo Zhang on 15/11/11.
//  Copyright © 2015年 TimTiger. All rights reserved.
//  椅位详细信息的视图

#import <UIKit/UIKit.h>

@class SeatModel;
@interface ChairDetailView : UIView

//椅位信息模型
@property (nonatomic, strong)SeatModel *model;

+ (instancetype)instanceView;

@end
