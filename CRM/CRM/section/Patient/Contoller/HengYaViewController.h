//
//  HengYaViewController.h
//  CRM
//
//  Created by lsz on 15/10/22.
//  Copyright (c) 2015年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HengYaDeleate;

@interface HengYaViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)btnClick:(id)sender;
- (IBAction)queDingClick:(id)sender;
@property (nonatomic,assign) id<HengYaDeleate> delegate;
@property (nonatomic,copy) NSString *hengYaString;

@end

@protocol HengYaDeleate <NSObject>

- (void)removeHengYaVC;

- (void)queDingHengYa:(NSMutableArray *)hengYaArray;

- (void)changeToRuYaVC;
@end