//
//  SuccessViewController.h
//  HuanxinTest
//
//  Created by Argo Zhang on 15/12/3.
//  Copyright © 2015年 Argo Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  环信EaseUI
 */
@interface SuccessViewController : EaseConversationListViewController


- (void)refreshDataSource;
- (void)isConnect:(BOOL)isConnect;
- (void)networkChanged:(EMConnectionState)connectionState;

@end
