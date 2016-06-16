//
//  XLChatModel.m
//  CRM
//
//  Created by Argo Zhang on 16/4/27.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLChatModel.h"
#import "MJExtension.h"
#import "AccountManager.h"
#import "MyDateTool.h"

@implementation XLChatModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"keyId" : @"KeyId"};
}


/*发送语音*/
- (instancetype)initWithReceiverId:(NSString *)receiverId receiverName:(NSString *)receiverName content:(NSString *)content duration:(NSNumber *)duration secret:(NSString *)secret{
    if (self = [super init]) {
        self.keyId = @"";
        self.sender_id = [AccountManager currentUserid];
        self.sender_name = [AccountManager shareInstance].currentUser.name;
        self.receiver_id = receiverId;
        self.receiver_name = receiverName;
        self.content_type = @"audio";
        self.content = content;
        self.send_time = [MyDateTool stringWithDateWithSec:[NSDate date]];
        self.duration = duration;
        self.secret = secret;
        self.thumb = @"";
        self.thumb_secret = @"";
    }
    return self;
}
/*发送文本内容*/
- (instancetype)initWithReceiverId:(NSString *)receiverId receiverName:(NSString *)receiverName content:(NSString *)content{
    if (self = [super init]) {
        self.keyId = @"";
        self.sender_id = [AccountManager currentUserid];
        self.sender_name = [AccountManager shareInstance].currentUser.name;
        self.receiver_id = receiverId;
        self.receiver_name = receiverName;
        self.content_type = @"text";
        self.content = content;
        self.send_time = [MyDateTool stringWithDateWithSec:[NSDate date]];
        self.duration = @(0);
        self.secret = @"";
        self.thumb = @"";
        self.thumb_secret = @"";
    }
    return self;
}
/*发送图片*/
- (instancetype)initWithReceiverId:(NSString *)receiverId receiverName:(NSString *)receiverName content:(NSString *)content secret:(NSString *)secret thumb:(NSString *)thumb thumbSecret:(NSString *)thumbSecret{
    if (self = [super init]) {
        self.keyId = @"";
        self.sender_id = [AccountManager currentUserid];
        self.sender_name = [AccountManager shareInstance].currentUser.name;
        self.receiver_id = receiverId;
        self.receiver_name = receiverName;
        self.content_type = @"img";
        self.content = content;
        self.send_time = [MyDateTool stringWithDateWithSec:[NSDate date]];
        self.duration = @(0);
        self.secret = secret;
        self.thumb = thumb;
        self.thumb_secret = thumbSecret;
    }
    return self;
}


@end
