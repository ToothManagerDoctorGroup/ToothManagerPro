//
//  XLChatRecordCell.m
//  CRM
//
//  Created by Argo Zhang on 16/4/27.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLChatRecordCell.h"
#import "UIView+SDAutoLayout.h"
#import "XLChatModel.h"
#import "XLBubbleView.h"
#import "XLBubbleView+Image.h"
#import "XLBubbleView+Text.h"
#import "XLBubbleView+Voice.h"
#import "XLChatBaseModel.h"
#import "UIImageView+WebCache.h"
#import "MyDateTool.h"
#import <Masonry.h>

#define kBubbleTextFont [UIFont systemFontOfSize:15]
#define kMessageBubbleMaxWidth 200

#define kXLMessageImageSizeWidth 120
#define kXLMessageImageSizeHeight 120
#define kXLMessageVoiceHeight 23

CGFloat const XLMessageCellPadding = 10;
//receive
NSString *const XLMessageCellIdentifierRecvText = @"XLMessageCellRecvText";
NSString *const XLMessageCellIdentifierRecvVoice = @"XLMessageCellRecvVoice";
NSString *const XLMessageCellIdentifierRecvImage = @"XLMessageCellRecvImage";
//send
NSString *const XLMessageCellIdentifierSendText = @"XLMessageCellSendText";
NSString *const XLMessageCellIdentifierSendVoice = @"XLMessageCellSendVoice";
NSString *const XLMessageCellIdentifierSendImage = @"XLMessageCellSendImage";

@interface XLChatRecordCell (){
    XLMessageType _messageType;
}

@property (nonatomic, strong)UIImageView *avatarImageView;//头像
@property (nonatomic, strong)UILabel *nameLabel;//姓名
@property (nonatomic, strong)UILabel *timeLabel;//时间
@property (nonatomic, strong)XLBubbleView *bubbleView;//气泡视图


@property (nonatomic, strong)NSArray *sendMessageVoiceAnimationImages;
@property (nonatomic, strong)NSArray *recvMessageVoiceAnimationImages;

@property (nonatomic, strong)UIImage *sendBackgroundImage;
@property (nonatomic, strong)UIImage *recvBackgroundImage;
@end

@implementation XLChatRecordCell

+ (void)initialize{
    XLChatRecordCell *cell = [self appearance];
    cell.leftMargin = UIEdgeInsetsMake(8, 15, 8, 10);
    cell.rightMargin = UIEdgeInsetsMake(8, 10, 8, 15);
}

//根据模型初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                        model:(XLChatBaseModel *)model{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //初始化
        _messageType = model.messageType;
        [self setUpSubViewsWithType:_messageType model:model];
    }
    return self;
}

#pragma mark - 初始化
- (void)setUpSubViewsWithType:(XLMessageType)type model:(XLChatBaseModel *)model{
    _avatarImageView = [[UIImageView alloc] init];
    _avatarImageView.backgroundColor = [UIColor clearColor];
    _avatarImageView.clipsToBounds = YES;
    _avatarImageView.userInteractionEnabled = YES;
    [self.contentView addSubview:_avatarImageView];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont systemFontOfSize:13];
    _nameLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:_nameLabel];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = [UIFont systemFontOfSize:13];
    _timeLabel.textColor = [UIColor grayColor];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_timeLabel];
    
    XLChatRecordCell *cell = [XLChatRecordCell appearance];
    _bubbleView = [[XLBubbleView alloc] initWithMargin:model.chatType == XLChatTypeSendToMe ? cell.leftMargin : cell.rightMargin];
    _bubbleView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_bubbleView];
    
    switch (type) {
        case XLMessageTypeText:
        {
            [_bubbleView setupTextBubbleView];
            
            __weak typeof(self) weakSelf = self;
            [_bubbleView setDidSelectLinkTextOperationBlock:^(NSString *link, MLEmojiLabelLinkType type) {
                if (weakSelf.cellDidSelectLinkTextOperationBlock) {
                    weakSelf.cellDidSelectLinkTextOperationBlock(link,type);
                }
            }];
            _bubbleView.textLabel.font = [UIFont systemFontOfSize:15];
            _bubbleView.textLabel.textColor = [UIColor blackColor];
        }
            break;
        case XLMessageTypeImage:
        {
            [_bubbleView setupImageBubbleView];
            
            _bubbleView.imageView.image = [UIImage imageNamed:@"EaseUIResource.bundle/imageDownloadFail"];
        }
            
            break;
        case XLMessageTypeVoice:
        {
            [_bubbleView setupVoiceBubbleView];
            
            _bubbleView.voiceDurationLabel.textColor = [UIColor grayColor];
            _bubbleView.voiceDurationLabel.font = [UIFont systemFontOfSize:12];
        }
            
            break;
        default:
            break;
    }
    
    //设置约束
    [self setUpSubViewsFrameWithModel:model];
    
    //设置单击事件
    UITapGestureRecognizer *tapBubble = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bubbleViewTapAction:)];
    [_bubbleView addGestureRecognizer:tapBubble];
    UITapGestureRecognizer *tapAvatar = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarViewTapAction:)];
    [_avatarImageView addGestureRecognizer:tapAvatar];
    
}

#pragma mark - setUpSubViewsFrame
- (void)setUpSubViewsFrameWithModel:(XLChatBaseModel *)model{
    
    __weak typeof(self) weakSelf = self;
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView);
        make.right.equalTo(weakSelf.contentView);
        make.top.equalTo(weakSelf.contentView);
        make.height.mas_equalTo(20);
    }];
    
    if (model.chatType == XLChatTypeSendToMe) {
        [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(XLMessageCellPadding);
            make.top.equalTo(_timeLabel.mas_bottom).with.offset(XLMessageCellPadding);
            make.size.mas_equalTo(CGSizeMake(35, 35));
        }];
        
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_timeLabel.mas_bottom).with.offset(XLMessageCellPadding / 2);
            make.left.equalTo(_avatarImageView.mas_right).with.offset(XLMessageCellPadding);
            make.right.equalTo(weakSelf.contentView);
            make.height.mas_equalTo(20);
        }];
        
        [_bubbleView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_avatarImageView.mas_right).with.offset(XLMessageCellPadding);
            make.top.equalTo(_nameLabel.mas_bottom);
            make.width.lessThanOrEqualTo(@kMessageBubbleMaxWidth);
            make.bottom.equalTo(weakSelf.contentView).with.offset(-XLMessageCellPadding);
        }];
    }else{
        [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-XLMessageCellPadding);
            make.top.equalTo(_timeLabel.mas_bottom).with.offset(XLMessageCellPadding);
            make.size.mas_equalTo(CGSizeMake(35, 35));
        }];
        
        _nameLabel.textAlignment = NSTextAlignmentRight;
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_timeLabel.mas_bottom).with.offset(XLMessageCellPadding / 2);
            make.right.equalTo(_avatarImageView.mas_left).with.offset(-XLMessageCellPadding);
            make.left.equalTo(weakSelf.contentView);
            make.height.mas_equalTo(20);
        }];
        
        [_bubbleView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_avatarImageView.mas_left).with.offset(-XLMessageCellPadding);
            make.top.equalTo(_nameLabel.mas_bottom);
            make.width.lessThanOrEqualTo(@kMessageBubbleMaxWidth);
            make.bottom.equalTo(weakSelf.contentView).with.offset(-XLMessageCellPadding);
        }];
    }
}
#pragma mark - ********************* Private Method ***********************
- (void)bubbleViewTapAction:(UITapGestureRecognizer *)tap{
    if (_delegate && [_delegate respondsToSelector:@selector(messageCellSelected:)]) {
        [_delegate messageCellSelected:_model];
    }
}

- (void)avatarViewTapAction:(UITapGestureRecognizer *)tap{
    if (_delegate && [_delegate respondsToSelector:@selector(avatarViewSelcted:)]) {
        [_delegate avatarViewSelcted:_model];
    }
}

#pragma mark - ********************* Set / Get ***********************
- (void)setModel:(XLChatBaseModel *)model{
    _model = model;
    
    _timeLabel.text = [MyDateTool stringWithDateNoSec:[MyDateTool dateWithStringWithSec:model.contentModel.send_time]];
    if (model.chatType == XLChatTypeSendToMe) {
        _nameLabel.text = model.contentModel.sender_name;
        _avatarImageView.image = [UIImage imageNamed:@"patient_head"];
        _bubbleView.backgroundImageView.image = self.recvBackgroundImage;
    }else{
        _nameLabel.text = model.contentModel.sender_name;
        _avatarImageView.image = [UIImage imageNamed:@"user_icon"];
        _bubbleView.backgroundImageView.image = self.sendBackgroundImage;
    }
    
    switch (model.messageType) {
        case XLMessageTypeText:
        {
            _bubbleView.textLabel.text = model.contentModel.content;
        }
            break;
        case XLMessageTypeImage:
        {
            NSURL *url = [NSURL URLWithString:model.contentModel.thumb.length > 0 ? model.contentModel.thumb : model.contentModel.content];
            [_bubbleView.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"EaseUIResource.bundle/imageDownloadFail"]];
        }
            break;
            
        case XLMessageTypeVoice:
        {
            if (_bubbleView.voiceImageView) {
                if (model.chatType == XLChatTypeSendToMe) {
                    self.bubbleView.voiceImageView.image = [UIImage imageNamed:@"chat_receiver_audio_playing_full"];
                    _bubbleView.voiceImageView.animationImages = self.recvMessageVoiceAnimationImages;
                }else{
                    self.bubbleView.voiceImageView.image = [UIImage imageNamed:@"chat_sender_audio_playing_full"];
                    _bubbleView.voiceImageView.animationImages = self.sendMessageVoiceAnimationImages;
                }
                
            }
            
            if (_model.isMediaPlaying) {
                [_bubbleView.voiceImageView startAnimating];
            }else{
                [_bubbleView.voiceImageView stopAnimating];
            }
            _bubbleView.voiceDurationLabel.text = [NSString stringWithFormat:@"%ld''",(long)[model.contentModel.duration integerValue]];
        }
            break;
        
        default:
            break;
    }
}

#pragma mark - ********************* Public Method ***********************
//计算cell的高度
+ (CGFloat)cellHeightWithModel:(XLChatBaseModel *)model{
    if (model.cellHeight > 0) {
        return model.cellHeight;
    }
    CGFloat bubbleMaxWidth = kMessageBubbleMaxWidth;
    
    XLChatRecordCell *cell = [XLChatRecordCell appearance];
    
    bubbleMaxWidth -= (cell.leftMargin.left + cell.leftMargin.right + cell.rightMargin.left + cell.rightMargin.right) / 2;
    
    CGFloat height = XLMessageCellPadding * 0.5 + 20 * 2 + cell.leftMargin.top + cell.leftMargin.bottom;
    
    switch (model.messageType) {
        case XLMessageTypeText:
        {
            NSString *text = model.contentModel.content;
            CGRect rect = [text boundingRectWithSize:CGSizeMake(bubbleMaxWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kBubbleTextFont} context:nil];
            height += (rect.size.height > 20 ? rect.size.height : 20) + 10;
        }
            break;
        case XLMessageTypeImage:
        {
            CGSize retSize = CGSizeMake(kXLMessageImageSizeWidth, kXLMessageImageSizeHeight);
            
            height += retSize.height;
        }
            break;
            
        case XLMessageTypeVoice:
        {
            height += kXLMessageVoiceHeight;
        }
            break;
        default:
            break;
    }
    
    height += XLMessageCellPadding;
    model.cellHeight = height;
    
    return height;
    
}

+ (NSString *)cellIdentifierWithModel:(XLChatBaseModel *)model{
    NSString *cellIdentifier = nil;
    if (model.chatType == XLChatTypeSendToOthers) {
        switch (model.messageType) {
            case XLMessageTypeText:
                cellIdentifier = XLMessageCellIdentifierSendText;
                break;
            case XLMessageTypeImage:
                cellIdentifier = XLMessageCellIdentifierSendImage;
                break;
            case XLMessageTypeVoice:
                cellIdentifier = XLMessageCellIdentifierSendVoice;
                break;
            default:
                break;
        }
    }
    else{
        switch (model.messageType) {
            case XLMessageTypeText:
                cellIdentifier = XLMessageCellIdentifierRecvText;
                break;
            case XLMessageTypeImage:
                cellIdentifier = XLMessageCellIdentifierRecvImage;
                break;
            case XLMessageTypeVoice:
                cellIdentifier = XLMessageCellIdentifierRecvVoice;
                break;
            default:
                break;
        }
    }
    
    return cellIdentifier;
}

#pragma mark - ********************* Lazy Method ***********************
- (UIImage *)sendBackgroundImage{
    if (!_sendBackgroundImage) {
        _sendBackgroundImage = [[UIImage imageNamed:@"chat_sender_bg"] stretchableImageWithLeftCapWidth:5 topCapHeight:35];
    }
    return _sendBackgroundImage;
}

- (UIImage *)recvBackgroundImage{
    if (!_recvBackgroundImage) {
        _recvBackgroundImage = [[UIImage imageNamed:@"chat_receiver_bg"] stretchableImageWithLeftCapWidth:35 topCapHeight:35];
    }
    return _recvBackgroundImage;
}

- (NSArray *)sendMessageVoiceAnimationImages{
    if (!_sendMessageVoiceAnimationImages) {
        _sendMessageVoiceAnimationImages = @[[UIImage imageNamed:@"chat_sender_audio_playing_full"], [UIImage imageNamed:@"chat_sender_audio_playing_000"], [UIImage imageNamed:@"chat_sender_audio_playing_001"], [UIImage imageNamed:@"chat_sender_audio_playing_002"], [UIImage imageNamed:@"chat_sender_audio_playing_003"]];
    }
    return _sendMessageVoiceAnimationImages;
}

- (NSArray *)recvMessageVoiceAnimationImages{
    if (!_recvMessageVoiceAnimationImages) {
        _recvMessageVoiceAnimationImages = @[[UIImage imageNamed:@"chat_receiver_audio_playing_full"],[UIImage imageNamed:@"chat_receiver_audio_playing000"], [UIImage imageNamed:@"chat_receiver_audio_playing001"], [UIImage imageNamed:@"chat_receiver_audio_playing002"], [UIImage imageNamed:@"chat_receiver_audio_playing003"]];
    }
    return _recvMessageVoiceAnimationImages;
}


@end
