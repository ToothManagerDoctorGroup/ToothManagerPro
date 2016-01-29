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

#define Margin 5
#define CommenTitleColor MyColor(69, 69, 70)
#define CommenTitleFont [UIFont systemFontOfSize:14]

@interface MedicalDetailView ()<UIAlertViewDelegate>

@property (nonatomic, weak)UIScrollView *imageScrollView;//图片视图
@property (nonatomic, weak)UILabel *repairDoctorTitle; //修复医生标题
@property (nonatomic, weak)UILabel *repairTimeTitle;  //修复时间标题
@property (nonatomic, weak)UILabel *plantTimeTitle;  //种植时间标题
@property (nonatomic, weak)UILabel *orderTimeTitle;  //预约时间标题

@property (nonatomic, strong)NSArray *cTLibs;

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
    
    //修复时间
    NSString *repairTime;
    if (self.medicalCase.repair_time && [self.medicalCase.repair_time isNotEmpty]) {
        repairTime = [NSString stringWithFormat:@"修复时间:%@",[self dateStrFromatter:self.medicalCase.repair_time]];
    }else{
        repairTime = @"修复时间:";
    }
    
    CGSize repairTimeSize = [repairTime sizeWithFont:CommenTitleFont];
    CGFloat repairTimeX = Margin;
    CGFloat repairTimeY = self.height - repairTimeSize.height - Margin;
    self.repairTimeTitle.frame = CGRectMake(repairTimeX, repairTimeY, repairTimeSize.width, repairTimeSize.height);
    self.repairTimeTitle.text = repairTime;
    
    //预约时间
    NSString *orderTime;
    if (self.medicalCase.next_reserve_time && [self.medicalCase.next_reserve_time isNotEmpty]) {
        orderTime = [NSString stringWithFormat:@"预约时间:%@",[self dateStrFromatter:self.medicalCase.next_reserve_time]];
    }else{
        orderTime = @"预约时间:";
    }
    CGSize orderTimeSize = [orderTime sizeWithFont:CommenTitleFont];
    CGFloat orderX = self.width - orderTimeSize.width - Margin;
    CGFloat orderY = self.height - orderTimeSize.height - Margin;
    self.orderTimeTitle.frame = CGRectMake(orderX, orderY, orderTimeSize.width, orderTimeSize.height);
    self.orderTimeTitle.text = orderTime;
    
    //修复医生
    NSString *doctorTitle;
    if (self.medicalCase.repair_doctor_name && [self.medicalCase.repair_doctor_name isNotEmpty]) {
        doctorTitle = [NSString stringWithFormat:@"修复医生:%@",self.medicalCase.repair_doctor_name];
    }else{
        doctorTitle = @"修复医生:";
    }
    
    CGSize doctorTitleSize = [doctorTitle sizeWithFont:CommenTitleFont];
    CGFloat doctorX = Margin;
    CGFloat doctorY = self.repairTimeTitle.top - doctorTitleSize.height - Margin;
    self.repairDoctorTitle.frame = CGRectMake(doctorX, doctorY, doctorTitleSize.width, doctorTitleSize.height);
    self.repairDoctorTitle.text = doctorTitle;
    
    //种植时间
    NSString *plantTime;
    if (self.medicalCase.implant_time && [self.medicalCase.implant_time isNotEmpty]) {
        plantTime = [NSString stringWithFormat:@"种植时间:%@",[self dateStrFromatter:self.medicalCase.implant_time]];
    }else{
        plantTime = @"种植时间:";
    }
    CGSize plantSize = [plantTime sizeWithFont:CommenTitleFont];
    CGFloat plantX = self.width - plantSize.width - Margin;
    CGFloat plantY = self.orderTimeTitle.top - plantSize.height - Margin;
    self.plantTimeTitle.text = plantTime;
    self.plantTimeTitle.frame = CGRectMake(plantX, plantY, plantSize.width, plantSize.height);
    
    //计算imageScrollView的frame
    self.imageScrollView.frame = CGRectMake(Margin, Margin, self.width - Margin * 2, self.height - Margin * 4 - plantSize.height * 2);
    
    //获取所有的ct图片信息
    NSMutableArray *cTLibs = [NSMutableArray array];
    NSArray *libArray = [[DBManager shareInstance] getCTLibArrayWithCaseId:self.medicalCase.ckeyid];
    if (libArray != nil && libArray.count > 0) {
        [cTLibs addObjectsFromArray:libArray];
    } else {
        CTLib *libtmp = [[CTLib alloc]init];
        libtmp.ckeyid = @"-100";
        libtmp.ct_image = @"ctlib_placeholder.png";
        libtmp.creationdate = self.medicalCase.creation_date;
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
//            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
//            longPress.minimumPressDuration = 1.0f;
//            [imageView addGestureRecognizer:longPress];
            //显示图片
            if ([ct.ckeyid isEqualToString:@"-100"]) {
                imageView.image = [UIImage imageNamed:ct.ct_image];
            }else{
                //如果有ct图片，则添加单击事件
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
                tap.numberOfTapsRequired = 1;
                tap.numberOfTouchesRequired = 1;
                [imageView addGestureRecognizer:tap];
                
                [imageView sd_setImageWithURL:[NSURL URLWithString:ct.ct_image] placeholderImage:[UIImage imageNamed:ct.ct_image] options:SDWebImageRetryFailed|SDWebImageLowPriority completed:nil];
            }
            [self.imageScrollView addSubview:imageView];
        }
    }
}
#pragma mark -单击事件
- (void)tapAction:(UITapGestureRecognizer *)tap{
    //获取当前点击的视图
    UIImageView *imageView = (UIImageView *)tap.view;
    //遍历当前图片数组，将LBPhoto模型转换成MJPhoto模型
    NSMutableArray *mJPhotos = [NSMutableArray array];
    int i = 0;
    for (CTLib *photo in self.cTLibs) {
        //将图片url转换成高清的图片url
        MJPhoto *mjPhoto = [[MJPhoto alloc] init];
        mjPhoto.url = [NSURL URLWithString:photo.ct_image];
        mjPhoto.srcImageView = imageView;
        mjPhoto.index = i;
        [mJPhotos addObject:mjPhoto];
        i++;
    }
    
    //创建图片显示控制器对象
//    if (!_browser) {
//        _browser = [[MJPhotoBrowser alloc] init];
//    }
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.photos = mJPhotos;
    browser.currentPhotoIndex = imageView.tag;
    //显示
    [browser show];
}

#pragma mark -长按事件
- (void)longPressAction:(UILongPressGestureRecognizer *)longPress{
    if(longPress.state == UIGestureRecognizerStateBegan){
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认删除病历吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
//        [alertView show];
        
        TimAlertView *alertView = [[TimAlertView alloc]initWithTitle:@"确认删除？" message:nil  cancelHandler:^{
            NSLog(@"取消删除");
        } comfirmButtonHandlder:^{
            
            for (CTLib *lib in self.cTLibs) {
                if(![lib.ckeyid isEqualToString:@"-100"]){
                    [[SDImageCache sharedImageCache] removeImageForKey:lib.ckeyid fromDisk:YES];
                }
            }
            
            BOOL ret = [[DBManager shareInstance] deleteMedicalCaseWithCaseId:self.medicalCase.ckeyid];
            if (ret) {
                NSLog(@"删除成功");
                //发送一个通知
                [[NSNotificationCenter defaultCenter] postNotificationName:MedicalCaseCancleSuccessNotification object:nil];
            } else {
                [SVProgressHUD showImage:nil status:@"删除失败"];
            }
        }];
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSLog(@"确认");
    }
}

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
