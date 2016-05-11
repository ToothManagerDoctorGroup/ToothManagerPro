//
//  XLChatBaseModel.h
//  CRM
//
//  Created by Argo Zhang on 16/5/3.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    XLChatTypeSendToOthers,
    XLChatTypeSendToMe
} XLChatType;

typedef enum : NSUInteger {
    XLMessageTypeText,
    XLMessageTypeImage,
    XLMessageTypeVoice
} XLMessageType;

typedef enum : NSUInteger {
    XLFileDownLoadStatusDownLoading,//正在下载
    XLFileDownLoadStatusSuccess,    //下载成功
    XLFileDownLoadStatusFail,       //下载失败
    XLFileDownLoadStatusPrepare     //准备下载
} XLFileDownLoadStatus;


@class XLChatModel;
@interface XLChatBaseModel : NSObject

@property (nonatomic, strong)XLChatModel *contentModel;

@property (nonatomic, assign)CGFloat cellHeight;

/** 语音是否正在播放*/
@property (nonatomic, assign)BOOL isMediaPlaying;
/** 语音是否播放过*/
@property (nonatomic, assign)BOOL isMediaPlayed;
/**消息体的类型*/
@property (nonatomic, assign)XLMessageType messageType;
/*消息发送的类型*/
@property (nonatomic, assign)XLChatType chatType;
/**语音的本地地址*/
@property (nonatomic, copy)NSString *voiceFilePath;
/**语音文件的下载状态*/
@property (nonatomic, assign)XLFileDownLoadStatus downStatus;

- (instancetype)initWithChatModel:(XLChatModel *)chatModel;

@end
