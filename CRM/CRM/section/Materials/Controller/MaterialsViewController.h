//
//  MaterialsViewController.h
//  CRM
//
//  Created by mac on 14-5-12.
//  Copyright (c) 2014年 TimTiger. All rights reserved.
//

#import "TimFramework.h"
#import "TimViewController.h"

@class Material;
typedef NS_ENUM(NSInteger, MaterialViewMode) {
    MaterialViewModeNormal =1 ,
    MaterialViewModeSelect = 2,
};

@protocol MaterialsViewControllerDelegate;

@interface MaterialsViewController : TimDisplayViewController <UITableViewDataSource,UITableViewDelegate>
{
    NSArray * dataArray;
}

@property (nonatomic,readwrite) MaterialViewMode mode;
@property (nonatomic,assign) id <MaterialsViewControllerDelegate> delegate;

@end

@protocol MaterialsViewControllerDelegate <NSObject>

- (void)didSelectedMaterial:(Material *)material;

@end
