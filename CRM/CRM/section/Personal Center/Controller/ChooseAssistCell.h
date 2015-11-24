//
//  ChooseAssistCell.h
//  CRM
//
//  Created by Argo Zhang on 15/11/24.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>
//添加代理，用于按钮加减的实现
@class ChooseAssistCell,AssistCountModel,MaterialCountModel;
@protocol ChooseAssistCellDelegate <NSObject>

-(void)btnClick:(ChooseAssistCell *)cell andFlag:(int)flag;

@end
@interface ChooseAssistCell : UITableViewCell


+ (instancetype)assistCellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong)AssistCountModel *assistModel;
@property (nonatomic, strong)MaterialCountModel *materialModel;

@property (nonatomic, weak)id<ChooseAssistCellDelegate> delegate;
@end
