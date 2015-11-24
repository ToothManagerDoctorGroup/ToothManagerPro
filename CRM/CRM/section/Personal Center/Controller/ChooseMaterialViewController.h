//
//  ChooseMaterialViewController.h
//  CRM
//
//  Created by Argo Zhang on 15/11/24.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "TimViewController.h"

@class ChooseMaterialViewController;
@protocol ChooseMaterialViewControllerDelegate <NSObject>

@optional
- (void)chooseMaterialViewController:(ChooseMaterialViewController *)mController didSelectMaterials:(NSArray *)materials;

@end

@interface ChooseMaterialViewController : TimViewController

@property (nonatomic, copy)NSString *clinicId;

@property (nonatomic, strong)NSArray *chooseMaterials; //选择的耗材数组

@property (nonatomic, weak)id<ChooseMaterialViewControllerDelegate> delegate;

@end
