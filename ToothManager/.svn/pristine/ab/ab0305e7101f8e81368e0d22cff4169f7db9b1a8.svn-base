//
//  TTMUpdateChairController.h
//  ToothManager
//
//  Created by roger wu on 15/11/11.
//  Copyright © 2015年 roger. All rights reserved.
//

#import "TTMBaseColorController.h"
@protocol TTMUpdateChairControllerDelegate;

/**
 *  修改椅位费
 */
@interface TTMUpdateChairController : TTMBaseColorController

/**
 *  椅位费
 */
@property (nonatomic, copy) NSString *chairMoney;

@property (nonatomic, weak) id<TTMUpdateChairControllerDelegate> delegate;

@end

@protocol TTMUpdateChairControllerDelegate <NSObject>

- (void)updateChairController:(TTMUpdateChairController *)updateChairController chariMoney:(NSString *)chariMoney;

@end
