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

@property (nonatomic,readwrite) BOOL edit;//是否是编辑状态
@property (nonatomic, assign)BOOL showPatients;//是否显示患者列表

@property (nonatomic,copy) NSString *materialId;
@property (weak, nonatomic) IBOutlet TimPickerTextField *nameTextField;
@property (weak, nonatomic) IBOutlet TimPickerTextField *priceTextField;
@property (weak, nonatomic) IBOutlet TimPickerTextField *typeTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
