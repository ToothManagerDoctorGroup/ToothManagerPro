//
//  UserInfoViewController.m
//  CRM
//
//  Created by TimTiger on 9/6/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "UserInfoViewController.h"
#import "SAMTextView.h"
#import "AccountManager.h"
#import "DBTableMode.h"
#import "UIImageView+WebCache.h"
#import "AccountManager.h"
#import "SVProgressHUD.h"
#import "NSDictionary+Extension.h"
#import "CRMHttpRequest+Doctor.h"
#import "NSString+Conversion.h"
#import "DBManager+Doctor.h"
#import "DBManager+User.h"
#import "QrCodeViewController.h"
#import "CRMMacro.h"
#import "UserInfoEditViewController.h"
#import "DoctorTool.h"

@interface UserInfoViewController () <CRMHttpRequestDoctorDelegate,UIActionSheetDelegate,UserInfoEditViewControllerDelegate>{
    __weak IBOutlet UITableViewCell *_jiangeCell;
    
}

@property (nonatomic, strong)Doctor *currentDoctor;//当前登录的医生

@property (nonatomic, copy)NSString *doctor_cv;
@property (nonatomic, copy)NSString *doctor_skills;

@end

@implementation UserInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _jiangeCell.backgroundColor = [UIColor colorWithRed:248.0f/255.0f green:248.0f/255.0f blue:248.0f/255.0f alpha:1];
    self.view.backgroundColor = [UIColor whiteColor];
    self.authTextView.placeholder = @"---";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    if (self.doctor) {
        self.title = [NSString stringWithFormat:@"%@的资料",self.doctor.doctor_name];
        self.departmentTextField.enabled = NO;
        self.phoneTextField.enabled = NO;
        self.hospitalTextField.enabled = NO;
        self.titleTextField.enabled = NO;
        self.degreeTextField.enabled = NO;
        self.authstatusTextField.enabled = NO;
        self.authTextView.editable = NO;
        self.nicknameTextField.text = self.doctor.doctor_name;
        if (self.needGet || [NSString isEmptyString:self.doctor.doctor_dept]) {
            [[DoctorManager shareInstance] getDoctorListWithUserId:self.doctor.ckeyid successBlock:^{
                [SVProgressHUD showWithStatus:@"加载中..."];
            } failedBlock:^(NSError *error) {
                [SVProgressHUD showImage:nil status:error.localizedDescription];
            }];
        } else {
            [self refreshView];
        }
    } else {
        self.title = @"我的资料";
        [self setRightBarButtonWithTitle:@"保存"];
        UserObject *userobj = [[AccountManager shareInstance] currentUser];
        [self refreshView];
        [[DoctorManager shareInstance] getDoctorListWithUserId:userobj.userid successBlock:^{
            [SVProgressHUD showWithStatus:@"加载中..."];
        } failedBlock:^(NSError *error) {
            [SVProgressHUD showImage:nil status:error.localizedDescription];
        }];
    }
    
    self.birthDayTextField.mode = TextFieldInputModeDatePicker;
    
    
    NSMutableArray *selectSexArray = [NSMutableArray arrayWithObjects:@"男",@"女" ,nil];
    self.sexTextField.mode = TextFieldInputModePicker;
    self.sexTextField.pickerDataSource = selectSexArray;
    
   NSMutableArray  *selectRepeatArray = [NSMutableArray arrayWithObjects:@"大专",@"本科",@"硕士",@"博士", nil];
    self.degreeTextField.mode = TextFieldInputModePicker;
    self.degreeTextField.pickerDataSource = selectRepeatArray;
    
    NSMutableArray *selectRepeatArray1 = [NSMutableArray arrayWithObjects:@"医师",@"主治医师",@"副主任医师",@"主任医师", nil];
    self.titleTextField.mode = TextFieldInputModePicker;
    self.titleTextField.pickerDataSource = selectRepeatArray1;
    
    NSMutableArray *selectRepeatArray2 = [NSMutableArray arrayWithObjects:@"口腔综合科",@"口腔科",@"正畸科",@"儿童口腔科",@"颌面外科",@"牙周科",@"牙体牙髓科",@"口腔黏膜科",@"种植科",@"口腔预防科",@"其他", nil];
    self.departmentTextField.mode = TextFieldInputModePicker;
    self.departmentTextField.pickerDataSource = selectRepeatArray2;
    
    //职业资格证手势【暂时】
    UITapGestureRecognizer *choseImgGesture = [[UITapGestureRecognizer alloc]init];
    [choseImgGesture addTarget:self action:@selector(choseImage:)];
    [self.authImageView setUserInteractionEnabled:YES];
    [self.authImageView addGestureRecognizer:choseImgGesture];
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
}
-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [self.nicknameTextField resignFirstResponder];
    [self.departmentTextField resignFirstResponder];
    [self.phoneTextField resignFirstResponder];
    [self.titleTextField resignFirstResponder];
    [self.hospitalTextField resignFirstResponder];
    [self.degreeTextField resignFirstResponder];
    [self.birthDayTextField resignFirstResponder];
    [self.sexTextField resignFirstResponder];
}

- (void)initData {
    [super initData];
}

- (void)refreshView {
    [super refreshView];
    if (self.doctor) {
        self.departmentTextField.text = self.doctor.doctor_dept;
        self.phoneTextField.text = self.doctor.doctor_phone;
        self.hospitalTextField.text = self.doctor.doctor_hospital;
        self.titleTextField.text = self.doctor.doctor_position;
        
        self.degreeTextField.text = self.doctor.doctor_degree;
        self.authstatusTextField.text = [UserObject authStringWithStatus:self.doctor.auth_status];
        self.authTextView.text = self.doctor.auth_text;
        [self.authImageView sd_setImageWithURL:[NSURL URLWithString:self.doctor.auth_pic] placeholderImage:[UIImage imageNamed:@"header"]];
    } else {
        self.nicknameTextField.text = self.currentDoctor.doctor_name;
        self.departmentTextField.text = self.currentDoctor.doctor_dept;
        self.phoneTextField.text = self.currentDoctor.doctor_phone;
        self.hospitalTextField.text = self.currentDoctor.doctor_hospital;
        self.titleTextField.text = self.currentDoctor.doctor_position;
        self.degreeTextField.text = self.currentDoctor.doctor_degree;
        self.authstatusTextField.text = [UserObject authStringWithStatus:self.currentDoctor.auth_status];
        self.authTextView.text = self.currentDoctor.auth_text;
        
        [self.authImageView sd_setImageWithURL:[NSURL URLWithString:self.currentDoctor.auth_pic] placeholderImage:[UIImage imageNamed:@"header"]];
        
        if ([self.currentDoctor.doctor_gender isEqualToString:@"1"]) {
            self.sexTextField.text = @"男";
        }else{
            self.sexTextField.text = @"女";
        }
        self.birthDayTextField.text = self.currentDoctor.doctor_birthday;
        
//        UserObject *userobj = [[AccountManager shareInstance] currentUser];
//        self.nicknameTextField.text = userobj.name;
//        self.departmentTextField.text = userobj.department;
//        self.phoneTextField.text = userobj.phone;
//        self.hospitalTextField.text = userobj.hospitalName;
//        self.titleTextField.text = userobj.title;
//        self.degreeTextField.text = userobj.degree;
//        self.authstatusTextField.text = [UserObject authStringWithStatus:userobj.authStatus];
//        self.authTextView.text = userobj.authText;
//
//        [self.authImageView sd_setImageWithURL:[NSURL URLWithString:userobj.authPic]];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)onRightButtonAction:(id)sender {
    NSLog(@"Save");
    UserObject *userobj = [[AccountManager shareInstance] currentUser];
    Doctor *doctor = [[Doctor alloc]init];
    [doctor setCkeyid:userobj.userid];
    [doctor setUser_id:userobj.userid];
    [doctor setDoctor_name:self.nicknameTextField.text];
    [doctor setDoctor_dept:self.departmentTextField.text];
    [doctor setDoctor_phone:self.phoneTextField.text];
    [doctor setDoctor_hospital:self.hospitalTextField.text];
    [doctor setDoctor_position:self.titleTextField.text];
    [doctor setDoctor_degree:self.degreeTextField.text];
    [doctor setAuth_status:userobj.authStatus];
    [doctor setAuth_text:userobj.authText];
    [doctor setDoctor_certificate:@""];  //证书，此处我也不知道要传什么，暂时传空，不能为nil
    [doctor setIsopen:YES];
    if ([self.sexTextField.text isEqualToString:@"男"]) {
        [doctor setDoctor_gender:@"1"];
    }else{
        [doctor setDoctor_gender:@"0"];
    }
    
    [doctor setDoctor_birthday:self.birthDayTextField.text];
    if (self.doctor_cv == nil) {
        [doctor setDoctor_cv:self.currentDoctor.doctor_cv];
    }else{
        [doctor setDoctor_cv:self.doctor_cv];
    }
    if (self.doctor_skills == nil) {
        [doctor setDoctor_skill:self.currentDoctor.doctor_skill];
    }else{
        [doctor setDoctor_skill:self.doctor_skills];
    }
    
    
    [[AccountManager shareInstance] updateUserInfo:doctor successBlock:^{
        [SVProgressHUD showWithStatus:@"正在更新个人信息..."];
    } failedBlock:^(NSError *error){
        [SVProgressHUD showTextWithStatus:error.localizedDescription];
    }];
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
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
        case 2:
        {}
            break;
            
        default:
            break;
    }
}

- (void)setAuthImage:(UIImage *)image
{
    /*
    if (self.authImageView.image != nil) {
        [self.authImageView setImage:nil];
    }
    [self.authImageView setImage:image];
    */
    
    [self.iconImageView setImage:image];
}

#pragma mark - Button Actions
- (void)onBackButtonAction:(id)sender {
    if(self.isZhuCe == YES){
        [self postNotificationName:SignInSuccessNotification object:nil];
        return;
    }
    [self popViewControllerAnimated:YES];
}
- (IBAction)qrCodeAction:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    QrCodeViewController *qrVC = [storyBoard instantiateViewControllerWithIdentifier:@"QrCodeViewController"];
    [self.navigationController pushViewController:qrVC animated:YES];
}

- (IBAction)icon:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                              destructiveButtonTitle:@"从相册选择"
                                                   otherButtonTitles:@"摄像头拍摄", nil];
    [actionSheet setActionSheetStyle:UIActionSheetStyleDefault];
    [actionSheet showInView:self.view];
}

#pragma mark -个人简介
- (IBAction)personalIntroduceAction:(id)sender {
    UserInfoEditViewController *editVc = [[UserInfoEditViewController alloc] init];
    editVc.title = @"个人简介";
    editVc.delegate = self;
    if (self.doctor_cv) {
        editVc.targetStr = self.doctor_cv;
    }else{
        editVc.targetStr = self.currentDoctor.doctor_cv;
    }
    editVc.hidesBottomBarWhenPushed = YES;
    [self pushViewController:editVc animated:YES];
    
}

#pragma mark -个人技能
- (IBAction)skillsAction:(id)sender {
    UserInfoEditViewController *editVc = [[UserInfoEditViewController alloc] init];
    editVc.title = @"擅长项目";
    editVc.delegate = self;
    if (self.doctor_skills) {
        editVc.targetStr = self.doctor_skills;
    }else{
        editVc.targetStr = self.currentDoctor.doctor_skill;
    }
    editVc.hidesBottomBarWhenPushed = YES;
    [self pushViewController:editVc animated:YES];
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
//    [[AccountManager shareInstance] uploadUserAvatar:imageData withUserid:[AccountManager currentUserid]];
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"上传中..."];
    [DoctorTool composeTeacherHeadImg:tempImage userId:[[AccountManager shareInstance] currentUser].userid success:^{
        //清除图片缓存
        [[SDImageCache sharedImageCache] cleanDisk];
        [[SDImageCache sharedImageCache] clearMemory];
        
        [weakSelf setAuthImage:tempImage];
        [SVProgressHUD dismiss];
        NSLog(@"上传图片成功");
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"上传图片失败%@",error);
    }];
    
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.nicknameTextField resignFirstResponder];
    [self.departmentTextField resignFirstResponder];
    [self.phoneTextField resignFirstResponder];
    [self.hospitalTextField resignFirstResponder];
    [self.titleTextField resignFirstResponder];
    [self.degreeTextField resignFirstResponder];
    [self.authTextView resignFirstResponder];
    [self.birthDayTextField resignFirstResponder];
    [self.sexTextField resignFirstResponder];
}

#pragma mark -
#pragma mark CRMHttpRequestPersonalCenterDelegate
- (void)updateUserInfoSuccessWithResult:(NSDictionary *)result
{
//    [SVProgressHUD dismiss];
    if ([result integerForKey:@"Code"] == 200) {
        [SVProgressHUD showImage:nil status:@"个人消息更新成功"];
        
        UserObject *userobj = [[AccountManager shareInstance] currentUser];
        Doctor *doctor = [Doctor DoctorFromDoctorResult:result];

        [userobj setName:self.nicknameTextField.text];
        [userobj setDepartment:self.departmentTextField.text];
        [userobj setPhone:self.phoneTextField.text];
        [userobj setHospitalName:self.hospitalTextField.text];
        [userobj setTitle:self.titleTextField.text];
        [userobj setDegree:self.degreeTextField.text];
        [userobj setAuthStatus:userobj.authStatus];
        [userobj setAuthText:userobj.authText];
        
        [[DBManager shareInstance] updateUserWithUserObject:userobj];

        if(self.isZhuCe == NO){
            [self popViewControllerAnimated:YES];
        }else{
            [self postNotificationName:SignInSuccessNotification object:nil];
        }
    } else {
        [SVProgressHUD showImage:nil status:@"个人消息更新失败"];
    }
}

- (void)updateUserInfoFailedWithError:(NSError *)error
{
    [SVProgressHUD showImage:nil status:error.localizedDescription];
}

//获取用户的医生列表
- (void)getDoctorListSuccessWithResult:(NSDictionary *)result {
    [SVProgressHUD dismiss];
    NSArray *dicArray = [result objectForKey:@"Result"];
    if (dicArray && dicArray.count > 0) {
        for (NSDictionary *dic in dicArray) {
            if (self.doctor) {
                Doctor *tmpDoctor = [Doctor DoctorFromDoctorResult:dic];
                [[DBManager shareInstance] updateDoctorWithDoctor:tmpDoctor];
                self.doctor = tmpDoctor;
                if(self.doctor.doctor_image.length > 0){
                    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.doctor.doctor_image] placeholderImage:[UIImage imageNamed:@"header_defult"] options:SDWebImageRefreshCached];
                }else{
                    [self.iconImageView setImage:[UIImage imageNamed:@"user_icon"]];
                }
            } else {
                
                Doctor *doctor = [Doctor DoctorFromDoctorResult:dic];
                self.currentDoctor = doctor;
                if(doctor.doctor_image.length > 0){
                    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:doctor.doctor_image] placeholderImage:[UIImage imageNamed:@"header_defult"] options:SDWebImageRefreshCached];
                }else{
                    [self.iconImageView setImage:[UIImage imageNamed:@"user_icon"]];
                }
            }
            [self refreshView];
            return;
        }
    }
}
- (void)getDoctorListFailedWithError:(NSError *)error {
    [SVProgressHUD showImage:nil status:error.localizedDescription];
}

#pragma mark -UserInfoEditViewControllerDelegate
- (void)editViewController:(UserInfoEditViewController *)editVc didUpdateUserInfoWithStr:(NSString *)str type:(EditViewControllerType)type{
    if (type == EditViewControllerTypeSkill) {
        NSLog(@"个人技能修改成功");
        self.doctor_skills = str;
    }else {
        NSLog(@"个人描述修改成功");
        self.doctor_cv = str;
    }
}

@end
