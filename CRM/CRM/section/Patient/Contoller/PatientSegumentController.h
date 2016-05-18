//
//  PatientSegumentController.h
//  CRM
//
//  Created by Argo Zhang on 15/12/7.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "TimViewController.h"
/**
 *  首页患者页面，包含：患者和消息页面
 */
@interface PatientSegumentController : TimViewController{
    EMConnectionState _connectionState;
}

- (void)refreshDataSource;
- (void)isConnect:(BOOL)isConnect;
- (void)networkChanged:(EMConnectionState)connectionState;

@property (nonatomic, assign)BOOL showTipView;

@end
