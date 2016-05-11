//
//  XLMessageReadManager.h
//  CRM
//
//  Created by Argo Zhang on 16/5/3.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWPhotoBrowser.h"
#import "XLChatBaseModel.h"

typedef void (^FinishBlock)(BOOL success);
typedef void (^PlayBlock)(BOOL playing, XLChatBaseModel *messageModel);
/**
 *  消息处理
 */
@interface XLMessageReadManager : NSObject<MWPhotoBrowserDelegate>


@property (strong, nonatomic) MWPhotoBrowser *photoBrowser;
@property (strong, nonatomic) FinishBlock finishBlock;

@property (strong, nonatomic) XLChatBaseModel *audioMessageModel;


//default
- (void)showBrowserWithImages:(NSArray *)imageArray;

+ (id)defaultManager;

/**
 *  准备播放语音文件
 *
 *  @param messageModel     要播放的语音文件
 *  @param updateCompletion 需要更新model所在的Cell
 *
 *  @return 若返回NO，则不需要调用播放方法
 *
 */
- (BOOL)prepareMessageAudioModel:(XLChatBaseModel *)messageModel
            updateViewCompletion:(void (^)(XLChatBaseModel *prevAudioModel, XLChatBaseModel *currentAudioModel))updateCompletion;

- (XLChatBaseModel *)stopMessageAudioModel;

@end
