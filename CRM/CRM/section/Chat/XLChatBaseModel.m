//
//  XLChatBaseModel.m
//  CRM
//
//  Created by Argo Zhang on 16/5/3.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLChatBaseModel.h"
#import "XLChatModel.h"
#import "AccountManager.h"
#import "XLFilePathManager.h"

@implementation XLChatBaseModel

- (instancetype)initWithChatModel:(XLChatModel *)chatModel{
    if (self = [super init]) {
        self.contentModel = chatModel;
        
        self.isMediaPlayed = NO;
        self.isMediaPlaying = NO;
        
        if ([chatModel.sender_id isEqualToString:[AccountManager currentUserid]]) {
            self.chatType = XLChatTypeSendToOthers;
        }else{
            self.chatType = XLChatTypeSendToMe;
        }
        
        if ([chatModel.content_type isEqualToString:@"text"]) {
            self.messageType = XLMessageTypeText;
        }else if ([chatModel.content_type isEqualToString:@"audio"]){
            self.messageType = XLMessageTypeVoice;
            self.downStatus = XLFileDownLoadStatusPrepare;
            if ([chatModel.sender_id isEqualToString:[AccountManager currentUserid]]) {
                NSString *dir = [[XLFilePathManager shareInstance] createDirWithPatientId:chatModel.receiver_id];
                NSString *name = [[chatModel.content componentsSeparatedByString:@"/"] lastObject];
                self.voiceFilePath = [NSString stringWithFormat:@"%@/%@.amr",dir,name];
            }else{
                NSString *dir = [[XLFilePathManager shareInstance] createDirWithPatientId:chatModel.sender_id];
                NSString *name = [[chatModel.content componentsSeparatedByString:@"/"] lastObject];
                self.voiceFilePath = [NSString stringWithFormat:@"%@/%@.amr",dir,name];
            }
        }else{
            self.messageType = XLMessageTypeImage;
        }
        
    }
    return self;
}

@end
