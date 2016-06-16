//
//  XLMaterialsViewController.h
//  CRM
//
//  Created by Argo Zhang on 15/12/26.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "TimViewController.h"
#import "TimFramework.h"

@class Material;
typedef NS_ENUM(NSInteger, XLMaterialViewMode) {
    XLMaterialViewModeNormal =1 ,
    XLMaterialViewModeSelect = 2,
};
@protocol XLMaterialsViewControllerDelegate;

@interface XLMaterialsViewController : TimViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSArray * dataArray;
}

@property (nonatomic,readwrite) XLMaterialViewMode mode;
@property (nonatomic,assign) id <XLMaterialsViewControllerDelegate> delegate;

@end
@protocol XLMaterialsViewControllerDelegate <NSObject>

- (void)didSelectedMaterial:(Material *)material;

@end