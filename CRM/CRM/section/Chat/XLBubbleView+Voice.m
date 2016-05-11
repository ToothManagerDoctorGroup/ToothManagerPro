//
//  XLBubbleView+Voice.m
//  CRM
//
//  Created by Argo Zhang on 16/4/27.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLBubbleView+Voice.h"
#import <Masonry.h>

@implementation XLBubbleView (Voice)
- (void)setupVoiceBubbleView
{
    self.voiceImageView = [[UIImageView alloc] init];
    self.voiceImageView.backgroundColor = [UIColor clearColor];
    self.voiceImageView.animationDuration = 1;
    [self.backgroundImageView addSubview:self.voiceImageView];
    
    self.voiceDurationLabel = [[UILabel alloc] init];
    self.voiceDurationLabel.backgroundColor = [UIColor clearColor];
    [self.backgroundImageView addSubview:self.voiceDurationLabel];
    
    WS(weakSelf);
    if (self.isSender) {
        //我是发送者
        [self.voiceImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.backgroundImageView).with.offset(weakSelf.margin.top);
            make.bottom.equalTo(weakSelf.backgroundImageView).with.offset(-weakSelf.margin.bottom);
            make.right.equalTo(weakSelf.backgroundImageView).with.offset(-weakSelf.margin.right);
        }];
        
        [self.voiceDurationLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.backgroundImageView).with.offset(weakSelf.margin.left);
            make.top.equalTo(weakSelf.backgroundImageView).with.offset(weakSelf.margin.top);
            make.bottom.equalTo(weakSelf.backgroundImageView).with.offset(weakSelf.margin.bottom);
            make.right.equalTo(weakSelf.voiceImageView.mas_left).with.offset(kBubbleViewPedding);
        }];
        
    }else{
        //我是接收者
        [self.voiceImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.backgroundImageView).with.offset(weakSelf.margin.top);
            make.bottom.equalTo(weakSelf.backgroundImageView).with.offset(-weakSelf.margin.bottom);
            make.left.equalTo(weakSelf.backgroundImageView).with.offset(weakSelf.margin.left);
        }];
        
        [self.voiceDurationLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.voiceImageView.mas_right).with.offset(kBubbleViewPedding);
            make.top.equalTo(weakSelf.backgroundImageView).with.offset(weakSelf.margin.top);
            make.bottom.equalTo(weakSelf.backgroundImageView).with.offset(-weakSelf.margin.bottom);
            make.right.equalTo(weakSelf.backgroundImageView).with.offset(-weakSelf.margin.right);
        }];
    }
    
}
@end
