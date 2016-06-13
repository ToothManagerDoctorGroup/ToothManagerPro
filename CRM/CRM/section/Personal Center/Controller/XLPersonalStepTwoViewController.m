//
//  XLPersonalStepTwoViewController.m
//  CRM
//
//  Created by Argo Zhang on 15/12/22.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "XLPersonalStepTwoViewController.h"
#import "DBTableMode.h"
#import "AccountManager.h"
#import "DBManager+User.h"
#import "NSDictionary+Extension.h"
#import "CRMMacro.h"
#import "DoctorTool.h"
#import "TimPickerTextField.h"
#import "XLDataSelectViewController.h"
#import "CRMUserDefalut.h"
#import "DoctorTool.h"
#import "MJExtension.h"
#import "DoctorInfoModel.h"

@interface XLPersonalStepTwoViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,XLDataSelectViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *step1CountLabel; //步骤1
@property (weak, nonatomic) IBOutlet UILabel *step2CountLabel;//步骤2
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;//头像
@property (weak, nonatomic) IBOutlet UIButton *menButton;//男性别按钮
@property (weak, nonatomic) IBOutlet UIButton *womenButton;//女性别按钮
@property (weak, nonatomic) IBOutlet UITextField *ageField;//年龄
@property (weak, nonatomic) IBOutlet TimPickerTextField *academicField;//学历
@property (weak, nonatomic) IBOutlet UIButton *preStepButton;//上一步按钮
@property (weak, nonatomic) IBOutlet UIButton *finishButton;//完成按钮


@property (nonatomic, assign)int sexCount;//0:女 1:男

@end

@implementation XLPersonalStepTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"信息完善";
    [self setBackBarButtonWithImage:nil];
    
    //设置控件属性
    [self setViewAttr];
    //设置控件内容
    [self setUpData];
    
}
- (void)onBackButtonAction:(id)sender{}

#pragma mark - 设置控件属性
- (void)setViewAttr{
    self.step1CountLabel.layer.cornerRadius = 12;
    self.step1CountLabel.layer.masksToBounds = YES;
    self.step2CountLabel.layer.cornerRadius = 12;
    self.step2CountLabel.layer.masksToBounds = YES;
    self.step1CountLabel.layer.borderWidth = 1;
    self.step1CountLabel.layer.borderColor = [MyColor(187, 187, 187) CGColor];
    
    self.preStepButton.layer.cornerRadius = 5;
    self.preStepButton.layer.masksToBounds = YES;
    self.finishButton.layer.cornerRadius = 5;
    self.finishButton.layer.masksToBounds = YES;
    
    self.headImageView.layer.cornerRadius = 43;
    self.headImageView.layer.masksToBounds = YES;
    
    //设置默认的性别
    self.sexCount = 1;
    self.menButton.selected = YES;
    
    self.academicField.mode = TextFieldInputModeExternal;
    
    //添加手势
    self.headImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choseImage:)];
    [self.headImageView addGestureRecognizer:tap];

}
#pragma mark - 设置控件内容
- (void)setUpData{
    self.headImageView.image = [UIImage imageNamed:@"user_icon"];
    
    //设置修改内容
    self.ageField.text = self.age;
    self.academicField.text = self.degree;
    self.sexCount = self.sex == nil ? 1 : [self.sex intValue];
}

- (void)choseImage:(UITapGestureRecognizer *)gesture {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                              destructiveButtonTitle:@"从相册选择"
                                                   otherButtonTitles:@"摄像头拍摄", nil];
    [actionSheet setActionSheetStyle:UIActionSheetStyleDefault];
    [actionSheet showInView:self.view];
}

#pragma mark - ActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
        {
            //从相册
            UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }
            pickerImage.delegate = self;
            pickerImage.allowsEditing = YES;
            [self presentViewController:pickerImage animated:YES completion:nil];
        }
            break;
        case 1:
        {
            //摄像头
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                picker.allowsEditing = YES;
                picker.sourceType = sourceType;
                [self presentViewController:picker animated:YES completion:nil];
            }else {
                [SVProgressHUD showErrorWithStatus:@"您的设备没有摄像头"];
            }
        }
            break;
        default:
            break;
    }
}


//选择男
- (IBAction)menSelectActon:(id)sender {
    self.sexCount = 1;
    
}
//选择女
- (IBAction)womenSelectAction:(id)sender {
    self.sexCount = 0;
    
}

- (void)setSexCount:(int)sexCount{
    _sexCount = sexCount;
    
    switch (sexCount) {
        case 0:
            self.menButton.selected = NO;
            self.womenButton.selected = YES;
            break;
        case 1:
            self.menButton.selected = YES;
            self.womenButton.selected = NO;
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)preStepAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(personalStepTwoVC:didWriteAge:sex:degree:)]) {
        [self.delegate personalStepTwoVC:self didWriteAge:self.ageField.text sex:[NSString stringWithFormat:@"%d",self.sexCount] degree:self.academicField.text];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)finishButtonAction:(id)sender {
    
    //判断年龄是否合法
    if ([self.ageField.text integerValue] > 150) {
        [SVProgressHUD showImage:nil status:@"年龄无效，请重新输入"];
        return;
    }
    
    //保存用户信息
    UserObject *userobj = [[AccountManager shareInstance] currentUser];
    Doctor *doctor = [[Doctor alloc]init];
    [doctor setCkeyid:userobj.userid];
    [doctor setUser_id:userobj.userid];
    [doctor setDoctor_name:self.userName];
    [doctor setDoctor_dept:self.departMentName];
    [doctor setDoctor_phone:userobj.phone];
    [doctor setDoctor_hospital:self.hospitalName];
    [doctor setDoctor_position:self.professionalName];
    [doctor setDoctor_degree:self.academicField.text];
    [doctor setAuth_status:userobj.authStatus];
    [doctor setAuth_text:userobj.authText];
    [doctor setDoctor_certificate:@""];  //证书，此处我也不知道要传什么，暂时传空，不能为nil
    [doctor setIsopen:YES];
    [doctor setDoctor_gender:[NSString stringWithFormat:@"%d",self.sexCount]];
    //根据年龄获取当前生日的年份
    NSInteger year = [self getYear] - [self.ageField.text integerValue];
    [doctor setDoctor_birthday:[NSString stringWithFormat:@"%ld-01-01",(long)year]];
    [doctor setDoctor_cv:@""];
    [doctor setDoctor_skill:@""];
    
    [[AccountManager shareInstance] updateUserInfo:doctor successBlock:^{
        [SVProgressHUD showWithStatus:@"正在更新个人信息..."];
    } failedBlock:^(NSError *error){
        [SVProgressHUD showTextWithStatus:error.localizedDescription];
    }];
    
}

#pragma mark -
#pragma mark CRMHttpRequestPersonalCenterDelegate
- (void)updateUserInfoSuccessWithResult:(NSDictionary *)result
{
    if ([result integerForKey:@"Code"] == 200) {
        //获取个人信息
        [DoctorTool requestDoctorInfoWithDoctorId:[AccountManager currentUserid] success:^(DoctorInfoModel *dcotorInfo) {
            [SVProgressHUD showImage:nil status:@"个人消息更新成功"];
            
            //更新登录人信息
            UserObject *obj = [UserObject userobjectFromDic:dcotorInfo.keyValues];
            [[DBManager shareInstance] updateUserWithUserObject:obj];
            [[AccountManager shareInstance] refreshCurrentUserInfo];
            
            [self postNotificationName:SignInSuccessNotification object:nil];
        } failure:^(NSError *error) {
            [SVProgressHUD showImage:nil status:@"个人消息更新失败"];
            if (error) {
                NSLog(@"error:%@",error);
            }
        }];
        
    } else {
        [SVProgressHUD showImage:nil status:@"个人消息更新失败"];
    }
}

- (void)updateUserInfoFailedWithError:(NSError *)error
{
    [SVProgressHUD showImage:nil status:error.localizedDescription];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //添加监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}

#pragma mark -
#pragma mark UIImagePicker Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (info != nil) {
        UIImage* image = info[UIImagePickerControllerEditedImage];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self saveImage:image WithName:@"userAvatar"];
        });
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData* imageData = UIImagePNGRepresentation(tempImage);
    NSString* documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* totalPath = [documentPath stringByAppendingPathComponent:imageName];
    //保存到 document
    [imageData writeToFile:totalPath atomically:NO];
    //保存到 NSUserDefaults
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:totalPath forKey:@"avatar"];
    
    //上传服务器
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"上传中..."];
    [DoctorTool composeTeacherHeadImg:tempImage userId:[AccountManager currentUserid] success:^(CRMHttpRespondModel *respond) {
        //清除图片缓存
        [[SDImageCache sharedImageCache] cleanDisk];
        [[SDImageCache sharedImageCache] clearMemory];
        
        [weakSelf setAuthImage:tempImage];
        
        [SVProgressHUD showSuccessWithStatus:@"头像上传成功"];
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error);
        [SVProgressHUD showErrorWithStatus:@"头像上传失败"];
    }];
}
- (void)setAuthImage:(UIImage *)image
{
    [self.headImageView setImage:image];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (NSInteger)getYear{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:[NSDate date]];
    NSInteger year = [dateComponent year];
    return year;
}


#pragma mark - 键盘监听事件
- (void)keyboardWillShow:(CGFloat)keyboardHeight {
    static BOOL flag = NO;
    if (flag == YES || self.navigationController.topViewController != self) {
        return;
    }
    flag = YES;
    
    if ([self.academicField isFirstResponder]) {
        [self.academicField resignFirstResponder];
        
        XLDataSelectViewController *dataSelectVc = [[XLDataSelectViewController alloc] initWithStyle:UITableViewStyleGrouped];
        dataSelectVc.type = XLDataSelectViewControllerDegree;
        dataSelectVc.currentContent = self.academicField.text;
        dataSelectVc.delegate = self;
        [self pushViewController:dataSelectVc animated:YES];
    }
    flag = NO;
}

#pragma mark - XLDataSelectViewControllerDelegate
- (void)dataSelectViewController:(XLDataSelectViewController *)dataVc didSelectContent:(NSString *)content type:(XLDataSelectViewControllerType)type{
    self.academicField.text = content;
}

@end
