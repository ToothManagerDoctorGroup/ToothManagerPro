//
//  XLRuYaViewController.h
//  CRM
//
//  Created by Argo Zhang on 16/2/18.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

/**
 *  乳牙选择
 */
@protocol XLRuYaDelegate;

@interface XLRuYaViewController : UITableViewController
- (IBAction)btnClick:(id)sender;
@property (nonatomic,assign) id<XLRuYaDelegate> delegate;
@property (nonatomic,copy) NSString *ruYaString;
@end

@protocol XLRuYaDelegate <NSObject>

-(void)removeRuYaVC;

- (void)changeToHengYaVC;

- (void)queDingRuYa:(NSMutableArray *)ruYaArray toothStr:(NSString *)toothStr;
@end

