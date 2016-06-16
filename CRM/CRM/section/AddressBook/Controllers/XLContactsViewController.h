//
//  XLContactsViewController.h
//  CRM
//
//  Created by Argo Zhang on 16/3/15.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "TimTableViewController.h"


typedef NS_ENUM(NSInteger, ContactsImportType) {
    ContactsImportTypeIntroducer = 1, //导入介绍人
    ContactsImportTypePatients = 2 //导入患者
};
/**
 *  通讯录联系人页面
 */
@interface XLContactsViewController : TimTableViewController

@property (nonatomic,assign)ContactsImportType type;

@end
