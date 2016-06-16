//
//  MedicalDetailView.m
//  CRM
//
//  Created by Argo Zhang on 15/11/20.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "MedicalDetailView.h"
#import "DBManager+Patients.h"
#import "UIImageView+WebCache.h"
#import "DBManager+RepairDoctor.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "CRMMacro.h"
#import "DBManager+AutoSync.h"
#import "MJExtension.h"
#import "JSONKit.h"
#import "DBManager+Materials.h"
#import "PatientDetailViewController.h"
#import "UIView+WXViewController.h"
#import "ImageBrowserViewController.h"
#import "AddressBoolTool.h"
#import "DBManager+Introducer.h"
#import "XLBrowserViewController.h"

#define Margin 5
#define CommenTitleColor MyColor(69, 69, 70)
#define CommenTitleFont [UIFont systemFontOfSize:14]

@interface MedicalDetailView ()<UIAlertViewDelegate,ImageBrowserViewControllerDelegate>

@property (nonatomic, weak)UIScrollView *imageScrollView;//图片视图
@property (nonatomic, weak)UILabel *repairDoctorTitle; //修复医生标题
@property (nonatomic, weak)UILabel *repairTimeTitle;  //修复时间标题
@property (nonatomic, weak)UILabel *plantTimeTitle;  //种植时间标题
@property (nonatomic, weak)UILabel *orderTimeTitle;  //预约时间标题

@property (nonatomic, strong)NSMutableArray *cTLibs;

@end

@implementation MedicalDetailView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化
        [self setUp];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setUp];
    }
    return self;
}
#pragma mark -初始化
- (void)setUp{
    //图片视图
    UIScrollView *imageScrollView = [[UIScrollView alloc] init];
    imageScrollView.showsHorizontalScrollIndicator = NO;
    imageScrollView.pagingEnabled = YES;
    imageScrollView.bounces = NO;
    self.imageScrollView = imageScrollView;
    [self addSubview:imageScrollView];
    
    //修复医生
    UILabel *repairDoctorTitle = [self createLabel];
    self.repairDoctorTitle = repairDoctorTitle;
    [self addSubview:repairDoctorTitle];
    
    //修复时间
    UILabel *repairTimeTitle = [self createLabel];
    self.repairTimeTitle = repairTimeTitle;
    [self addSubview:repairTimeTitle];
    
    //种植时间
    UILabel *plantTimeTitle = [self createLabel];
    self.plantTimeTitle = plantTimeTitle;
    [self addSubview:plantTimeTitle];
    
    //预约时间
    UILabel *orderTimeTitle = [self createLabel];
    self.orderTimeTitle = orderTimeTitle;
    [self addSubview:orderTimeTitle];
}

#pragma mark -创建文本视图
- (UILabel *)createLabel{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = CommenTitleColor;
    label.font = CommenTitleFont;
    return label;
}

- (void)setMedicalCase:(MedicalCase *)medicalCase{
    
    _medicalCase = medicalCase;
    
    //修复医生
    NSString *doctorTitle;
    if (self.medicalCase.repair_doctor_name && [self.medicalCase.repair_doctor_name isNotEmpty]) {
        doctorTitle = [NSString stringWithFormat:@"修复医生：%@",self.medicalCase.repair_doctor_name];
    }else{
        doctorTitle = @"修复医生：";
    }
    
    CGSize doctorTitleSize = [doctorTitle sizeWithFont:CommenTitleFont];
    CGFloat doctorX = Margin;
    CGFloat doctorY = self.height - doctorTitleSize.height - Margin;
    //self.height - repairTimeSize.height - Margin
    self.repairDoctorTitle.frame = CGRectMake(doctorX, doctorY, doctorTitleSize.width, doctorTitleSize.height);
    self.repairDoctorTitle.text = doctorTitle;
    
    //修复时间
    NSString *repairTime;
    if (self.medicalCase.repair_time && [self.medicalCase.repair_time isNotEmpty]) {
        repairTime = [NSString stringWithFormat:@"修复时间：%@",[self dateStrFromatter:self.medicalCase.repair_time]];
    }else{
        repairTime = @"修复时间：";
    }
    
    CGSize repairTimeSize = [repairTime sizeWithFont:CommenTitleFont];
    CGFloat repairTimeX = Margin;
    CGFloat repairTimeY = self.repairDoctorTitle.top - repairTimeSize.height - Margin;
    self.repairTimeTitle.frame = CGRectMake(repairTimeX, repairTimeY, repairTimeSize.width, repairTimeSize.height);
    self.repairTimeTitle.text = repairTime;
    
    //预约时间
    NSString *orderTime;
    if (self.medicalCase.next_reserve_time && [self.medicalCase.next_reserve_time isNotEmpty]) {
        orderTime = [NSString stringWithFormat:@"预约时间：%@",[self dateStrFromatter:self.medicalCase.next_reserve_time]];
    }else{
        orderTime = @"预约时间：";
    }
    CGSize orderTimeSize = [orderTime sizeWithFont:CommenTitleFont];
    CGFloat orderX = self.width - orderTimeSize.width - Margin;
    CGFloat orderY = self.height - orderTimeSize.height - Margin;
    self.orderTimeTitle.frame = CGRectMake(orderX, orderY, orderTimeSize.width, orderTimeSize.height);
    self.orderTimeTitle.text = orderTime;
    
    //种植时间
    NSString *plantTime;
    if (self.medicalCase.implant_time && [self.medicalCase.implant_time isNotEmpty]) {
        plantTime = [NSString stringWithFormat:@"种植时间：%@",[self dateStrFromatter:self.medicalCase.implant_time]];
    }else{
        plantTime = @"种植时间：";
    }
    CGSize plantSize = [plantTime sizeWithFont:CommenTitleFont];
    CGFloat plantX = self.width - plantSize.width - Margin;
    CGFloat plantY = self.orderTimeTitle.top - plantSize.height - Margin;
    self.plantTimeTitle.text = plantTime;
    self.plantTimeTitle.frame = CGRectMake(plantX, plantY, plantSize.width, plantSize.height);
    
    //计算scrollView的frame
    [self initScrollView];
}

- (void)initScrollView{
    //计算imageScrollView的frame
    self.imageScrollView.frame = CGRectMake(Margin, Margin, self.width - Margin * 2, self.height - Margin * 4 - self.plantTimeTitle.height * 2);
    
    //获取所有的ct图片信息
    NSMutableArray *cTLibs = [NSMutableArray array];
    NSArray *libArray = [[DBManager shareInstance] getCTLibArrayWithCaseId:self.medicalCase.ckeyid isAsc:NO];
    if (libArray != nil && libArray.count > 0) {
        [cTLibs addObjectsFromArray:libArray];
    } else {
        CTLib *libtmp = [[CTLib alloc]init];
        libtmp.ckeyid = @"-100";
        libtmp.ct_image = @"ctlib_placeholder.png";
        libtmp.creation_date = self.medicalCase.creation_date;
        libtmp.ct_desc = self.medicalCase.creation_date;
        [cTLibs addObject:libtmp];
    }
    //设置滑动图片视图的frame
    if (cTLibs.count > 0) {
        
        self.cTLibs = cTLibs;
        
        self.imageScrollView.hidden = NO;
        CGFloat imageViewW = self.imageScrollView.width;
        CGFloat imageViewH = self.imageScrollView.height;
        //计算偏移量
        self.imageScrollView.contentSize = CGSizeMake(cTLibs.count * imageViewW, self.imageScrollView.height);
        
        //首先移除所有的imageView
        for (UIView *view in self.imageScrollView.subviews) {
            if ([view isKindOfClass:[UIImageView class]]) {
                [view removeFromSuperview];
            }
        }
        for (int i = 0; i < cTLibs.count; i++) {
            
            CTLib *ct = cTLibs[i];
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.tag = i;
            imageView.userInteractionEnabled = YES;
            imageView.layer.cornerRadius = 8;
            imageView.layer.masksToBounds = YES;
            imageView.frame = CGRectMake(i * imageViewW, 0, imageViewW, imageViewH);
            //添加长按事件
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
            longPress.minimumPressDuration = 1.0f;
            [imageView addGestureRecognizer:longPress];
            //显示图片
            if ([ct.ckeyid isEqualToString:@"-100"]) {
                imageView.image = [UIImage imageNamed:ct.ct_image];
            }else{
                //如果有ct图片，则添加单击事件
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
                tap.numberOfTapsRequired = 1;
                tap.numberOfTouchesRequired = 1;
                [imageView addGestureRecognizer:tap];
                
                [imageView sd_setImageWithURL:[NSURL URLWithString:ct.ct_image] placeholderImage:[UIImage imageNamed:@"ct_holderImage"] options:SDWebImageRefreshCached | SDWebImageRetryFailed];
            }
            [self.imageScrollView addSubview:imageView];
        }
    }
}

#pragma mark -单击事件
- (void)tapAction:(UITapGestureRecognizer *)tap{
    NSMutableArray *picArray = [NSMutableArray arrayWithCapacity:0];
    for (CTLib *lib in self.cTLibs) {
        BrowserPicture *pic = [[BrowserPicture alloc] init];
        pic.keyidStr = lib.ckeyid;
        pic.url = lib.ct_image;
        pic.title = lib.ct_desc;
        pic.ctLib = lib;
        [picArray addObject:pic];
    }

    ImageBrowserViewController *picbrowserVC = [[ImageBrowserViewController alloc] init];
    picbrowserVC.delegate = self;
    [picbrowserVC.imageArray addObjectsFromArray:picArray];
    picbrowserVC.currentPage = tap.view.tag;
    [self.viewController presentViewController:picbrowserVC animated:YES completion:^{
    }];
    
}
#pragma mark - ImageBrowserViewControllerDelegate
- (void)picBrowserViewController:(ImageBrowserViewController *)controller didDeleteBrowserPicture:(BrowserPicture *)pic{
    //删除图片
    for (CTLib *lib in self.cTLibs) {
        if ([lib.ckeyid isEqualToString:pic.keyidStr]) {
            [[SDImageCache sharedImageCache] removeImageForKey:lib.ckeyid fromDisk:YES];
            [self.cTLibs removeObject:lib];
            
            //删除数据库中的ct图片
            if([[DBManager shareInstance] deleteCTlibWithLibId:lib.ckeyid]){
                //添加一条删除ct片的自动同步数据
                InfoAutoSync *info = [[InfoAutoSync alloc] initWithDataType:AutoSync_CtLib postType:Delete dataEntity:[lib.keyValues JSONString] syncStatus:@"0"];
                [[DBManager shareInstance] insertInfoWithInfoAutoSync:info];
            }
            
            break;
        }
    }
}

- (void)picBrowserViewController:(ImageBrowserViewController *)controller didFinishBrowseImages:(NSArray *)images{
    [controller dismissViewControllerAnimated:YES completion:^{
        [self initScrollView];
    }];
}

- (void)picBrowserViewController:(ImageBrowserViewController *)controller didSetMainImage:(BrowserPicture *)pic{
    //判断是否开启了通讯录权限
    if ([[AddressBoolTool shareInstance] userAllowToAddress]) {
        //保存患者的头像
        Patient *patient = [[DBManager shareInstance] getPatientWithPatientCkeyid:self.medicalCase.patient_id];
        BOOL isExist = [[AddressBoolTool shareInstance] getContactsWithName:patient.patient_name phone:patient.patient_phone];
        if (!isExist) {
            [[AddressBoolTool shareInstance] addContactToAddressBook:patient];
        }
        //获取患者的介绍人信息
        NSString *intrName = [[DBManager shareInstance] getPatientIntrNameWithPatientId:self.medicalCase.patient_id];
        CTLib *ctLib = pic.ctLib;
        UIImage *sourceImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:ctLib.ct_image];
        UIImage *image = [[AddressBoolTool shareInstance] drawImageWithSourceImage:sourceImage plantTime:self.medicalCase.implant_time intrName:intrName];
        [[AddressBoolTool shareInstance] saveWithImage:image person:patient.patient_name phone:patient.patient_phone];
    }
}

#pragma mark -长按事件
- (void)longPressAction:(UILongPressGestureRecognizer *)longPress{
    if(longPress.state == UIGestureRecognizerStateBegan){
        
        __weak typeof(self) weakSelf = self;
        TimAlertView *alertView = [[TimAlertView alloc]initWithTitle:@"确定删除病历？" message:nil  cancelHandler:^{
            NSLog(@"取消删除");
        } comfirmButtonHandlder:^{
            //删除数据
            [weakSelf deleteMedicalCase];
            
        }];
        [alertView show];
    }
}

#pragma mark - 删除病历数据
- (void)deleteMedicalCase{
    //删除本地的缓存图片
    for (CTLib *lib in self.cTLibs) {
        if(![lib.ckeyid isEqualToString:@"-100"]){
            [[SDImageCache sharedImageCache] removeImageForKey:lib.ckeyid fromDisk:YES];
        }
    }
    //删除CT数据
    NSArray *cts = [[DBManager shareInstance] getCTLibArrayWithCaseId:self.medicalCase.ckeyid isAsc:NO];
    //删除病历记录数据
    NSArray *medicalRecords = [[DBManager shareInstance] getMedicalRecordWithCaseId:self.medicalCase.ckeyid];
    //删除耗材数据
    NSArray *expenses = [[DBManager shareInstance] getMedicalExpenseArrayWithMedicalCaseId:self.medicalCase.ckeyid];
    
    //设置
    BOOL ret = [[DBManager shareInstance] deleteMedicalCaseWithCaseId:self.medicalCase.ckeyid];
    if (ret) {
        //创建自动上传消息
        InfoAutoSync *info = [[InfoAutoSync alloc] initWithDataType:AutoSync_MedicalCase postType:Delete dataEntity:[self.medicalCase.keyValues JSONString] syncStatus:@"0"];
        [[DBManager shareInstance] insertInfoWithInfoAutoSync:info];
        
        for (CTLib *ct in cts) {
            //创建自动上传消息
            InfoAutoSync *info = [[InfoAutoSync alloc] initWithDataType:AutoSync_CtLib postType:Delete dataEntity:[ct.keyValues JSONString] syncStatus:@"0"];
            [[DBManager shareInstance] insertInfoWithInfoAutoSync:info];
        }
        
        for (MedicalRecord *record in medicalRecords) {
            //创建自动上传消息
            InfoAutoSync *info = [[InfoAutoSync alloc] initWithDataType:AutoSync_MedicalRecord postType:Delete dataEntity:[record.keyValues JSONString] syncStatus:@"0"];
            [[DBManager shareInstance] insertInfoWithInfoAutoSync:info];
        }
        
        for (MedicalExpense *expense in expenses) {
            //创建自动上传消息
            InfoAutoSync *info = [[InfoAutoSync alloc] initWithDataType:AutoSync_MedicalExpense postType:Delete dataEntity:[expense.keyValues JSONString] syncStatus:@"0"];
            [[DBManager shareInstance] insertInfoWithInfoAutoSync:info];
        }
        
        //判断当前患者是否有病历
        NSArray *mCases = [[DBManager shareInstance] getMedicalCaseArrayWithPatientId:self.medicalCase.patient_id];
        if (mCases.count == 0) {
            //更新患者状态
            [[DBManager shareInstance] updatePatientStatus:PatientStatusUntreatment withPatientId:self.medicalCase.patient_id];
            
            //更新服务器患者的状态
            Patient *patient = [[DBManager shareInstance] getPatientWithPatientCkeyid:self.medicalCase.patient_id];
            if (patient != nil) {
                InfoAutoSync *info = [[InfoAutoSync alloc] initWithDataType:AutoSync_Patient postType:Update dataEntity:[patient.keyValues JSONString] syncStatus:@"0"];
                [[DBManager shareInstance] insertInfoWithInfoAutoSync:info];
            }
        }
        
        //删除病历成功
        PatientDetailViewController *detailVc =  (PatientDetailViewController *)self.viewController;
        [detailVc refreshData];
        //刷新数据
        [[NSNotificationCenter defaultCenter] postNotificationName:PatientEditedNotification object:nil];
    } else {
        [SVProgressHUD showImage:nil status:@"删除失败"];
    }
}

#pragma mark - 通用方法
- (NSString *)dateStrFromatter:(NSString *)dateStr{
    NSString *tempStr = [dateStr componentsSeparatedByString:@" "][0];
    return tempStr;
}

- (NSString *)dateStrFromatter2:(NSString *)dateStr{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *currentDate = [formatter dateFromString:dateStr];
    
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    formatter2.dateFormat = @"MM-dd HH:mm";
    
    return [formatter2 stringFromDate:currentDate];
}
- (NSString *)dateStrFromatter3:(NSString *)dateStr{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSDate *currentDate = [formatter dateFromString:dateStr];
    
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    formatter2.dateFormat = @"MM-dd HH:mm";
    
    return [formatter2 stringFromDate:currentDate];
}
@end
