//
//  EditAllergyViewController.m
//  CRM
//
//  Created by Argo Zhang on 15/12/14.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "EditAllergyViewController.h"

#import "DBManager+Patients.h"
#import "DBTableMode.h"
#import "DBManager+AutoSync.h"
#import "DBManager+sync.h"
#import "MJExtension.h"
#import "JSONKit.h"

#define CommenBgColor MyColor(245, 246, 247)

@interface EditAllergyViewController ()<UITextViewDelegate>

@property (nonatomic, weak)UITextView *textView;
@property (nonatomic, weak)UILabel *placeHolderLabel;
@property (nonatomic, strong)NSArray *allergyNames;
@property (nonatomic, strong)NSArray *anamnesises;

@end

@implementation EditAllergyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.allergyNames = @[@"抗生素",@"麻药",@"酒精",@"碘伏"];
    self.anamnesises = @[@"糖尿病",@"心脏病",@"传染病",@"长期使用抗凝药物"];
    
    //设置导航栏
    [self initNavBar];
    
}

- (void)initNavBar{
    [super initView];
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    [self setRightBarButtonWithTitle:@"保存"];
    self.view.backgroundColor = CommenBgColor;
    
    //初始化数据
    [self setUp];
}

#pragma mark - 初始化数据
- (void)setUp{
    CGFloat margin = 10;
    UILabel *placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, margin, kScreenWidth - margin * 2, 20)];
    placeHolderLabel.text = @"选择或手动输入过敏史";
    placeHolderLabel.textColor = MyColor(174, 174, 174);
    placeHolderLabel.font = [UIFont systemFontOfSize:14];
    self.placeHolderLabel = placeHolderLabel;
    [self.view addSubview:placeHolderLabel];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, placeHolderLabel.bottom + margin, kScreenWidth, 150)];
    textView.backgroundColor = [UIColor whiteColor];
    textView.textColor = [UIColor blackColor];
    textView.font = [UIFont systemFontOfSize:16];
    textView.returnKeyType = UIReturnKeyDone;
    textView.delegate = self;
    if (self.content) {
        textView.text = self.content;
    }
    self.textView = textView;
    [self.view addSubview:textView];
    
    if (self.type == EditAllergyViewControllerRemark || self.type == EditAllergyViewControllerNickName) {
        if (self.type == EditAllergyViewControllerRemark) {
            placeHolderLabel.text = @"请输入备注";
        }else{
            placeHolderLabel.text = @"请输入备注名";
            self.title = @"备注名";
        }
    }else{
        NSArray *tempArray;
        if (self.type == EditAllergyViewControllerAnamnesis) {
            placeHolderLabel.text = @"选择或手动输入既往病史";
            tempArray = self.anamnesises;
        }else{
            tempArray = self.allergyNames;
        }
        
        CGFloat buttonW = (kScreenWidth - margin * 5) / 4;
        CGFloat buttonH = 30;
        //过敏史的4个按钮
        for (int i = 0; i < tempArray.count; i++) {
            int index_x = i / 4;
            int index_y = i % 4;
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(index_y * (margin + buttonW) + margin, index_x * (margin + buttonH) + margin + self.textView.bottom, buttonW, buttonH);
            [button setTitle:tempArray[i] forState:UIControlStateNormal];
            button.backgroundColor = MyColor(19, 152, 234);
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            button.layer.cornerRadius = 5;
            button.layer.masksToBounds = YES;
            button.tag = i + 100;
            [button addTarget:self action:@selector(allergyButtonSelect:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button];
            
            CGSize titleSize = [tempArray[i] sizeWithFont:[UIFont systemFontOfSize:14]];
            if (titleSize.width > buttonW) {
                button.titleLabel.font = [UIFont systemFontOfSize:8];
            }
        }

    }
}
#pragma mark - 选择过敏源
- (void)allergyButtonSelect:(UIButton *)button{
    NSArray *tempArr;
    if (self.type == EditAllergyViewControllerAllergy) {
        tempArr = self.allergyNames;
    }else{
        tempArr = self.anamnesises;
    }
    NSInteger index = button.tag - 100;
    NSMutableString *mstring = [NSMutableString stringWithString:self.textView.text];
    NSString *str;
    if (self.textView.text.length > 0) {
        str = [NSString stringWithFormat:@",%@",tempArr[index]];
    }else{
        str = [NSString stringWithFormat:@"%@",tempArr[index]];
    }
    
    [mstring appendString:str];
    
    self.textView.text = mstring;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([self.textView isFirstResponder]) {
        [self.textView resignFirstResponder];
    }
}

#pragma mark - 保存
- (void)onRightButtonAction:(id)sender{
    if (self.textView.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"内容不能为空!"];
        return;
    }
    
    Patient *currentPatient = self.patient;
    EditAllergyViewControllerType type;
    if (self.type == EditAllergyViewControllerAllergy) {
        //保存过敏史
        currentPatient.patient_allergy = self.textView.text;
        type = EditAllergyViewControllerAllergy;
        
    }else if (self.type == EditAllergyViewControllerAnamnesis){
        //保存既往病史
        currentPatient.anamnesis = self.textView.text;
        type = EditAllergyViewControllerAnamnesis;
    }else if(self.type == EditAllergyViewControllerRemark){
        //保存备注
        currentPatient.patient_remark = self.textView.text;
        type = EditAllergyViewControllerRemark;
    }else{
        //保存昵称
        currentPatient.nickName = self.textView.text;
        type = EditAllergyViewControllerNickName;
    }
    
    BOOL res = [[DBManager shareInstance] updatePatient:currentPatient];
    if (res) {
        [[DBManager shareInstance] updateUpdateDate:currentPatient.ckeyid];
        [SVProgressHUD showSuccessWithStatus:@"更新成功"];
        
        //将修改过的患者信息保存到数据库
        NSArray *array = [[DBManager shareInstance] getAllEditNeedSyncPatient];
        for (Patient *patient in array) {
            InfoAutoSync *info = [[InfoAutoSync alloc] initWithDataType:AutoSync_Patient postType:Update dataEntity:[patient.keyValues JSONString] syncStatus:@"0"];
            [[DBManager shareInstance] insertInfoWithInfoAutoSync:info];
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(editViewController:didEditWithContent:type:)]) {
            [self.delegate editViewController:self didEditWithContent:self.textView.text type:type];
        }
    }else{
        [SVProgressHUD showErrorWithStatus:@"更新失败"];
    }
    [self popViewControllerAnimated:YES];
    
}



@end