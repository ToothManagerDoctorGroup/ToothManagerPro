//
//  ChatViewController.m
//  ChatDemo-UI3.0
//
//  Created by dhc on 15/6/26.
//  Copyright (c) 2015年 easemob.com. All rights reserved.
//

#import "ChatViewController.h"

//#import "ChatGroupDetailViewController.h"
//#import "ChatroomDetailViewController.h"
#import "CustomMessageCell.h"
#import "UserProfileViewController.h"
#import "UserProfileManager.h"
#import "AccountManager.h"
#import "DBManager+Patients.h"
#import "DBManager+Doctor.h"
#import "XLTreateGroupViewController.h"
#import "UIColor+Extension.h"
#import "MyPatientTool.h"
#import "CRMHttpRespondModel.h"
#import "QrCodeViewController.h"
#import "XLAdviceSelectViewController.h"
#import "DBTableMode.h"
#import "XLPatientEducationViewController.h"
#import "XLChatRecordViewController.h"
#import "SysMessageTool.h"
#import "JSONKit.h"
#import "DoctorTool.h"
#import "XLChatModel.h"
#import "SysMessageTool.h"
#import "CRMUserDefalut.h"

@interface ChatViewController ()<UIAlertViewDelegate, EaseMessageViewControllerDelegate, EaseMessageViewControllerDataSource,XLAdviceSelectViewControllerDelegate>
{
    UIMenuItem *_copyMenuItem;
    UIMenuItem *_deleteMenuItem;
    UIMenuItem *_transpondMenuItem;
}

@property (nonatomic) BOOL isPlayingAudio;
@property (nonatomic, strong)UILabel *tintLabel;
//是否绑定微信
@property (nonatomic, assign)BOOL isBind;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.showRefreshHeader = YES;
    self.delegate = self;
    self.dataSource = self;
    
    [[EaseBaseMessageCell appearance] setSendBubbleBackgroundImage:[[UIImage imageNamed:@"chat_sender_bg"] stretchableImageWithLeftCapWidth:5 topCapHeight:35]];
    [[EaseBaseMessageCell appearance] setRecvBubbleBackgroundImage:[[UIImage imageNamed:@"chat_receiver_bg"] stretchableImageWithLeftCapWidth:35 topCapHeight:35]];
    
    [[EaseBaseMessageCell appearance] setSendMessageVoiceAnimationImages:@[[UIImage imageNamed:@"chat_sender_audio_playing_full"], [UIImage imageNamed:@"chat_sender_audio_playing_000"], [UIImage imageNamed:@"chat_sender_audio_playing_001"], [UIImage imageNamed:@"chat_sender_audio_playing_002"], [UIImage imageNamed:@"chat_sender_audio_playing_003"]]];
    [[EaseBaseMessageCell appearance] setRecvMessageVoiceAnimationImages:@[[UIImage imageNamed:@"chat_receiver_audio_playing_full"],[UIImage imageNamed:@"chat_receiver_audio_playing000"], [UIImage imageNamed:@"chat_receiver_audio_playing001"], [UIImage imageNamed:@"chat_receiver_audio_playing002"], [UIImage imageNamed:@"chat_receiver_audio_playing003"]]];
    
    [[EaseBaseMessageCell appearance] setAvatarSize:40.f];
    [[EaseBaseMessageCell appearance] setAvatarCornerRadius:20.f];
    
    [[EaseChatBarMoreView appearance] setMoreViewBackgroundColor:[UIColor colorWithRed:240 / 255.0 green:242 / 255.0 blue:247 / 255.0 alpha:1.0]];
    
    [self _setupBarButtonItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteAllMessages:) name:KNOTIFICATIONNAME_DELETEALLMESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitGroup) name:@"ExitGroup" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(insertCallMessage:) name:@"insertCallMessage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCallNotification:) name:@"callOutWithChatter" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCallNotification:) name:@"callControllerClose" object:nil];
    
    //通过会话管理者获取已收发消息
    [self tableViewDidTriggerHeaderRefresh];
    
    EaseEmotionManager *manager= [[EaseEmotionManager alloc] initWithType:EMEmotionDefault emotionRow:3 emotionCol:7 emotions:[EaseEmoji allEmoji]];
    [self.faceView setEmotionManagers:@[manager]];
    
    //当前设备被其他设备登录
    [self easeMobIsLogin];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.conversation.conversationType == eConversationTypeGroupChat) {
        if ([[self.conversation.ext objectForKey:@"groupSubject"] length])
        {
            self.title = [self.conversation.ext objectForKey:@"groupSubject"];
        }
    }
    //获取患者微信绑定状态
    [self getPaitientIsBind];
}

#pragma mark - setup subviews

- (void)_setupBarButtonItem
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    //单聊
    if (self.conversation.conversationType == eConversationTypeChat) {
        UIButton *clearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
        [clearButton setTitle:@"消息记录" forState:UIControlStateNormal];
        clearButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [clearButton addTarget:self action:@selector(deleteAllMessages:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:clearButton];
    }
    else{//群聊
        if (self.mCase == nil) {
            return;
        }
        UIButton *detailButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
        [detailButton setImage:[UIImage imageNamed:@"team_team_white"] forState:UIControlStateNormal];
        [detailButton addTarget:self action:@selector(showGroupDetailAction) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:detailButton];
    }
}

#pragma mark - 判断当前环信账号是否

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.cancelButtonIndex != buttonIndex) {
        self.messageTimeIntervalTag = -1;
        [self.conversation removeAllMessages];
        [self.dataArray removeAllObjects];
        [self.messsagesSource removeAllObjects];
        
        [self.tableView reloadData];
    }
}

#pragma mark - EaseMessageViewControllerDelegate

- (BOOL)messageViewController:(EaseMessageViewController *)viewController
   canLongPressRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)messageViewController:(EaseMessageViewController *)viewController
   didLongPressRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [self.dataArray objectAtIndex:indexPath.row];
    if (![object isKindOfClass:[NSString class]]) {
        EaseMessageCell *cell = (EaseMessageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [cell becomeFirstResponder];
        self.menuIndexPath = indexPath;
        [self _showMenuViewController:cell.bubbleView andIndexPath:indexPath messageType:cell.model.bodyType];
    }
    return YES;
}

- (UITableViewCell *)messageViewController:(UITableView *)tableView cellForMessageModel:(id<IMessageModel>)model
{
    if (model.bodyType == eMessageBodyType_Text) {
        NSString *CellIdentifier = [CustomMessageCell cellIdentifierWithModel:model];
        //发送cell
        CustomMessageCell *sendCell = (CustomMessageCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        // Configure the cell...
        if (sendCell == nil) {
            sendCell = [[CustomMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier model:model];
            sendCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }

        sendCell.model = model;
        return sendCell;
    }
    return nil;
}


- (CGFloat)messageViewController:(EaseMessageViewController *)viewController
           heightForMessageModel:(id<IMessageModel>)messageModel
                   withCellWidth:(CGFloat)cellWidth
{
    if (messageModel.bodyType == eMessageBodyType_Text) {
        return [CustomMessageCell cellHeightWithModel:messageModel];
    }
    return 0.f;
}

- (BOOL)messageViewController:(EaseMessageViewController *)viewController didSelectMessageModel:(id<IMessageModel>)messageModel
{
    BOOL flag = NO;
    return flag;
}

- (void)messageViewController:(EaseMessageViewController *)viewController
   didSelectAvatarMessageModel:(id<IMessageModel>)messageModel
{
//    UserProfileViewController *userprofile = [[UserProfileViewController alloc] initWithUsername:messageModel.nickname];
//    [self.navigationController pushViewController:userprofile animated:YES];
}


- (void)messageViewController:(EaseMessageViewController *)viewController
            didSelectMoreView:(EaseChatBarMoreView *)moreView
                      AtIndex:(NSInteger)index
{
    // 隐藏键盘
    [self.chatToolbar endEditing:YES];
}

- (void)messageViewController:(EaseMessageViewController *)viewController
          didSelectRecordView:(UIView *)recordView
                 withEvenType:(EaseRecordViewType)type
{
    switch (type) {
        case EaseRecordViewTypeTouchDown:
        {
            if ([self.recordView isKindOfClass:[EaseRecordView class]]) {
                [(EaseRecordView *)self.recordView  recordButtonTouchDown];
            }
        }
            break;
        case EaseRecordViewTypeTouchUpInside:
        {
            if ([self.recordView isKindOfClass:[EaseRecordView class]]) {
                [(EaseRecordView *)self.recordView recordButtonTouchUpInside];
            }
            [self.recordView removeFromSuperview];
        }
            break;
        case EaseRecordViewTypeTouchUpOutside:
        {
            if ([self.recordView isKindOfClass:[EaseRecordView class]]) {
                [(EaseRecordView *)self.recordView recordButtonTouchUpOutside];
            }
            [self.recordView removeFromSuperview];
        }
            break;
        case EaseRecordViewTypeDragInside:
        {
            if ([self.recordView isKindOfClass:[EaseRecordView class]]) {
                [(EaseRecordView *)self.recordView recordButtonDragInside];
            }
        }
            break;
        case EaseRecordViewTypeDragOutside:
        {
            if ([self.recordView isKindOfClass:[EaseRecordView class]]) {
                [(EaseRecordView *)self.recordView recordButtonDragOutside];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - EaseMessageViewControllerDataSource

- (id<IMessageModel>)messageViewController:(EaseMessageViewController *)viewController
                           modelForMessage:(EMMessage *)message
{
    //用户可以根据自己的用户体系,根据message设置用户昵称和头像
    id<IMessageModel> model = nil;
    model = [[EaseMessageModel alloc] initWithMessage:message];
    model.avatarImage = [UIImage imageNamed:@"patient_head"];//默认头像
    
    if (message.messageType == eMessageTypeChat) {
        if (model.isSender) {
            model.avatarURLPath = [[AccountManager shareInstance] currentUser].img;//头像网络地址
            model.nickname = [[AccountManager shareInstance] currentUser].name;//用户昵称
        }else{
            Patient *patient = [[DBManager shareInstance] getPatientWithPatientCkeyid:message.from];
            if (patient != nil) {
                model.nickname = patient.patient_name;
            }
        }
    }else if (message.messageType == eMessageTypeGroupChat){
        if (model.isSender) {
            model.avatarURLPath = [[AccountManager shareInstance] currentUser].img;//头像网络地址
            model.nickname = [[AccountManager shareInstance] currentUser].name;//用户昵称
        }else {
            Doctor *doc = [[DBManager shareInstance] getDoctorWithCkeyId:message.groupSenderName];
            if (doc != nil) {
                model.avatarURLPath = doc.doctor_image;
                model.nickname = doc.doctor_name;
            }
        }
    }
    return model;
}

#pragma mark - EaseMobSendAction
- (void)sendImageMessage:(UIImage *)image{
    [super sendImageMessage:image];
}

- (void)sendVoiceMessageWithLocalPath:(NSString *)localPath duration:(NSInteger)duration{
    [super sendVoiceMessageWithLocalPath:localPath duration:duration];
}

- (void)sendTextMessage:(NSString *)text{
    //发送文字
    if (!self.isBind) {
        [SysMessageTool sendMessageWithDoctorId:[AccountManager currentUserid] patientId:self.conversation.chatter isWeixin:NO isSms:YES txtContent:text success:^(CRMHttpRespondModel *respond) {
            if ([respond.code integerValue] == 200) {
                [SVProgressHUD showImage:nil status:@"信息发送成功,患者将收到短信提醒"];   
            }
        } failure:^(NSError *error) {
            [SVProgressHUD showImage:nil status:error.localizedDescription];
            if (error) {
                NSLog(@"error:%@",error);
            }
        }];
    }
    [super sendTextMessage:text];
}


#pragma mark - EMChatManagerLoginDelegate
- (void)didLoginFromOtherDevice
{
    if ([self.imagePicker.mediaTypes count] > 0 && [[self.imagePicker.mediaTypes objectAtIndex:0] isEqualToString:(NSString *)kUTTypeMovie]) {
        [self.imagePicker stopVideoCapture];
    }
    [self easeMobIsLogin];
}

- (void)didRemovedFromServer
{
    if ([self.imagePicker.mediaTypes count] > 0 && [[self.imagePicker.mediaTypes objectAtIndex:0] isEqualToString:(NSString *)kUTTypeMovie]) {
        [self.imagePicker stopVideoCapture];
    }
}

- (void)didAutoReconnectFinishedWithError:(NSError *)error{
    if (error == nil) {
        [self hideTintLabel];
    }
}

#pragma mark - action

- (void)backAction
{
    if (self.deleteConversationIfNull) {
        //判断当前会话是否为空，若符合则删除该会话
        EMMessage *message = [self.conversation latestMessage];
        if (message == nil) {
            [[EaseMob sharedInstance].chatManager removeConversationByChatter:self.conversation.chatter deleteMessages:NO append2Chat:YES];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showGroupDetailAction
{
    [self.view endEditing:YES];
    //查看群组成员
    XLTreateGroupViewController *groupMemberVc = [[XLTreateGroupViewController alloc] initWithStyle:UITableViewStylePlain];
    groupMemberVc.mCase = self.mCase;
    [self.navigationController pushViewController:groupMemberVc animated:YES];
    
}
#pragma mark - 消息记录
- (void)deleteAllMessages:(id)sender
{
    NSLog(@"消息记录");
    Patient *patient = [[DBManager shareInstance] getPatientCkeyid:self.conversation.chatter];
    XLChatRecordViewController *recordVc = [[XLChatRecordViewController alloc] init];
    recordVc.title = [NSString stringWithFormat:@"%@的消息记录",patient.patient_name];
    recordVc.patient = patient;
    recordVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:recordVc animated:YES];
}

- (void)transpondMenuAction:(id)sender
{
    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
//        id<IMessageModel> model = [self.dataArray objectAtIndex:self.menuIndexPath.row];
//        ContactListSelectViewController *listViewController = [[ContactListSelectViewController alloc] initWithNibName:nil bundle:nil];
//        listViewController.messageModel = model;
//        [listViewController tableViewDidTriggerHeaderRefresh];
//        [self.navigationController pushViewController:listViewController animated:YES];
    }
    self.menuIndexPath = nil;
}

- (void)copyMenuAction:(id)sender
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
        id<IMessageModel> model = [self.dataArray objectAtIndex:self.menuIndexPath.row];
        pasteboard.string = model.text;
    }
    
    self.menuIndexPath = nil;
}

- (void)deleteMenuAction:(id)sender
{
    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
        id<IMessageModel> model = [self.dataArray objectAtIndex:self.menuIndexPath.row];
        NSMutableIndexSet *indexs = [NSMutableIndexSet indexSetWithIndex:self.menuIndexPath.row];
        NSMutableArray *indexPaths = [NSMutableArray arrayWithObjects:self.menuIndexPath, nil];
        
        [self.conversation removeMessage:model.message];
        [self.messsagesSource removeObject:model.message];
        
        if (self.menuIndexPath.row - 1 >= 0) {
            id nextMessage = nil;
            id prevMessage = [self.dataArray objectAtIndex:(self.menuIndexPath.row - 1)];
            if (self.menuIndexPath.row + 1 < [self.dataArray count]) {
                nextMessage = [self.dataArray objectAtIndex:(self.menuIndexPath.row + 1)];
            }
            if ((!nextMessage || [nextMessage isKindOfClass:[NSString class]]) && [prevMessage isKindOfClass:[NSString class]]) {
                [indexs addIndex:self.menuIndexPath.row - 1];
                [indexPaths addObject:[NSIndexPath indexPathForRow:(self.menuIndexPath.row - 1) inSection:0]];
            }
        }
        
        [self.dataArray removeObjectsAtIndexes:indexs];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
    
    self.menuIndexPath = nil;
}

#pragma mark - notification
- (void)exitGroup
{
    [self.navigationController popToViewController:self animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)insertCallMessage:(NSNotification *)notification
{
    id object = notification.object;
    if (object) {
        EMMessage *message = (EMMessage *)object;
        [self addMessageToDataSource:message progress:nil];
        [[EaseMob sharedInstance].chatManager insertMessageToDB:message append2Chat:YES];
    }
}

- (void)handleCallNotification:(NSNotification *)notification
{
    id object = notification.object;
    if ([object isKindOfClass:[NSDictionary class]]) {
        //开始call
        self.isViewDidAppear = NO;
    } else {
        //结束call
        self.isViewDidAppear = YES;
    }
}

#pragma mark - private

- (void)_showMenuViewController:(UIView *)showInView
                   andIndexPath:(NSIndexPath *)indexPath
                    messageType:(MessageBodyType)messageType
{
    if (self.menuController == nil) {
        self.menuController = [UIMenuController sharedMenuController];
    }
    
    if (_deleteMenuItem == nil) {
        _deleteMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"delete", @"Delete") action:@selector(deleteMenuAction:)];
    }
    
    if (_copyMenuItem == nil) {
        _copyMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"copy", @"Copy") action:@selector(copyMenuAction:)];
    }
    if (messageType == eMessageBodyType_Text) {
        [self.menuController setMenuItems:@[_copyMenuItem, _deleteMenuItem]];
    } else if (messageType == eMessageBodyType_Image){
        [self.menuController setMenuItems:@[_deleteMenuItem]];
    } else {
        [self.menuController setMenuItems:@[_deleteMenuItem]];
    }
    [self.menuController setTargetRect:showInView.frame inView:showInView.superview];
    [self.menuController setMenuVisible:YES animated:YES];
}

#pragma mark - 发送消息后的回调
- (void)didSendMessage:(EMMessage *)message error:(EMError *)error{
    if (![self.conversation.chatter isEqualToString:message.conversationChatter]){
        return;
    }
    
    __block id<IMessageModel> model = nil;
    __block BOOL isHave = NO;
    [self.dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         if ([obj conformsToProtocol:@protocol(IMessageModel)])
         {
             model = (id<IMessageModel>)obj;
             if ([model.messageId isEqualToString:message.messageId])
             {
                 model.message.deliveryState = message.deliveryState;
                 isHave = YES;
                 *stop = YES;
             }
         }
     }];
    
    if(!isHave){
        return;
    }

    if (error) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(messageViewController:didFailSendingMessageModel:error:)]) {
            [self.delegate messageViewController:self didFailSendingMessageModel:model error:error];
        }
        else{
            [self.tableView reloadData];
        }
    }
    else{
        Patient *patient = [[DBManager shareInstance] getPatientCkeyid:self.conversation.chatter];
        NSString *patientName = patient == nil ? @"" : patient.patient_name;
        //获取回调消息中的消息体
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        NSString *type;
        id body = message.messageBodies[0];
        if ([body isKindOfClass:[EMTextMessageBody class]]) {
            EMTextMessageBody *textBody = (EMTextMessageBody *)body;
            NSLog(@"EMTextMessageBody%@",textBody.text);
            type = @"text";
            //发送微信消息
            [SysMessageTool sendHuanXiMessageToPatientWithPatientId:self.conversation.chatter contentType:type sendContent:textBody.text doctorId:[AccountManager currentUserid] success:nil failure:nil];
            //保存聊天记录
            XLChatModel *chatModel = [[XLChatModel alloc] initWithReceiverId:self.conversation.chatter receiverName:patientName content:textBody.text];
            [DoctorTool addNewChatRecordWithChatModel:chatModel success:nil failure:nil];
            
        }else if ([body isKindOfClass:[EMVoiceMessageBody class]]){
            EMVoiceMessageBody *voiceBody = (EMVoiceMessageBody *)body;
            NSLog(@"EMVoiceMessageBody%@",voiceBody.secretKey);
            type = @"audio";
            params[@"secret"] = voiceBody.secretKey;
            params[@"url"] = voiceBody.remotePath;
            params[@"suffix"] = [voiceBody.localPath componentsSeparatedByString:@"."][1];
            
            //发送微信消息
            [SysMessageTool sendHuanXiMessageToPatientWithPatientId:self.conversation.chatter contentType:type sendContent:[params JSONString] doctorId:[AccountManager currentUserid] success:nil failure:nil];
            //保存聊天记录
            XLChatModel *chatModel = [[XLChatModel alloc] initWithReceiverId:self.conversation.chatter receiverName:patientName content:voiceBody.remotePath duration:@(voiceBody.duration) secret:voiceBody.secretKey];
            [DoctorTool addNewChatRecordWithChatModel:chatModel success:nil failure:nil];
            
        }else if ([body isKindOfClass:[EMImageMessageBody class]]){
            EMImageMessageBody *imageBody = (EMImageMessageBody *)body;
            NSLog(@"EMImageMessageBody%@",imageBody.secretKey);
            type = @"img";
            params[@"secret"] = imageBody.secretKey;
            params[@"url"] = imageBody.remotePath;
            params[@"suffix"] = [imageBody.localPath componentsSeparatedByString:@"."][1];
            
            //调用接口把信息存到数据库
            [SysMessageTool sendHuanXiMessageToPatientWithPatientId:self.conversation.chatter contentType:type sendContent:[params JSONString] doctorId:[AccountManager currentUserid] success:nil failure:nil];
            //保存聊天记录
            XLChatModel *chatModel = [[XLChatModel alloc] initWithReceiverId:self.conversation.chatter receiverName:patientName content:imageBody.remotePath secret:imageBody.secretKey thumb:imageBody.thumbnailRemotePath thumbSecret:imageBody.thumbnailSecretKey];
            [DoctorTool addNewChatRecordWithChatModel:chatModel success:nil failure:nil];
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(messageViewController:didSendMessageModel:)]) {
            [self.delegate messageViewController:self didSendMessageModel:model];
        }
        else{
            [self.tableView reloadData];
        }
    }
}


#pragma mark - EaseChatBarMoreViewDelegate
- (void)moreViewPhotoAction:(EaseChatBarMoreView *)moreView
{
    //选择照片
    // 隐藏键盘
    [self.chatToolbar endEditing:YES];
    
    if (!self.isBind) {
        [SVProgressHUD showImage:nil status:@"患者关联微信后才能发送"];
        return;
    }
    // 弹出照片选择
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    [self presentViewController:self.imagePicker animated:YES completion:NULL];
    
    self.isViewDidAppear = NO;
    [[EaseSDKHelper shareHelper] setIsShowingimagePicker:YES];
}

- (void)moreViewTakePicAction:(EaseChatBarMoreView *)moreView
{
    //医嘱
    NSLog(@"医嘱");
    // 隐藏键盘
    [self.chatToolbar endEditing:YES];
    XLAdviceSelectViewController *selectVc = [[XLAdviceSelectViewController alloc] init];
    selectVc.delegate = self;
    selectVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:selectVc animated:YES];
}


- (void)moreViewLocationAction:(EaseChatBarMoreView *)moreView
{
    //拍照
    // 隐藏键盘
    [self.chatToolbar endEditing:YES];
    
    if (!self.isBind) {
        [SVProgressHUD showImage:nil status:@"患者关联微信后才能发送"];
        return;
    }
    
#if TARGET_IPHONE_SIMULATOR
    [self showHint:NSLocalizedString(@"message.simulatorNotSupportCamera", @"simulator does not support taking picture")];
#elif TARGET_OS_IPHONE
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage,(NSString *)kUTTypeMovie];
    [self presentViewController:self.imagePicker animated:YES completion:NULL];
    
    self.isViewDidAppear = NO;
    [[EaseSDKHelper shareHelper] setIsShowingimagePicker:YES];
#endif
}

- (void)moreViewAudioCallAction:(EaseChatBarMoreView *)moreView
{
    //随访
    NSLog(@"随访");
    // 隐藏键盘
    [self.chatToolbar endEditing:YES];
    Patient *patient = [[DBManager shareInstance] getPatientCkeyid:self.conversation.chatter];
    if(![NSString isEmptyString:patient.patient_phone]){
        TimAlertView *alertView = [[TimAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"拨打电话:%@？",patient.patient_phone] cancelHandler:^{
        } comfirmButtonHandlder:^{
            NSString *number = patient.patient_phone;
            NSString *num = [[NSString alloc]initWithFormat:@"tel://%@",number];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
        }];
        [alertView show];
    }else{
        [SVProgressHUD showImage:nil status:@"患者未留电话"];
    }
}

- (void)moreViewVideoCallAction:(EaseChatBarMoreView *)moreView{
    //患教
    NSLog(@"患教");
    
    XLPatientEducationViewController *eduVc = [[XLPatientEducationViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:eduVc animated:YES];
}

#pragma mark - XLAdviceSelectViewControllerDelegate
- (void)adviceSelectViewController:(XLAdviceSelectViewController *)adviceSelectVc didSelectAdviceContent:(NSString *)adviceContent{
    EaseChatToolbar *toolBar = (EaseChatToolbar *)self.chatToolbar;
    [toolBar.inputTextView becomeFirstResponder];
    [toolBar.inputTextView setText:adviceContent];
    [toolBar changeInputViewFrame];
}

#pragma mark - 判断当前环信是否正常登录
- (void)easeMobIsLogin{
    WS(weakSelf);
    BOOL isConnect = [[EaseMob sharedInstance].chatManager isConnected];
    if (isConnect) {
    }else{
        TimAlertView *alertView = [[TimAlertView alloc] initWithTitle:@"提示" message:@"当前账号已在其它设备登录，是否重新登录？" cancel:@"取消" certain:@"确定" cancelHandler:^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } comfirmButtonHandlder:^{
            //判断当前是否保存密码
            NSString *userName = [CRMUserDefalut objectForKey:LatestUserID];
            NSString *password = [CRMUserDefalut objectForKey:LatestUserPassword];
            if (password == nil) {
                //直接退出当前应用
                [[AccountManager shareInstance] logout];
            }else{
                //重新登录环信
                [SVProgressHUD showWithStatus:@"正在登录环信"];
                [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:userName password:password completion:^(NSDictionary *loginInfo, EMError *error) {
                    if (loginInfo && !error) {
                        [SVProgressHUD showImage:nil status:@"登录成功"];
                        //设置是否自动登录
                        [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
                        //发送自动登陆状态通知
                        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
                    }else{
                        [SVProgressHUD showImage:nil status:error.description];
                    }
                } onQueue:nil];
            }
        }];
        [alertView show];
    }
}

#pragma mark - 获取患者是否绑定微信信息
- (void)getPaitientIsBind{
    //获取患者绑定微信的状态
    WS(weakSelf);
    [MyPatientTool getWeixinStatusWithPatientId:self.conversation.chatter success:^(CRMHttpRespondModel *respondModel) {
        if ([respondModel.result isEqualToString:@"1"]) {
            //绑定
            [weakSelf hideTintLabel];
            self.isBind = YES;
        }else{
            [weakSelf showTintLabelWithText:@"患者尚未关联微信,关联后可收到患者回复 >>"];
            self.isBind = NO;
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD showImage:nil status:error.localizedDescription];
        //未绑定
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}

#pragma mark - 未绑定微信
- (UILabel *)tintLabel{
    if (!_tintLabel) {
        _tintLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -30, kScreenWidth, 30)];
        _tintLabel.font = [UIFont systemFontOfSize:13];
        _tintLabel.textColor = [UIColor colorWithHex:0xf27e00];
        _tintLabel.backgroundColor = [UIColor colorWithHex:0xfff2b7];
        _tintLabel.textAlignment = NSTextAlignmentCenter;
        _tintLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [_tintLabel addGestureRecognizer:tap];
        [self.view addSubview:_tintLabel];
    }
    return _tintLabel;
}

- (void)showTintLabelWithText:(NSString *)text{
    if (_tintLabel == nil) {
        [self tintLabel];
        _tintLabel.text = text;
        WS(weakSelf);
        [UIView animateWithDuration:.35 animations:^{
            weakSelf.tintLabel.transform = CGAffineTransformMakeTranslation(0, 30);
        }];
    }
}

- (void)hideTintLabel{
    WS(weakSelf);
    [UIView animateWithDuration:.35 animations:^{
        weakSelf.tintLabel.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [_tintLabel removeFromSuperview];
        _tintLabel = nil;
    }];
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    QrCodeViewController *qrVC = [storyBoard instantiateViewControllerWithIdentifier:@"QrCodeViewController"];
    qrVC.patientId = self.conversation.chatter;
    [self.navigationController pushViewController:qrVC animated:YES];
}
@end
