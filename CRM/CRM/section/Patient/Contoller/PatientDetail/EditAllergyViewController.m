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
#import "NSString+Conversion.h"
#import "XLTextViewPlaceHolder.h"
#import "UIColor+Extension.h"
#import "NSString+TTMAddtion.h"

#define CommenBgColor MyColor(245, 246, 247)

@interface EditAllergyViewController ()<UITextViewDelegate>

@property (nonatomic, weak)XLTextViewPlaceHolder *textView;
@property (nonatomic, weak)UILabel *placeHolderLabel;
@property (nonatomic, weak)UILabel *limitLabel;
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

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.textView becomeFirstResponder];
}

- (void)initNavBar{
    [super initView];
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
//    [self setRightBarButtonWithImage:[UIImage imageNamed:@"btn_complet"]];
    [self setRightBarButtonWithTitle:@"完成"];
    //初始化数据
    [self setUp];
}

#pragma mark - 初始化数据
- (void)setUp{
    CGFloat margin = 10;
    CGFloat textViewH = 150;
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, margin, kScreenWidth, textViewH)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.borderColor = [UIColor colorWithHex:0xcccccc].CGColor;
    bgView.layer.borderWidth = .5;
    [self.view addSubview:bgView];
    
    XLTextViewPlaceHolder *textView = [[XLTextViewPlaceHolder alloc] initWithFrame:CGRectMake(margin, 0, kScreenWidth - 2 * margin, textViewH)];
    textView.backgroundColor = [UIColor whiteColor];
    textView.placeHolder = @"选择或手动输入200字以内过敏史";
    textView.textColor = [UIColor blackColor];
    textView.font = [UIFont systemFontOfSize:16];
    textView.delegate = self;
    if ([self.content isNotEmpty]) {
        textView.text = self.content;
        textView.hidePlaceHolder = YES;
    }
    textView.returnKeyType = UIReturnKeyDone;
    self.textView = textView;
    [bgView addSubview:textView];
    
    UILabel *limitLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 200 - margin, textView.bottom - 20, 200, 20)];
    limitLabel.font = [UIFont systemFontOfSize:12];
    limitLabel.textColor = [UIColor colorWithHex:0xbbbbbb];
    limitLabel.textAlignment = NSTextAlignmentRight;
    limitLabel.text = [NSString stringWithFormat:@"还可输入%ld个字",self.limit - (unsigned long)self.content.length];
    self.limitLabel = limitLabel;
    [bgView addSubview:limitLabel];
    
    //添加通知，监听textView的内容的变化
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChanged) name:UITextViewTextDidChangeNotification object:nil];
    
    if (self.type == EditAllergyViewControllerRemark || self.type == EditAllergyViewControllerNickName) {
        if (self.type == EditAllergyViewControllerRemark) {
            textView.placeHolder = @"请输入300字以内备注信息";
        }else{
            textView.placeHolder = @"请输入备注名";
            self.title = @"备注名";
        }
    }else{
        NSArray *tempArray;
        if (self.type == EditAllergyViewControllerAnamnesis) {
            textView.placeHolder = @"选择或手动输入200字以内既往病史";
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
            button.frame = CGRectMake(index_y * (margin + buttonW) + margin, index_x * (margin + buttonH) + margin + self.textView.bottom + margin, buttonW, buttonH);
            [button setTitle:tempArray[i] forState:UIControlStateNormal];
            button.backgroundColor = MyColor(19, 152, 234);
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            button.layer.cornerRadius = 5;
            button.layer.masksToBounds = YES;
            button.tag = i + 100;
            [button addTarget:self action:@selector(allergyButtonSelect:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button];
            
            CGSize titleSize = [tempArray[i] measureFrameWithFont:[UIFont systemFontOfSize:14] size:CGSizeMake(MAXFLOAT, MAXFLOAT)].size;
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
    [self textChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([self.textView isFirstResponder]) {
        [self.textView resignFirstResponder];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - 保存
- (void)onRightButtonAction:(id)sender{

    ValidationResult result = [NSString isValidLength:self.textView.text length:400];
    if (result == ValidationResultInValid) {
        [SVProgressHUD showImage:nil status:@"内容过长，请重新输入"];
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
        
    if (self.delegate && [self.delegate respondsToSelector:@selector(editViewController:didEditWithContent:type:)]) {
        [self.delegate editViewController:self didEditWithContent:self.textView.text type:type];
    }
    
    [self popViewControllerAnimated:YES];
    
}

//监听textView内容的变化
- (void)textChanged{
    //判断是否有内容
    if (_textView.text.length) {
        //隐藏placeHolder
        _textView.hidePlaceHolder = YES;
    }else{
        _textView.hidePlaceHolder = NO;
    }
    
    if (self.limit != 0) {
        self.limitLabel.hidden = NO;
        NSInteger number = [self.textView.text length];
        if (number > self.limit) {
            self.textView.text = [self.textView.text substringToIndex:self.limit];
            number = self.limit;
        }
        self.limitLabel.text = [NSString stringWithFormat:@"还可输入%ld个字",self.limit - (long)number];
    }else{
        self.limitLabel.hidden = YES;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [self.textView resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

@end
