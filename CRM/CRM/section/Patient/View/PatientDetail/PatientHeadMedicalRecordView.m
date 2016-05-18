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
#import "UIImage+TTMAddtion.h"
#import <Masonry.h>

#define Margin 10

@interface PatientHeadMedicalRecordView ()<MedicalButtonScrollViewDelegate>

@property (nonatomic, weak)UIButton *medicalButton; //病例按钮
@property (nonatomic, weak)UIButton *addMedicalButton; //添加病例按钮
@property (nonatomic, weak)UIButton *editMedicalButton; //编辑病例按钮
@property (nonatomic, weak)MedicalButtonScrollView *medicalButtonScrollView; //编辑病例按钮
@property (nonatomic, weak)MedicalDetailView *medicalDetailView; //病历详细信息

//当前选中的病历
@property (nonatomic, assign)NSUInteger currentIndex;


@property (nonatomic, strong)UIImageView *noResultView;
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
    [addMedicalButton setTitle:@"新增病历" forState:UIControlStateNormal];
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
    [editMedicalButton setTitle:@"编辑病历" forState:UIControlStateNormal];
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
    if (medicalCases.count == 0) {
        self.noResultView.hidden = NO;
    }else{
        self.noResultView.hidden = YES;
    }
    //重新绘制
    [self setNeedsLayout];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
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
    if (self.medicalCases.count > 0) {
        
        self.medicalButtonScrollView.hidden = NO;
        self.editMedicalButton.hidden = NO;
        
        self.medicalButtonScrollView.medicalCases = self.medicalCases;
        
        self.editMedicalButton.frame = CGRectMake(self.width - editMedicalButtonW - Margin * .3, 47.5, editMedicalButtonW, editMedicalButtonH);
    }else{
        self.medicalButtonScrollView.hidden = YES;
        self.editMedicalButton.hidden = YES;
    }
    
    //设置数据
    self.medicalDetailView.frame = CGRectMake(0, self.medicalButtonScrollView.bottom + 1, self.width, self.height - self.medicalButtonScrollView.bottom - 1);
    
    if (self.medicalCases.count > 0) {
        self.medicalDetailView.hidden = NO;
        self.medicalDetailView.medicalCase = self.medicalCases[0];
    }else{
        self.medicalDetailView.hidden = YES;
    }
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

#pragma mark - 控件懒加载
- (UIImageView *)noResultView{
    if (!_noResultView) {
        _noResultView = [[UIImageView alloc] initWithImage:[UIImage imageWithFileName:@"noMedicalcase_alert"]];
        _noResultView.hidden = YES;
        [self addSubview:_noResultView];
        
        WS(weakSelf);
        [_noResultView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(weakSelf);
        }];
    }
    return _noResultView;
}


@end
