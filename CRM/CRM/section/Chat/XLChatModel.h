//
//  XLChatModel.h
//  CRM
//
//  Created by Argo Zhang on 16/4/27.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface XLChatModel : NSObject

/*主键id*/
@property (nonatomic, copy)NSString *keyId;
/*发送者id*/
@property (nonatomic, copy)NSString *sender_id;
/*发送者姓名*/
@property (nonatomic, copy)NSString *sender_name;
/*接收者id*/
@property (nonatomic, copy)NSString *receiver_id;
/*接收者姓名*/
@property (nonatomic, copy)NSString *receiver_name;
/*消息类型*/
@property (nonatomic, copy)NSString *content_type;
/*消息实体(文本内容，语音地址，图片地址)*/
@property (nonatomic, copy)NSString *content;
/*发送时间*/
@property (nonatomic, copy)NSString *send_time;
/*语音时长*/
@property (nonatomic, strong)NSNumber *duration;
/*图片缩略图地址*/
@property (nonatomic, copy)NSString *thumb;
/*图片缩略图密钥，环信*/
@property (nonatomic, copy)NSString *thumb_secret;
/*图片密钥或语音密钥，环信*/
@property (nonatomic, copy)NSString *secret;

/**
 * 发送语音
 */
- (instancetype)initWithReceiverId:(NSString *)receiverId receiverName:(NSString *)receiverName content:(NSString *)content duration:(NSNumber *)duration secret:(NSString *)secret;
/**
 * 发送文本
 */
- (instancetype)initWithReceiverId:(NSString *)receiverId receiverName:(NSString *)receiverName content:(NSString *)content;
/**
 * 发送图片
 */
- (instancetype)initWithReceiverId:(NSString *)receiverId receiverName:(NSString *)receiverName content:(NSString *)content secret:(NSString *)secret thumb:(NSString *)thumb thumbSecret:(NSString *)thumbSecret;

@end
