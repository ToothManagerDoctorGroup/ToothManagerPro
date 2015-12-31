//
//  QrCodeViewController.h
//  CRM
//
//  Created by lsz on 15/6/19.
//  Copyright (c) 2015年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimViewController.h"
#import "DBTableMode.h"

@interface QrCodeViewController : TimViewController
@property (weak, nonatomic) IBOutlet UIImageView *QrCodeImageView;
//@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, assign)BOOL isDoctor;
@property (nonatomic, strong)Patient *patient;

@end
