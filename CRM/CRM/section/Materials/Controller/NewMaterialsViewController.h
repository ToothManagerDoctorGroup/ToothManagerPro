//
//  NewMaterialsViewController.h
//  CRM
//
//  Created by mac on 14-5-12.
//  Copyright (c) 2014年 TimTiger. All rights reserved.
//

#import "TimFramework.h"

@interface NewMaterialsViewController : TimViewController<UITableViewDataSource,UITableViewDelegate>
{
}

@property (nonatomic,readwrite) BOOL edit;
@property (nonatomic,copy) NSString *materialId;
@property (weak, nonatomic) IBOutlet TimPickerTextField *nameTextField;
@property (weak, nonatomic) IBOutlet TimPickerTextField *priceTextField;
@property (weak, nonatomic) IBOutlet TimPickerTextField *typeTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
