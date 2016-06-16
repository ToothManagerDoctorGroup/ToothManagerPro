//
//  XLMenuGrideView.h
//  CRM
//
//  Created by Argo Zhang on 16/5/31.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XLMenuGrideView;
@protocol XLMenuGrideViewDelegate <NSObject>
@optional
- (void)homeGrideView:(XLMenuGrideView *)gridView selectItemAtIndex:(NSInteger)index;
- (void)homeGrideViewmoreItemButtonClicked:(XLMenuGrideView *)gridView;
- (void)homeGrideViewDidChangeItems:(XLMenuGrideView *)gridView;

@end

@interface XLMenuGrideView : UIScrollView

@property (nonatomic, weak)id<XLMenuGrideViewDelegate> gridViewDelegate;
@property (nonatomic, strong)NSArray *gridModels;//itemModel数组

@end
