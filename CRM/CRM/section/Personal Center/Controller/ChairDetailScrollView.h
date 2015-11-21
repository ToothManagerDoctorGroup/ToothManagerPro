//
//  ChairDetailScrollView.h
//  CRM
//
//  Created by Argo Zhang on 15/11/12.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChairDetailScrollView;
@protocol ChairDetailScrollViewDelegate <NSObject>

@optional
- (void)chairDetailScrollView:(ChairDetailScrollView *)scrollView didSelectedIndex:(NSUInteger)index;

@end

@interface ChairDetailScrollView : UIScrollView

//数组，存放椅位基本信息模型:SeatModel
@property (nonatomic, strong)NSArray *dataList;

@property (nonatomic, weak)id<ChairDetailScrollViewDelegate> chairDelegate;

@end
