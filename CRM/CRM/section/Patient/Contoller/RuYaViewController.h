//
//  RuYaViewController.h
//  CRM
//
//  Created by lsz on 15/10/24.
//  Copyright (c) 2015年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol RuYaDelegate;

@interface RuYaViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)btnClick:(id)sender;
@property (nonatomic,assign) id<RuYaDelegate> delegate;
@property (nonatomic,copy) NSString *ruYaString;
@end

@protocol RuYaDelegate <NSObject>

-(void)removeRuYaVC;

- (void)changeToHengYaVC;

- (void)queDingRuYa:(NSMutableArray *)ruYaArray toothStr:(NSString *)toothStr;
@end
