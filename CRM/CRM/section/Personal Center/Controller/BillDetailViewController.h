//
//  BillDetailViewController.h
//  CRM
//
//  Created by Argo Zhang on 15/11/13.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "TimDisplayViewController.h"

@protocol BillDetailViewControllerDelegate <NSObject>

@optional
/**
 *  支付成功回调
 *
 *  @param result 支付结果
 */
- (void)didPaySuccess:(NSString *)result;

@end

@interface BillDetailViewController : TimDisplayViewController

@property (nonatomic, copy)NSString *billId;
@property (nonatomic, copy)NSString *type;

@property (nonatomic, weak)id<BillDetailViewControllerDelegate> delegate;

@end
