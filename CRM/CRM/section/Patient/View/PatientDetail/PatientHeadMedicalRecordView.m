//
//  PatientHeadMedicalRecordView.m
//  CRM
//
//  Created by Argo Zhang on 15/11/20.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "PatientHeadMedicalRecordView.h"
#import "UIImage+LBImage.h"
#import "MedicalButtonScrollView.h"
#import "MedicalDetailView.h"
#import "DBTableMode.h"
#import "DBManager+Patients.h"

#define Margin 10

@interface PatientHeadMedicalRecordView ()<MedicalButtonScrollViewDelegate>

@property (nonatomic, weak)UIButton *medicalButton; //病例按钮
@property (nonatomic, weak)UIButton *addMedicalButton; //添加病例按钮
@property (nonatomic, weak)UIButton *editMedicalButton; //编辑病例按钮
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
    [medicalButton setTitle:@"病历" forState:UIControlStateNormal];
    [medicalButton setImage:[UIImage imageNamed:@"medical_title"] forState:UIControlStateNormal];
    [medicalButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    medicalButton.titleLabel.font = [UIFont systemFontOfSize:16];
    medicalButton.enabled = YES;
    self.medicalButton = medicalButton;
    [self addSubview:medicalButton];
    
    //添加病例的按钮
    UIButton *addMedicalButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addMedicalButton setTitle:@"新增病例" forState:UIControlStateNormal];
    [addMedicalButton setImage:[UIImage imageNamed:@"medical_add"] forState:UIControlStateNormal];
    [addMedicalButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    addMedicalButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [addMedicalButton addTarget:self action:@selector(addMedicalButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.addMedicalButton = addMedicalButton;
    [self addSubview:addMedicalButton];
    
    //病历按钮的scrollView
    MedicalButtonScrollView *medicalButtonScrollView = [[MedicalButtonScrollView alloc] init];
    medicalButtonScrollView.backgroundColor = [UIColor whiteColor];
    medicalButtonScrollView.medicalDelegate = self;
    self.medicalButtonScrollView = medicalButtonScrollView;
    [self addSubview:medicalButtonScrollView];
    
    //编辑病例的按钮
    UIButton *editMedicalButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [editMedicalButton setTitle:@"编辑病例" forState:UIControlStateNormal];
    [editMedicalButton setImage:[UIImage imageNamed:@"medical_edit"] forState:UIControlStateNormal];
    [editMedicalButton setTitleColor:MyColor(19, 150, 233) forState:UIControlStateNormal];
    [editMedicalButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    editMedicalButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [editMedicalButton addTarget:self action:@selector(editMedicalButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.editMedicalButton = editMedicalButton;
    [self addSubview:editMedicalButton];
    
    
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
    //新增病历按钮的大小
    CGFloat addMedicalButtonW = 100;
    CGFloat addMedicalButtonH = 30;
    //编辑病例按钮的大小
    CGFloat editMedicalButtonW = addMedicalButtonW;
    CGFloat editMedicalButtonH = addMedicalButtonH;
    //病历按钮的列表的大小
    CGFloat medicalButtonScrollViewW = self.width - editMedicalButtonW - Margin * .6;
    CGFloat medicalButtonScrollViewH = 35;
    
    
    self.medicalButton.frame = CGRectMake(Margin * 0.3, Margin * 0.3, medicalButtonW, medicalButtonH);
    self.addMedicalButton.frame = CGRectMake(self.width - addMedicalButtonW - Margin * 0.3, Margin * 0.3, addMedicalButtonW, addMedicalButtonH);
    self.medicalButtonScrollView.frame = CGRectMake(0, 45, medicalButtonScrollViewW, medicalButtonScrollViewH);
    self.medicalButtonScrollView.medicalCases = self.medicalCases;
    
    self.editMedicalButton.frame = CGRectMake(self.width - editMedicalButtonW - Margin * .3, 47.5, editMedicalButtonW, editMedicalButtonH);
    
    //设置数据
    self.medicalDetailView.frame = CGRectMake(0, self.medicalButtonScrollView.bottom + 1, self.width, self.height - self.medicalButtonScrollView.bottom - 1);
    self.medicalDetailView.medicalCase = self.medicalCases[self.currentIndex];
}

#pragma mark -MedicalButtonScrollViewDelegate
- (void)medicalButtonScrollView:(MedicalButtonScrollView *)scrollView didSelectButtonWithIndex:(NSUInteger)index{
    self.currentIndex = index;
    
    //重新设置数据
    self.medicalDetailView.medicalCase = self.medicalCases[index];
}

#pragma mark -addMedicalButtonClick
- (void)addMedicalButtonClick{
    if ([self.delegate respondsToSelector:@selector(didClickAddMedicalButton)]) {
        [self.delegate didClickAddMedicalButton];
    }
}

- (void)editMedicalButtonClick{
    if ([self.delegate respondsToSelector:@selector(didClickeditMedicalButtonWithMedicalCase:)]) {
        [self.delegate didClickeditMedicalButtonWithMedicalCase:self.medicalCases[self.currentIndex]];
    }
}


@end
