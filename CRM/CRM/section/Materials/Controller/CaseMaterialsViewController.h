//
//  CaseMaterialsViewController.h
//  CRM
//
//  Created by TimTiger on 2/3/15.
//  Copyright (c) 2015 TimTiger. All rights reserved.
//

#import "TimTableViewController.h"


@protocol CaseMaterialsViewControllerDelegate;
@interface CaseMaterialsViewController : TimTableViewController

@property (weak,nonatomic) id <CaseMaterialsViewControllerDelegate> delegate;
@property (nonatomic,retain) NSMutableArray *materialsArray;

@end

@protocol CaseMaterialsViewControllerDelegate <NSObject>

- (void)didSelectedMaterialsArray:(NSArray *)sourceArray;

@end
