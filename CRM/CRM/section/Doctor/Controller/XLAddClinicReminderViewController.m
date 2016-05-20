//
//  XLAddClinicReminderViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/5/17.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLAddClinicReminderViewController.h"
#import "XLPatientSelectViewController.h"
#import "XLHengYaViewController.h"
#import "XLRuYaViewController.h"
#import "XLReserveTypesViewController.h"
#import "EditAllergyViewController.h"
#import "ChooseAssistViewController.h"
#import "ChooseMaterialViewController.h"
#import "ZYQAssetPickerController.h"
#import "UIImage+TTMAddtion.h"
#import "LocalNotificationCenter.h"
#import "MaterialCountModel.h"
#import "AssistCountModel.h"
#import "DBTableMode.h"
#import "XLClinicAppointmentModel.h"
#import "MyPatientTool.h"
#import "CRMHttpRespondModel.h"
#import "MaterialModel.h"
#import "AssistModel.h"
#import "XLAppointImageUploadParam.h"
#import "DoctorTool.h"
#import "SysMessageTool.h"
#import "XLCustomAlertView.h"
#import "XLChatModel.h"
#import "DBManager+Patients.h"

#define Margin 10
#define ImageWidth 60

@interface XLAddClinicReminderViewController ()<XLHengYaDeleate,XLRuYaDelegate,XLReserveTypesViewControllerDelegate,EditAllergyViewControllerDelegate,ChooseAssistViewControllerDelegate,ChooseMaterialViewControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,ZYQAssetPickerControllerDelegate>{
    CGFloat _billImageHeight;
    CGFloat _ctImageHeight;
}
@property (weak, nonatomic) IBOutlet UILabel *patientNameLabel; //患者姓名
@property (weak, nonatomic) IBOutlet UILabel *toothPositionLabel;//牙位
@property (weak, nonatomic) IBOutlet UILabel *reserveTypeLabel;//预约事项
@property (weak, nonatomic) IBOutlet UILabel *materialLabel;   //耗材
@property (weak, nonatomic) IBOutlet UILabel *assistentLabel;  //助手
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;     //备注
@property (weak, nonatomic) IBOutlet UIView *checkBillImagesSupView; //术前检查单
@property (weak, nonatomic) IBOutlet UIView *ctImagesSupView;//ct图片

@property (nonatomic,strong) XLHengYaViewController *hengYaVC;//恒牙
@property (nonatomic,strong) XLRuYaViewController *ruYaVC;//乳牙


@property (nonatomic, strong)NSMutableArray *billImages;//术前检查单缩略图片
@property (nonatomic, strong)NSMutableArray *ctImages;//ct缩略图片
@property (nonatomic, strong)NSMutableArray *needUploadImages;//所有需要上传的图片模型


@property (nonatomic, strong)NSArray *chooseMaterials;//选中的耗材
@property (nonatomic, strong)NSArray *chooseAssists;//选中的助手
@property (nonatomic, strong)LocalNotification *currentNoti;//当前预约

@property (nonatomic, assign)BOOL isCtImage;//是否是选择CT图片
@property (nonatomic, assign)BOOL isBind;//是否绑定微信

@end

@implementation XLAddClinicReminderViewController
#pragma mark - ********************* Life Method ***********************
- (void)viewDidLoad{
    [super viewDidLoad];
    
    //设置子视图
    [self setUpViews];
    
    //计算图片视图的高度
    [self calculateImageViewsHeightAll:YES];
}

- (void)dealloc{
    [LocalNotificationCenter shareInstance].selectPatient = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //导航栏透明
    self.navigationController.navigationBar.translucent = YES;
    [self setUpData];
}

#pragma mark - ********************* Private Method ***********************
- (void)setUpViews{
    self.title = @"添加预约";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    [self setRightBarButtonWithTitle:@"保存"];
}
#pragma mark 加载数据
- (void)setUpData{
    NSString *patientId;
    if (self.patient) {
        self.patientNameLabel.text = self.patient.patient_name;
        patientId = self.patient.ckeyid;
    }else{
        self.patientNameLabel.text = [LocalNotificationCenter shareInstance].selectPatient.patient_name;
        patientId = [LocalNotificationCenter shareInstance].selectPatient.ckeyid;
    }
    //获取患者的微信绑定状态
    [MyPatientTool getWeixinStatusWithPatientId:patientId success:^(CRMHttpRespondModel *respondModel) {
        if ([respondModel.result isEqualToString:@"1"]) {
            //绑定
            self.isBind = YES;
        }else{
            //未绑定
            self.isBind = NO;
        }
        
    } failure:^(NSError *error) {
        self.isBind = NO;
        //未绑定
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}
#pragma mark  保存按钮点击
- (void)onRightButtonAction:(id)sender{
    if ([self.patientNameLabel.text isEmpty]) {
        [SVProgressHUD showImage:nil status:@"请选择患者"];
        return;
    }
    if ([self.reserveTypeLabel.text isEmpty]) {
        [SVProgressHUD showImage:nil status:@"请选择预约事项"];
        return;
    }
    
    LocalNotification *notification = [[LocalNotification alloc] init];
    notification.reserve_time = self.appointModel.appointTime;
    notification.reserve_type = self.reserveTypeLabel.text;
    notification.medical_place = self.appointModel.clinicName;
    notification.medical_chair = self.appointModel.seatId;
    notification.update_date = [NSString defaultDateString];
    notification.reserve_content = self.remarkLabel.text;
    notification.case_id = @"";
    
    notification.selected = YES;
    notification.tooth_position = self.toothPositionLabel.text;
    notification.clinic_reserve_id = @"0";
    notification.duration = [NSString stringWithFormat:@"%.1f",self.appointModel.duration];
    notification.reserve_status = @"0";
    notification.therapy_doctor_id = [AccountManager currentUserid];
    notification.therapy_doctor_name = [[AccountManager shareInstance] currentUser].name;
    
    if (self.patient) {
        notification.patient_id = self.patient.ckeyid;
    }else{
        notification.patient_id = [LocalNotificationCenter shareInstance].selectPatient.ckeyid;
    }
    self.currentNoti = notification;
    
    //计算总的money
    float totalMoney = self.appointModel.seatPrice;
    //获取耗材的数组
    NSMutableArray *materialsArr = [NSMutableArray array];
    if (self.chooseMaterials.count > 0) {
        for (MaterialCountModel *countModel in self.chooseMaterials) {
            MaterialModel *material = [MaterialModel modelWithMaterialCountModel:countModel];
            
            [materialsArr addObject:material.keyValues];
            totalMoney = totalMoney + [material.actual_money floatValue];
        }
    }
    //获取助手的数组
    NSMutableArray *assistsArr = [NSMutableArray array];
    if (self.chooseAssists.count > 0) {
        for (AssistCountModel *countModel in self.chooseAssists) {
            AssistModel *assist = [AssistModel modelWithAssistCountModel:countModel];
            [assistsArr addObject:assist.keyValues];
            totalMoney = totalMoney + [assist.actual_money floatValue];
        }
    }
    //保存预约
    WS(weakSelf);
    [SVProgressHUD showWithStatus:@"正在保存预约"];
    [MyPatientTool postAppointInfoTuiSongClinic:notification.patient_id withClinicName:self.appointModel.clinicName withCliniId:self.appointModel.clinicId withDoctorId:[AccountManager currentUserid] withAppointTime:self.appointModel.appointTime withDuration:self.appointModel.duration withSeatPrice:self.appointModel.seatPrice withAppointMoney:totalMoney withAppointType:notification.reserve_type withSeatId:self.appointModel.seatId withToothPosition:notification.tooth_position withAssist:assistsArr withMaterial:materialsArr success:^(CRMHttpRespondModel *respondModel) {
        
        if ([respondModel.code integerValue] == 200 || [respondModel.code integerValue] == 203) {
            //预约保存成功
            notification.clinic_reserve_id = respondModel.result;
            [[LocalNotificationCenter shareInstance] addLocalNotification:notification];
            //上传图片
            [weakSelf uploadAllImagesWithReserveId:notification.clinic_reserve_id];
            
        }else{
            [SVProgressHUD showErrorWithStatus:@"预约失败"];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD showImage:nil status:error.localizedDescription];
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}

#pragma mark 上传所有图片
- (void)uploadAllImagesWithReserveId:(NSString *)reserveId{
    if (self.needUploadImages.count > 0) {
        WS(weakSelf);
        __block NSInteger failCount = self.needUploadImages.count;
        for (XLAppointImageUploadParam *param in self.needUploadImages) {
            param.reserver_id = reserveId;
            [MyPatientTool uploadAppointmentImageWithParam:param imageData:param.imageData success:^(CRMHttpRespondModel *respondModel) {
                failCount--;
                if (failCount == 0) {
                    [SVProgressHUD showImage:nil status:@"保存成功"];
                    [weakSelf getMessageToPatient];
                }
            } failure:^(NSError *error) {
                failCount--;
                if (failCount == 0) {
                    [SVProgressHUD showImage:nil status:@"保存成功"];
                    [weakSelf getMessageToPatient];
                }
                if (error) {
                    NSLog(@"error:%@",error);
                }
            }];
        }
    }
}
#pragma mark 获取发送给患者的消息内容
- (void)getMessageToPatient{
    WS(weakSelf);
    Patient *patientTmp = [[DBManager shareInstance] getPatientWithPatientCkeyid:self.currentNoti.patient_id];
    [self sendMessageWithNoti:self.currentNoti cancel:^{
        [weakSelf popToSuperController];
    } certain:^(NSString *content, BOOL wenxinSend, BOOL messageSend) {
        [SVProgressHUD showWithStatus:@"正在发送消息"];
        [SysMessageTool sendMessageWithDoctorId:[AccountManager currentUserid] patientId:weakSelf.currentNoti.patient_id isWeixin:wenxinSend isSms:messageSend txtContent:content success:^(CRMHttpRespondModel *respond) {
            if ([respond.code integerValue] == 200) {
                [SVProgressHUD showImage:nil status:@"消息发送成功"];
                //将消息保存在消息记录里
                [weakSelf savaMessageToChatRecordWithPatient:patientTmp message:content];
            }else{
                [SVProgressHUD showImage:nil status:@"消息发送失败"];
            }
            
            [weakSelf popToSuperController];
        } failure:^(NSError *error) {
            [SVProgressHUD showImage:nil status:@"消息发送失败"];
            [weakSelf popToSuperController];
            if (error) {
                NSLog(@"error:%@",error);
            }
        }];
    }];
}
#pragma mark 将消息保存到消息记录里
- (void)savaMessageToChatRecordWithPatient:(Patient *)patient message:(NSString *)message{
    //将消息保存在消息记录里
    XLChatModel *chatModel = [[XLChatModel alloc] initWithReceiverId:patient.ckeyid receiverName:patient.patient_name content:message];
    [DoctorTool addNewChatRecordWithChatModel:chatModel success:nil failure:nil];
    //发送环信消息
    [EaseSDKHelper sendTextMessage:message
                                to:patient.ckeyid
                       messageType:eMessageTypeChat
                 requireEncryption:NO
                        messageExt:nil];
}

#pragma mark 返回上一个页面
- (void)popToSuperController{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self popViewControllerAnimated:YES];
    });
}

#pragma mark 发送消息
- (void)sendMessageWithNoti:(LocalNotification *)noti cancel:(void(^)())cancel certain:(void(^)(NSString *content, BOOL wenxinSend, BOOL messageSend))certain{
    
    [DoctorTool yuYueMessagePatient:noti.patient_id fromDoctor:[AccountManager currentUserid] withMessageType:self.reserveTypeLabel.text withSendType:@"0" withSendTime:self.appointModel.appointTime success:^(CRMHttpRespondModel *result) {
        
        XLCustomAlertView *alertView = [[XLCustomAlertView alloc] initWithTitle:@"提醒患者" message:result.result Cancel:@"不发送" certain:@"发送" weixinEnalbe:self.isBind type:CustonAlertViewTypeCheck cancelHandler:^{
            if (cancel) {
                cancel();
            }
        } certainHandler:^(NSString *content, BOOL wenxinSend, BOOL messageSend) {
            if (certain) {
                certain(content,wenxinSend,messageSend);
            }
        }];
        [alertView show];
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"提醒内容获取失败，请检查网络设置"];
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}

#pragma mark 计算图片视图的高度
- (void)calculateImageViewsHeightAll:(BOOL)all{
    if (all) {
        _ctImageHeight = [self imagesViewHeightWithImagesArray:self.ctImages superView:self.ctImagesSupView];
        _billImageHeight = [self imagesViewHeightWithImagesArray:self.billImages superView:self.checkBillImagesSupView];
    }else{
        if (self.isCtImage) {
            _ctImageHeight = [self imagesViewHeightWithImagesArray:self.ctImages superView:self.ctImagesSupView];
        }else{
            _billImageHeight = [self imagesViewHeightWithImagesArray:self.billImages superView:self.checkBillImagesSupView];
        }
    }
    
}

#pragma mark -计算当前一行能显示多少张图片
- (CGFloat)imagesViewHeightWithImagesArray:(NSArray *)images superView:(UIView *)superView{
    
    if (images.count == 0) {
        superView.hidden = YES;
        return 44;
    }
    superView.hidden = NO;
    //计算一行显示几张图片
    NSInteger count = (kScreenWidth - Margin) / (ImageWidth + Margin);
    //计算总共有几行
    NSInteger rows = 0;
    if (images.count > count) {
        rows = images.count % count == 0 ? images.count / count : images.count / count + 1;
    }else{
        rows = 1;
    }
    
    //移除所有子视图
    NSLog(@"subViews:%@",superView.subviews);
    for (UIView *view in superView.subviews) {
        if([view isKindOfClass:[UIImageView class]]){
            [view removeFromSuperview];
        }
    }
    
    for (int i = 0; i < images.count; i++) {
        int index_x = i / count;
        int index_y = i % count;
        
        CGFloat imageX = Margin + (Margin + ImageWidth) * index_y;
        CGFloat imageY = Margin + (Margin + ImageWidth) * index_x;
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:images[i]];
        imageView.layer.cornerRadius = 5;
        imageView.layer.masksToBounds = YES;
        imageView.frame = CGRectMake(imageX, imageY, ImageWidth, ImageWidth);
        [superView addSubview:imageView];
    }
    
    return rows * (ImageWidth + Margin) + Margin + 44;
}

#pragma mark 从相册获取图片
- (void)getImageFromAlbumIsCtLib:(BOOL)isCtLib{
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = 9;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups = NO;
    picker.delegate = self;
    
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 5;
        } else {
            return YES;
        }
    }];
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark 拍照获取图片
- (void)getImageFromCameraIsCtLib:(BOOL)isCtLib{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:^{
    }];
}


#pragma mark - ******************* Delegate / DataSource ******************
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        return _billImageHeight;
    }else if (indexPath.section == 3){
        return _ctImageHeight;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                //选择患者
                XLPatientSelectViewController *patientSelectVc = [[XLPatientSelectViewController alloc] init];
                patientSelectVc.patientStatus = PatientStatuspeAll;
                patientSelectVc.isYuYuePush = YES;
                patientSelectVc.hidesBottomBarWhenPushed = YES;
                [self pushViewController:patientSelectVc animated:YES];
            }else if (indexPath.row == 1){
                //选择牙位
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
                self.hengYaVC = [storyboard instantiateViewControllerWithIdentifier:@"XLHengYaViewController"];
                self.hengYaVC.delegate = self;
                self.hengYaVC.hengYaString = self.toothPositionLabel.text;
                [self.navigationController addChildViewController:self.hengYaVC];
                [self.navigationController.view addSubview:self.hengYaVC.view];
            }else{
                //选择预约事项
                XLReserveTypesViewController *reserceVC = [[XLReserveTypesViewController alloc] initWithStyle:UITableViewStylePlain];
                reserceVC.reserve_type = self.reserveTypeLabel.text;
                reserceVC.delegate = self;
                [self pushViewController:reserceVC animated:YES];
            }
            break;
        case 1:
            if (indexPath.row == 0) {
                //选择耗材
                ChooseMaterialViewController *materialVc = [[ChooseMaterialViewController alloc] init];
                materialVc.delegate = self;
                materialVc.clinicId = @"";
                materialVc.chooseMaterials = self.chooseMaterials;
                [self pushViewController:materialVc animated:YES];
            }else if (indexPath.row == 1){
                //选择助理
                ChooseAssistViewController *assistVc = [[ChooseAssistViewController alloc] init];
                assistVc.delegate = self;
                assistVc.clinicId = @"";
                assistVc.chooseAssists = self.chooseAssists;
                [self pushViewController:assistVc animated:YES];
            }else{
                //跳转到修改备注页面
                EditAllergyViewController *allergyVc = [[EditAllergyViewController alloc] init];
                allergyVc.title = @"备注";
                allergyVc.limit = 200;
                allergyVc.content = self.remarkLabel.text;
                allergyVc.type = EditAllergyViewControllerRemark;
                allergyVc.delegate = self;
                [self pushViewController:allergyVc animated:YES];
            }
            break;
        case 2:
        {
            //选择术前检查单图片
            UIActionSheet *actionsheet = [[UIActionSheet alloc]initWithTitle:@"添加术前检查单图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
            actionsheet.tag = 100;
            [actionsheet setActionSheetStyle:UIActionSheetStyleDefault];
            [actionsheet showInView:self.view];
        }
            break;
        case 3:
        {
            //选择CT片
            UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:@"添加CT片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
            actionsheet.tag = 200;
            [actionsheet setActionSheetStyle:UIActionSheetStyleDefault];
            [actionsheet showInView:self.view];
        }
            break;
    }
    
}

#pragma mark ChooseAssistViewControllerDelegate
- (void)chooseAssistViewController:(ChooseAssistViewController *)aController didSelectAssists:(NSArray *)assists{
    self.chooseAssists = assists;
    NSMutableString *str = [NSMutableString string];
    for (AssistCountModel *model in assists) {
        [str appendFormat:@"%@ x %ld,",model.assist_name,(long)model.num];
    }
    if (str.length > 0) {
        NSString *tempStr = [str substringToIndex:str.length - 1];
        self.assistentLabel.text = tempStr;
    }
}

#pragma mark ChooseMaterialViewControllerDelegate
- (void)chooseMaterialViewController:(ChooseMaterialViewController *)mController didSelectMaterials:(NSArray *)materials{
    self.chooseMaterials = materials;
    NSMutableString *str = [NSMutableString string];
    for (MaterialCountModel *model in materials) {
        [str appendFormat:@"%@ x %ld,",model.mat_name,(long)model.num];
    }
    if (str.length > 0) {
        NSString *tempStr = [str substringToIndex:str.length - 1];
        self.materialLabel.text = tempStr;
    }
}


#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex > 1) return;
    
    if (actionSheet.tag == 100) {
        self.isCtImage = NO;
        //选择术前检查单图片
        if (buttonIndex == 0) {
            [self getImageFromCameraIsCtLib:NO];
        }else{
            [self getImageFromAlbumIsCtLib:NO];
        }
        
    }else{
        self.isCtImage = YES;
        //选择CT片
        if (buttonIndex == 0) {
            [self getImageFromCameraIsCtLib:YES];
        }else{
            [self getImageFromAlbumIsCtLib:YES];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    WS(weakSelf);
    [picker dismissViewControllerAnimated:YES completion:^() {
        @autoreleasepool {
            //压缩图片
            UIImage *resultImage = [UIImage imageCompressForSize:[info objectForKey:UIImagePickerControllerOriginalImage] targetSize:CGSizeMake(60, 60)];
            
            if (weakSelf.isCtImage) {
                XLAppointImageUploadParam *param = [[XLAppointImageUploadParam alloc] initWithReserveId:@"" fileName:@"image" fileType:@"ct" imageData:UIImageJPEGRepresentation([info objectForKey:UIImagePickerControllerOriginalImage],0)];
                [weakSelf.ctImages addObject:resultImage];
                [weakSelf.needUploadImages addObject:param];
            }else{
                XLAppointImageUploadParam *param = [[XLAppointImageUploadParam alloc] initWithReserveId:@"" fileName:@"image" fileType:@"checklist" imageData:UIImageJPEGRepresentation([info objectForKey:UIImagePickerControllerOriginalImage],0)];
                [weakSelf.billImages addObject:resultImage];
                [weakSelf.needUploadImages addObject:param];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf calculateImageViewsHeightAll:NO];
                [weakSelf.tableView reloadData];
            });
        }
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - ZYQAssetPickerController Delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {
            if (weakSelf.isCtImage) {
                NSMutableArray *array = [NSMutableArray array];
                for (int i=0; i<assets.count; i++) {
                    ALAsset *asset=assets[i];
                    ALAssetRepresentation* representation = [asset defaultRepresentation];
                    [array addObject:[UIImage imageWithCGImage:asset.thumbnail]];
                    XLAppointImageUploadParam *param = [[XLAppointImageUploadParam alloc] initWithReserveId:@"" fileName:@"image" fileType:@"ct" imageData:UIImageJPEGRepresentation([UIImage imageWithCGImage:[representation fullScreenImage]],0)];
                    [weakSelf.needUploadImages addObject:param];
                }
                [weakSelf.ctImages addObjectsFromArray:array];
            }else {
                NSMutableArray *array = [NSMutableArray array];
                for (int i=0; i<assets.count; i++) {
                    ALAsset *asset=assets[i];
                    ALAssetRepresentation* representation = [asset defaultRepresentation];
                    [array addObject:[UIImage imageWithCGImage:asset.thumbnail]];
                    
                    XLAppointImageUploadParam *param = [[XLAppointImageUploadParam alloc] initWithReserveId:@"" fileName:@"image" fileType:@"checklist" imageData:UIImageJPEGRepresentation([UIImage imageWithCGImage:[representation fullScreenImage]],0)];
                    [weakSelf.needUploadImages addObject:param];
                }
                [weakSelf.billImages addObjectsFromArray:array];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf calculateImageViewsHeightAll:NO];
                [weakSelf.tableView reloadData];
            });
        }
    });
}

#pragma mark EditAllergyViewControllerDelegate
- (void)editViewController:(EditAllergyViewController *)editVc didEditWithContent:(NSString *)content type:(EditAllergyViewControllerType)type{
    
    if (content.length > 300) {
        [SVProgressHUD showImage:nil status:@"备注信息过长，请重新输入"];
        return;
    }
    self.remarkLabel.text = content;
}


#pragma mark XLReserveTypesViewControllerDelegate
- (void)reserveTypesViewController:(XLReserveTypesViewController *)vc didSelectReserveType:(NSString *)type{
    self.reserveTypeLabel.text = type;
}

#pragma mark HengYa And RuYa Deleate
-(void)removeHengYaVC{
    [self.hengYaVC willMoveToParentViewController:nil];
    [self.hengYaVC.view removeFromSuperview];
    [self.hengYaVC removeFromParentViewController];
}

- (void)queDingHengYa:(NSMutableArray *)hengYaArray toothStr:(NSString *)toothStr{
    
    if ([toothStr isEqualToString:@"未连续"]) {
        self.toothPositionLabel.text = [hengYaArray componentsJoinedByString:@","];
    }else{
        self.toothPositionLabel.text = toothStr;
    }
    
    [self removeHengYaVC];
}

- (void)queDingRuYa:(NSMutableArray *)ruYaArray toothStr:(NSString *)toothStr{
    if ([toothStr isEqualToString:@"未连续"]) {
        self.toothPositionLabel.text = [ruYaArray componentsJoinedByString:@","];
    }else{
        self.toothPositionLabel.text = toothStr;
    }
    [self removeRuYaVC];
}

-(void)removeRuYaVC{
    [self.ruYaVC willMoveToParentViewController:nil];
    [self.ruYaVC.view removeFromSuperview];
    [self.ruYaVC removeFromParentViewController];
}
-(void)changeToRuYaVC{
    [self removeHengYaVC];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    self.ruYaVC = [storyboard instantiateViewControllerWithIdentifier:@"XLRuYaViewController"];
    self.ruYaVC.delegate = self;
    self.ruYaVC.ruYaString = self.toothPositionLabel.text;
    [self.navigationController addChildViewController:self.ruYaVC];
    [self.navigationController.view addSubview:self.ruYaVC.view];
}
-(void)changeToHengYaVC{
    [self removeRuYaVC];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    self.hengYaVC = [storyboard instantiateViewControllerWithIdentifier:@"XLHengYaViewController"];
    self.hengYaVC.delegate = self;
    self.hengYaVC.hengYaString = self.toothPositionLabel.text;
    [self.navigationController addChildViewController:self.hengYaVC];
    [self.navigationController.view addSubview:self.hengYaVC.view];
}

#pragma mark - ********************* Lazy Method ***********************
- (NSMutableArray *)billImages{
    if (!_billImages) {
        _billImages = [NSMutableArray array];
    }
    return _billImages;
}

- (NSMutableArray *)ctImages{
    if (!_ctImages) {
        _ctImages = [NSMutableArray array];
    }
    return _ctImages;
}

- (NSMutableArray *)needUploadImages{
    if (!_needUploadImages) {
        _needUploadImages = [NSMutableArray array];
    }
    return _needUploadImages;
}
@end
