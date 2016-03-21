//
//  XLAssistenceDetailViewController.h
//  CRM
//
//  Created by Argo Zhang on 16/1/28.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "TimViewController.h"
/**
 *  用户使用帮助详情
 */
@class XLAssistenceModel;
@interface XLAssistenceDetailViewController : TimViewController

@property (nonatomic, strong)XLAssistenceModel *model;

@property (nonatomic, strong)UIImage *image;

@end
