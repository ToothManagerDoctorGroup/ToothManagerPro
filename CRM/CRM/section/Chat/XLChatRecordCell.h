//
//  XLChatRecordCell.h
//  CRM
//
//  Created by Argo Zhang on 16/4/27.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLEmojiLabel.h"

@class XLChatBaseModel;
@protocol XLChatRecordCellDelegate;

@interface XLChatRecordCell : UITableViewCell

@property (nonatomic, copy) void (^cellDidSelectLinkTextOperationBlock)(NSString *link, MLEmojiLabelLinkType type);

@property (nonatomic, weak)id<XLChatRecordCellDelegate> delegate;

@property (nonatomic, strong)XLChatBaseModel *model;

/**
 *  default is UIEdgeInsetsMake(8, 15, 8, 10)
 */
@property (nonatomic, assign)UIEdgeInsets leftMargin UI_APPEARANCE_SELECTOR;
/**
 *  default is UIEdgeInsetsMake(8, 10, 8, 15)
 */
@property (nonatomic, assign)UIEdgeInsets rightMargin UI_APPEARANCE_SELECTOR;

//根据模型初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                        model:(XLChatBaseModel *)model;

+ (NSString *)cellIdentifierWithModel:(XLChatBaseModel *)model;

+ (CGFloat)cellHeightWithModel:(XLChatBaseModel *)model;

@end

@protocol XLChatRecordCellDelegate <NSObject>

@optional
- (void)messageCellSelected:(XLChatBaseModel *)model;
- (void)avatarViewSelcted:(XLChatBaseModel *)model;

@end
