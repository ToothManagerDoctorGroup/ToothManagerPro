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

#define Margin 5
#define CommenTitleColor MyColor(69, 69, 70)
#define CommenTitleFont [UIFont systemFontOfSize:14]

@interface MedicalDetailView ()

@property (nonatomic, weak)UIScrollView *imageScrollView;//图片视图
@property (nonatomic, weak)UILabel *repairDoctorTitle; //修复医生标题
@property (nonatomic, weak)UILabel *repairTimeTitle;  //修复时间标题
@property (nonatomic, weak)UILabel *plantTimeTitle;  //种植时间标题
@property (nonatomic, weak)UILabel *orderTimeTitle;  //预约时间标题

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
    if (self.medicalCase.repair_time) {
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
    if (self.medicalCase.creation_date) {
        orderTime = [NSString stringWithFormat:@"预约时间:%@",[self dateStrFromatter2:self.medicalCase.creation_date]];
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
    if (self.medicalCase.repair_doctor) {
//        doctorTitle = [NSString stringWithFormat:@"修复医生:%@",[self dateStrFromatter:self.medicalCase.repair_doctor]];
        doctorTitle = @"修复医生:";
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
    if (self.medicalCase.implant_time) {
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
        CGFloat imageViewW = self.imageScrollView.width;
        CGFloat imageViewH = self.imageScrollView.height;
        //计算偏移量
        self.imageScrollView.contentSize = CGSizeMake(cTLibs.count * imageViewW, self.imageScrollView.height);
        
        for (int i = 0; i < cTLibs.count; i++) {
            CTLib *ct = cTLibs[i];
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.layer.cornerRadius = 8;
            imageView.layer.masksToBounds = YES;
            imageView.frame = CGRectMake(i * imageViewW, 0, imageViewW, imageViewH);
            if ([ct.ct_image hasPrefix:@"http"]) {
                NSURL *imgUrl = [NSURL URLWithString:ct.ct_image];
                [imageView sd_setImageWithURL:imgUrl];
            }else{
                imageView.image = [UIImage imageNamed:ct.ct_image];
            }
            
            [self.imageScrollView addSubview:imageView];
        }
    }
}

- (NSString *)dateStrFromatter:(NSString *)dateStr{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSDate *currentDate = [formatter dateFromString:dateStr];
    
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    formatter2.dateFormat = @"MM-dd HH:mm";
    
    return [formatter2 stringFromDate:currentDate];
}

- (NSString *)dateStrFromatter2:(NSString *)dateStr{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *currentDate = [formatter dateFromString:dateStr];
    
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    formatter2.dateFormat = @"MM-dd HH:mm";
    
    return [formatter2 stringFromDate:currentDate];
}
@end
