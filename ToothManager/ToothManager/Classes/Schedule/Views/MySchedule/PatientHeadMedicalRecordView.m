//
//  PatientHeadMedicalRecordView.m
//  CRM
//
//  Created by Argo Zhang on 15/11/20.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "PatientHeadMedicalRecordView.h"
#import "MedicalButtonScrollView.h"
#import "MedicalDetailView.h"


#define Margin 10

@interface PatientHeadMedicalRecordView ()<MedicalButtonScrollViewDelegate>

@property (nonatomic, weak)UIButton *medicalButton; //病例按钮

@property (nonatomic, weak)MedicalButtonScrollView *medicalButtonScrollView; //编辑病例按钮
@property (nonatomic, weak)MedicalDetailView *medicalDetailView; //病历详细信息

//当前选中的病历
@property (nonatomic, assign)NSUInteger currentIndex;

@end

@implementation PatientHeadMedicalRecordView

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
        //初始化
        [self setUp];
    }
    return self;
}

#pragma mark -初始化
- (void)setUp{
    self.userInteractionEnabled = YES;
    //设置自身的图片
    UIImage *image = [UIImage imageNamed:@"medical_bg"];
    CGFloat top = 50; // 顶端盖高度
    CGFloat bottom = 50 ; // 底端盖高度
    CGFloat left = 10; // 左端盖宽度
    CGFloat right = 10; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    // 指定为拉伸模式，伸缩后重新赋值
    image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    self.image = image;
    
    //病历标题按钮
    UIButton *medicalButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [medicalButton setTitle:@"病程" forState:UIControlStateNormal];
    [medicalButton setImage:[UIImage imageNamed:@"medical_title"] forState:UIControlStateNormal];
    [medicalButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    medicalButton.titleLabel.font = [UIFont systemFontOfSize:16];
    medicalButton.enabled = YES;
    self.medicalButton = medicalButton;
    [self addSubview:medicalButton];
    
    
    //病历按钮的scrollView
    MedicalButtonScrollView *medicalButtonScrollView = [[MedicalButtonScrollView alloc] init];
    medicalButtonScrollView.backgroundColor = [UIColor whiteColor];
    medicalButtonScrollView.medicalDelegate = self;
    self.medicalButtonScrollView = medicalButtonScrollView;
    [self addSubview:medicalButtonScrollView];

    //病历详细信息
    MedicalDetailView *medicalDetailView = [[MedicalDetailView alloc] init];
    self.medicalDetailView = medicalDetailView;
    [self addSubview:medicalDetailView];
}

- (void)setMedicalCases:(NSArray *)medicalCases{
    _medicalCases = medicalCases;
    
    //病历标题的大小
    CGFloat medicalButtonW = 60;
    CGFloat medicalButtonH = 30;
    //病历按钮的列表的大小
    CGFloat medicalButtonScrollViewW = self.width - medicalButtonH - Margin * .6;
    CGFloat medicalButtonScrollViewH = 35;
    
    self.medicalButton.frame = CGRectMake(Margin * 0.3, Margin * 0.3, medicalButtonW, medicalButtonH);
    
    
    self.medicalButtonScrollView.frame = CGRectMake(0, 45, medicalButtonScrollViewW, medicalButtonScrollViewH);
    if (self.medicalCases.count > 0) {
        self.medicalButtonScrollView.medicalCases = self.medicalCases;
    }
    
    //设置数据
    self.medicalDetailView.frame = CGRectMake(0, self.medicalButtonScrollView.bottom + 1, self.width, self.height - self.medicalButtonScrollView.bottom - 1);
    
    if (self.medicalCases.count > 0) {
        self.medicalDetailView.medicalCase = self.medicalCases[0];
    }
}

#pragma mark -MedicalButtonScrollViewDelegate
- (void)medicalButtonScrollView:(MedicalButtonScrollView *)scrollView didSelectButtonWithIndex:(NSUInteger)index{
    
    self.currentIndex = index;
    
    //重新设置数据
    self.medicalDetailView.medicalCase = self.medicalCases[index];
}

@end
