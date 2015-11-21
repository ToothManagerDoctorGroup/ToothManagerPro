//
//  CommentCell.h
//  CRM
//
//  Created by Argo Zhang on 15/11/20.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>


@class CommentModelFrame;
@interface CommentCell : UITableViewCell

/**
 *  数据模型
 */
@property (nonatomic, strong)CommentModelFrame *modelFrame;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
