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
#import "XLAvatarBrowser.h"
#import "XLDataSelectViewController.h"

@interface UserInfoViewController () <CRMHttpRequestDoctorDelegate,UIActionSheetDelegate,UserInfoEditViewControllerDelegate,XLDataSelectViewControllerDelegate>{
    __weak IBOutlet UITableViewCell *_jiangeCell;
    
}
@property (weak, nonatomic) IBOutlet UIImageView *iconArrow;
@property (weak, nonatomic) IBOutlet UIImageView *auTxtArrow;
@property (weak, nonatomic) IBOutlet UIImageView *sexArrow;
@property (weak, nonatomic) IBOutlet UIImageView *departmentArrow;
@property (weak, nonatomic) IBOutlet UIImageView *professionArrow;
@property (weak, nonatomic) IBOutlet UIImageView *degreeArrow;
@property (weak, nonatomic) IBOutlet UIImageView *descArrow;
@property (weak, nonatomic) IBOutlet UIImageView *skillArrow;


@property (nonatomic, strong)Doctor *currentDoctor;//当前登录的医生

/**
 *  线程队列,创建子线程
 */
@property (nonatomic, strong)NSOperationQueue *opQueue;


@property (nonatomic, copy)NSString *doctor_cv;
@property (nonatomic, copy)NSString *doctor_skills;

@end

@implementation UserInfoViewController

- (NSOperationQueue *)opQueue{
    if (!_opQueue) {
        _opQueue = [[NSOperationQueue alloc] init];
    }
    return _opQueue;
}

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
    
    _jiangeCell.backgroundColor = [UIColor colorWithRed:248.0f/255.0f green:248.0f/255.0f blue:248.0f/255.0f alpha:1];
    self.view.backgroundColor = [UIColor whiteColor];
    self.iconImageView.layer.cornerRadius = 25;
    self.iconImageView.layer.masksToBounds = YES;
    self.authTextView.placeholder = @"---";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    if (self.doctor) {
        [self hideArrow];
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
            self.view.userInteractionEnabled = NO;
            [[DoctorManager shareInstance] getDoctorListWithUserId:self.doctor.ckeyid successBlock:^{
                [SVProgressHUD showWithStatus:@"加载中..."];
            } failedBlock:^(NSError *error) {
                [SVProgressHUD showImage:nil status:error.localizedDescription];
            }];
        } else {
            [self refreshView];
        }
    } else {
        [self showArrow];
        
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
    
    self.sexTextField.clearButtonMode = UITextFieldViewModeNever;
    self.degreeTextField.clearButtonMode = UITextFieldViewModeNever;
    self.titleTextField.clearButtonMode = UITextFieldViewModeNever;
    self.departmentTextField.clearButtonMode = UITextFieldViewModeNever;
    
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
        self.nicknameTextField.text = self.doctor.doctor_name;
        self.departmentTextField.text = self.doctor.doctor_dept;
        self.phoneTextField.text = self.doctor.doctor_phone;
        self.hospitalTextField.text = self.doctor.doctor_hospital;
        self.titleTextField.text = self.doctor.doctor_position;
        
        self.degreeTextField.text = self.doctor.doctor_degree;
        self.authstatusTextField.text = [UserObject authStringWithStatus:self.doctor.auth_status];
        self.authTextView.text = self.doctor.auth_text;
        [self.authImageView sd_setImageWithURL:[NSURL URLWithString:self.doctor.auth_pic] placeholderImage:[UIImage imageNamed:@"header"]];
        
        if ([self.doctor.doctor_gender isEqualToString:@"1"]) {
            self.sexTextField.text = @"男";
        }else{
            self.sexTextField.text = @"女";
        }
        
        //获取年份
        NSInteger birthYear = [[self.doctor.doctor_birthday substringToIndex:4] integerValue];
        self.birthDayTextField.text = [NSString stringWithFormat:@"%ld",(long)([self getYear] - birthYear)];
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
        
        //获取年份
        NSInteger birthYear = [[self.currentDoctor.doctor_birthday substringToIndex:4] integerValue];
        self.birthDayTextField.text = [NSString stringWithFormat:@"%ld",[self getYear] - birthYear];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //添加监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
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
    //计算出生年份
    NSInteger yearCount = [self getYear] - [self.birthDayTextField.text integerValue];
    [doctor setDoctor_birthday:[NSString stringWithFormat:@"%ld-01-01",yearCount]];
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
    qrVC.isDoctor = YES;
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

        [SVProgressHUD showSuccessWithStatus:@"图片上传成功"];
        
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error);
        [SVProgressHUD showErrorWithStatus:@"图片上传失败"];
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

- (void)keyboardWillShow:(CGFloat)keyboardHeight {
    static BOOL flag = NO;
    if (flag == YES || self.navigationController.topViewController != self) {
        return;
    }
    flag = YES;
    
    if ([self.sexTextField isFirstResponder]) {
        [self.sexTextField resignFirstResponder];
        XLDataSelectViewController *dataSelectVc = [[XLDataSelectViewController alloc] initWithStyle:UITableViewStyleGrouped];
        dataSelectVc.type = XLDataSelectViewControllerSex;
        dataSelectVc.currentContent = self.sexTextField.text;
        dataSelectVc.delegate = self;
        [self pushViewController:dataSelectVc animated:YES];
    }else if ([self.degreeTextField isFirstResponder]){
        [self.degreeTextField resignFirstResponder];
        XLDataSelectViewController *dataSelectVc = [[XLDataSelectViewController alloc] initWithStyle:UITableViewStyleGrouped];
        dataSelectVc.type = XLDataSelectViewControllerDegree;
        dataSelectVc.currentContent = self.degreeTextField.text;
        dataSelectVc.delegate = self;
        [self pushViewController:dataSelectVc animated:YES];
    }else if ([self.departmentTextField isFirstResponder]){
        [self.departmentTextField resignFirstResponder];
        XLDataSelectViewController *dataSelectVc = [[XLDataSelectViewController alloc] initWithStyle:UITableViewStyleGrouped];
        dataSelectVc.type = XLDataSelectViewControllerDepartment;
        dataSelectVc.currentContent = self.departmentTextField.text;
        dataSelectVc.delegate = self;
        [self pushViewController:dataSelectVc animated:YES];
    }else if ([self.titleTextField isFirstResponder]){
        [self.titleTextField resignFirstResponder];
        XLDataSelectViewController *dataSelectVc = [[XLDataSelectViewController alloc] initWithStyle:UITableViewStyleGrouped];
        dataSelectVc.type = XLDataSelectViewControllerProfressional;
        dataSelectVc.currentContent = self.titleTextField.text;
        dataSelectVc.delegate = self;
        [self pushViewController:dataSelectVc animated:YES];
    }
    flag = NO;
}

#pragma mark -
#pragma mark CRMHttpRequestPersonalCenterDelegate
- (void)updateUserInfoSuccessWithResult:(NSDictionary *)result
{
    if ([result integerForKey:@"Code"] == 200) {
        [SVProgressHUD showImage:nil status:@"个人消息更新成功"];
        
        UserObject *userobj = [[AccountManager shareInstance] currentUser];
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
                
                [self.iconImageView setImage:[UIImage imageNamed:@"user_icon"]];
                if(self.doctor.doctor_image.length > 0){
                    [self downloadImageWithImageUrl:self.doctor.doctor_image];
                }
            } else {
                
                Doctor *doctor = [Doctor DoctorFromDoctorResult:dic];
                self.currentDoctor = doctor;
                
                [self.iconImageView setImage:[UIImage imageNamed:@"user_icon"]];
                
                if(doctor.doctor_image.length > 0){
                    [self downloadImageWithImageUrl:doctor.doctor_image];
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

#pragma mark - XLDataSelectViewControllerDelegate
- (void)dataSelectViewController:(XLDataSelectViewController *)dataVc didSelectContent:(NSString *)content type:(XLDataSelectViewControllerType)type{
    if (type == XLDataSelectViewControllerSex) {
        self.sexTextField.text = content;
    }else if (type == XLDataSelectViewControllerDegree){
        self.degreeTextField.text = content;
    }else if (type == XLDataSelectViewControllerDepartment){
        self.departmentTextField.text = content;
    }else if (type == XLDataSelectViewControllerProfressional){
        self.titleTextField.text = content;
    }
}

#pragma mark - 隐藏和显示箭头
- (void)hideArrow{
    self.iconArrow.hidden = YES;
    self.auTxtArrow.hidden = YES;
    self.sexArrow.hidden = YES;
    self.departmentArrow.hidden = YES;
    self.professionArrow.hidden = YES;
    self.degreeArrow.hidden = YES;
    self.descArrow.hidden = YES;
    self.skillArrow.hidden = YES;
}

- (void)showArrow{
    self.iconArrow.hidden = NO;
    self.auTxtArrow.hidden = NO;
    self.sexArrow.hidden = NO;
    self.departmentArrow.hidden = NO;
    self.professionArrow.hidden = NO;
    self.degreeArrow.hidden = NO;
    self.descArrow.hidden = NO;
    self.skillArrow.hidden = NO;
}


- (void)downloadImageWithImageUrl:(NSString *)imageStr{
    
    // 1.创建多线程
    NSBlockOperation *downOp = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:0.5];
        //执行下载操作
        NSURL *url = [NSURL URLWithString:imageStr];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        
        //回到主线程更新ui
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.iconImageView.image = image;
        }];
    }];
    // 2.必须将任务添加到队列中才能执行
    [self.opQueue addOperation:downOp];
    
}

- (NSInteger)getYear{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:[NSDate date]];
    NSInteger year = [dateComponent year];
    return year;
}

@end
