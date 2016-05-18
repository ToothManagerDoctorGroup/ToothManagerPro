//
//  XLHengYaViewController.h
//  CRM
//
//  Created by Argo Zhang on 16/2/18.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

/**
 *  恒牙选择
 */
@protocol XLHengYaDeleate;

@interface XLHengYaViewController : UITableViewController

- (IBAction)btnClick:(id)sender;
- (IBAction)queDingClick:(id)sender;
@property (nonatomic,assign) id<XLHengYaDeleate> delegate;
@property (nonatomic,copy) NSString *hengYaString;

@end

@protocol XLHengYaDeleate <NSObject>
//移除恒牙视图
- (void)removeHengYaVC;
//确定按钮点击
- (void)queDingHengYa:(NSMutableArray *)hengYaArray toothStr:(NSString *)toothStr;
//切换到乳牙
- (void)changeToRuYaVC;
@end

