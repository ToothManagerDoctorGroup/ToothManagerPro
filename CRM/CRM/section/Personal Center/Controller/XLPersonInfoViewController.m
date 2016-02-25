//
//  XLPersonInfoViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/2/25.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLPersonInfoViewController.h"
#import "DoctorTool.h"
#import "AccountManager.h"
#import "DoctorInfoModel.h"
#import "UIImageView+WebCache.h"
#import "QrCodeViewController.h"
#import "XLDataSelectViewController.h"
#import "CRMHttpRespondModel.h"
#import "XLCommonEditViewController.h"
#import "DBManager+User.h"

@interface XLPersonInfoViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,XLDataSelectViewControllerDelegate,XLCommonEditViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;//头像
@property (weak, nonatomic) IBOutlet UITextField *userName;//姓名
@property (weak, nonatomic) IBOutlet UITextField *userSex;//性别
@property (weak, nonatomic) IBOutlet UITextField *userAge;//年龄
@property (weak, nonatomic) IBOutlet UITextField *userDepartment;//科室
@property (weak, nonatomic) IBOutlet UITextField *userPhone;//电话
@property (weak, nonatomic) IBOutlet UITextField *userHospital;//医院
@property (weak, nonatomic) IBOutlet UITextField *userAcademicTitle;//职称
@property (weak, nonatomic) IBOutlet UITextField *userDegree;//学历
@property (weak, nonatomic) IBOutlet UITextField *userDesc;//个人简介
@property (weak, nonatomic) IBOutlet UITextField *userSkills;//擅长项目

@property (nonatomic, strong)DoctorInfoModel *currentDoctor;

/**
 *  线程队列,创建子线程
 */
@property (nonatomic, strong)NSOperationQueue *opQueue;

@end

@implementation XLPersonInfoViewController

- (NSOperationQueue *)opQueue{
    if (!_opQueue) {
        _opQueue = [[NSOperationQueue alloc] init];
    }
    return _opQueue;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
//初始化数据
- (void)initData{
    [DoctorTool requestDoctorInfoWithDoctorId:[AccountManager currentUserid] success:^(DoctorInfoModel *doctorInfo) {
        
        self.currentDoctor = doctorInfo;
        [self setUpViewDataWithDoctor:doctorInfo];
        
    } failure:^(NSError *error) {
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}
//初始化视图
- (void)initView{
    self.iconImageView.layer.cornerRadius = 25;
    self.iconImageView.layer.masksToBounds = YES;
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    self.title = @"我的资料";
}
//显示数据
- (void)setUpViewDataWithDoctor:(DoctorInfoModel *)doctorInfo{
    //显示数据
    self.iconImageView.image = [UIImage imageNamed:@"user_icon"];
    [self downloadImageWithImageUrl:doctorInfo.doctor_image];
    
    self.userName.text = doctorInfo.doctor_name;
    self.userSex.text = [doctorInfo.doctor_gender isEqualToString:@"0"] ? @"女" : @"男";
    //计算出生年份
    NSInteger birthYear = [[doctorInfo.doctor_birthday substringToIndex:4] integerValue];
    self.userAge.text = [NSString stringWithFormat:@"%d",(int)([self getYear] - birthYear)];
    self.userDepartment.text = doctorInfo.doctor_dept;
    self.userPhone.text = doctorInfo.doctor_phone;
    self.userHospital.text = doctorInfo.doctor_hospital;
    self.userAcademicTitle.text = doctorInfo.doctor_position;
    self.userDegree.text = doctorInfo.doctor_degree;
    self.userDesc.text = doctorInfo.doctor_cv;
    self.userSkills.text = doctorInfo.doctor_skill;
}

#pragma mark - UITableViewDataSource/UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //上传头像
            [self uploadIconImage];
        }else{
            //我的二维码
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
            QrCodeViewController *qrVC = [storyBoard instantiateViewControllerWithIdentifier:@"QrCodeViewController"];
            qrVC.isDoctor = YES;
            [self.navigationController pushViewController:qrVC animated:YES];
        }
    }else{
        if (indexPath.row == 0) {
            [self updateInfoWithPlaceHolder:@"请填写姓名" title:@"姓名" content:self.userName.text isNumberKeyBoard:NO];
        }else if (indexPath.row == 1){
            [self updateWithChooseType:XLDataSelectViewControllerSex content:self.userSex.text];
        }else if (indexPath.row == 2){
            [self updateInfoWithPlaceHolder:@"请填写年龄" title:@"年龄" content:self.userAge.text isNumberKeyBoard:YES];
        }else if (indexPath.row == 3){
            [self updateWithChooseType:XLDataSelectViewControllerDepartment content:self.userDepartment.text];
        }else if (indexPath.row == 4){
            [self updateInfoWithPlaceHolder:@"请填写电话" title:@"电话" content:self.userPhone.text isNumberKeyBoard:YES];
        }else if (indexPath.row == 5){
            [self updateInfoWithPlaceHolder:@"请填写医院名称" title:@"医院" content:self.userHospital.text isNumberKeyBoard:NO];
        }else if (indexPath.row == 6){
            [self updateWithChooseType:XLDataSelectViewControllerProfressional content:self.userAcademicTitle.text];
        }else if (indexPath.row == 7){
            [self updateWithChooseType:XLDataSelectViewControllerDegree content:self.userDegree.text];
        }else if (indexPath.row == 8){
            [self updateInfoWithPlaceHolder:@"请填写个人简介" title:@"个人简介" content:self.userDesc.text isNumberKeyBoard:NO];
        }else if (indexPath.row == 9){
            [self updateInfoWithPlaceHolder:@"请填写擅长项目" title:@"擅长项目" content:self.userSkills.text isNumberKeyBoard:NO];
        }
    }
}
#pragma mark - 修改需要自己填写的资料
- (void)updateInfoWithPlaceHolder:(NSString *)placeHolder title:(NSString *)title content:(NSString *)content isNumberKeyBoard:(BOOL)isNumberKeyBoard{
    XLCommonEditViewController *editVc = [[XLCommonEditViewController alloc] init];
    editVc.delegate = self;
    editVc.placeHolder = placeHolder;
    editVc.content = content;
    editVc.title = title;
    editVc.keyboardType = isNumberKeyBoard == YES ? UIKeyboardTypeNumberPad : UIKeyboardTypeDefault;
    [self pushViewController:editVc animated:YES];
}
#pragma mark - 修改需要选择的资料
- (void)updateWithChooseType:(XLDataSelectViewControllerType)type content:(NSString *)content{
    XLDataSelectViewController *dataSelectVc = [[XLDataSelectViewController alloc] initWithStyle:UITableViewStyleGrouped];
    dataSelectVc.type = type;
    dataSelectVc.currentContent = content;
    dataSelectVc.delegate = self;
    [self pushViewController:dataSelectVc animated:YES];
}

#pragma mark - 上传头像
- (void)uploadIconImage{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                              destructiveButtonTitle:@"从相册选择"
                                                   otherButtonTitles:@"摄像头拍摄", nil];
    [actionSheet setActionSheetStyle:UIActionSheetStyleDefault];
    [actionSheet showInView:self.view];
}
#pragma mark ActionSheet Delegate
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

#pragma mark - UIImagePicker Delegate
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
    [DoctorTool composeTeacherHeadImg:tempImage userId:[[AccountManager shareInstance] currentUser].userid success:^{
        weakSelf.iconImageView.image = tempImage;
        [SVProgressHUD showSuccessWithStatus:@"图片上传成功"];
        
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error);
        [SVProgressHUD showErrorWithStatus:@"图片上传失败"];
    }];
}
#pragma mark - XLDataSelectViewControllerDelegate
- (void)dataSelectViewController:(XLDataSelectViewController *)dataVc didSelectContent:(NSString *)content type:(XLDataSelectViewControllerType)type{

    if (type == XLDataSelectViewControllerSex) {
        self.currentDoctor.doctor_gender = [content isEqualToString:@"男"] ? @"1" : @"0";
    }else if (type == XLDataSelectViewControllerDegree){
        self.currentDoctor.doctor_degree = content;
    }else if (type == XLDataSelectViewControllerDepartment){
        self.currentDoctor.doctor_dept = content;
    }else if (type == XLDataSelectViewControllerProfressional){
        self.currentDoctor.doctor_position = content;
    }
    [self uploadDoctorInfo];
}
#pragma mark - XLCommonEditViewControllerDelegate
- (void)commonEditViewController:(XLCommonEditViewController *)editVc content:(NSString *)content title:(NSString *)title{
    if ([title isEqualToString:@"姓名"]) {
        self.currentDoctor.doctor_name = content;
    }else if ([title isEqualToString:@"年龄"]){
        //计算出生年份
        NSInteger yearCount = [self getYear] - [content integerValue];
        self.currentDoctor.doctor_birthday = [NSString stringWithFormat:@"%ld-01-01",yearCount];
    }else if ([title isEqualToString:@"电话"]){
        self.currentDoctor.doctor_phone = content;
    }else if ([title isEqualToString:@"医院"]){
        self.currentDoctor.doctor_hospital = content;
    }else if ([title isEqualToString:@"个人简介"]){
        self.currentDoctor.doctor_cv = content;
    }else if ([title isEqualToString:@"职业技能"]){
        self.currentDoctor.doctor_skill = content;
    }
    
    [self uploadDoctorInfo];
}
#pragma mark - 上传个人信息
- (void)uploadDoctorInfo{
    //上传数据
    [SVProgressHUD showWithStatus:@"正在修改"];
    [DoctorTool updateUserInfoWithDoctorInfoModel:self.currentDoctor ckeyId:[AccountManager currentUserid] success:^(CRMHttpRespondModel *respond) {
        if ([respond.code integerValue] == 200) {
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            [self setUpViewDataWithDoctor:self.currentDoctor];
            
            //更新数据库中的信息
            UserObject *userobj = [[AccountManager shareInstance] currentUser];
            [userobj setName:self.userName.text];
            [userobj setDepartment:self.userDepartment.text];
            [userobj setPhone:self.userPhone.text];
            [userobj setHospitalName:self.userHospital.text];
            [userobj setTitle:self.userAcademicTitle.text];
            [userobj setDegree:self.userDegree.text];
            [userobj setAuthStatus:userobj.authStatus];
            [userobj setAuthText:userobj.authText];
            
            [[DBManager shareInstance] updateUserWithUserObject:userobj];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"修改失败"];
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}

#pragma mark - 获取年份
- (NSInteger)getYear{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:[NSDate date]];
    NSInteger year = [dateComponent year];
    return year;
}
#pragma mark - 手动下载图片
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
