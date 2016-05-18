//
//  XLBubbleView.h
//  CRM
//
//  Created by Argo Zhang on 16/4/27.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLEmojiLabel.h"

#define kBubbleViewPedding 10

@interface XLBubbleView : UIView

/**
 *  富文本
 */
@property (nonatomic, copy) void (^didSelectLinkTextOperationBlock)(NSString *link, MLEmojiLabelLinkType type);

@property (nonatomic, assign)BOOL isSender;

@property (nonatomic, assign) UIEdgeInsets margin;//气泡中子视图的偏移量

@property (strong, nonatomic) UIImageView *backgroundImageView;

//text views
@property (strong, nonatomic) UILabel *textLabel;

//image views
@property (strong, nonatomic) UIImageView *imageView;

//voice views
@property (strong, nonatomic) UIImageView *voiceImageView;
@property (strong, nonatomic) UILabel *voiceDurationLabel;

- (instancetype)initWithMargin:(UIEdgeInsets)margin;

@end
