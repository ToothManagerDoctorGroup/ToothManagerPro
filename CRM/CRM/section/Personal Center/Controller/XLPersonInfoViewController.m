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
#import "PatientManager.h"
#import "NSString+Conversion.h"
#import "XLContentWriteViewController.h"
#import "MJRefresh.h"
#import "CRMUserDefalut.h"
#import "UINavigationItem+Margin.h"
#import "SettingMacro.h"

@interface XLPersonInfoViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,XLDataSelectViewControllerDelegate,XLCommonEditViewControllerDelegate,XLContentWriteViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;//头像
@property (weak, nonatomic) IBOutlet UITextField *userName;//姓名
@property (weak, nonatomic) IBOutlet UITextField *userSex;//性别
@property (weak, nonatomic) IBOutlet UITextField *userAge;//年龄
@property (weak, nonatomic) IBOutlet UITextField *userDepartment;//科室
@property (weak, nonatomic) IBOutlet UITextField *userHospital;//医院
@property (weak, nonatomic) IBOutlet UITextField *userAcademicTitle;//职称
@property (weak, nonatomic) IBOutlet UITextField *userDegree;//学历
@property (weak, nonatomic) IBOutlet UITextField *userDesc;//个人简介
@property (weak, nonatomic) IBOutlet UITextField *userSkills;//擅长项目

@property (nonatomic, strong)DoctorInfoModel *currentDoctor;

@end

@implementation XLPersonInfoViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加下拉刷新
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRefreshAction)];
//    self.tableView.header.updatedTimeHidden = YES;
}
#pragma mark -下拉刷新
- (void)headerRefreshAction{
    //刷新数据
    [DoctorTool requestDoctorInfoWithDoctorId:[AccountManager currentUserid] success:^(DoctorInfoModel *doctorInfo) {
        [self.tableView.header endRefreshing];
        
        self.currentDoctor = doctorInfo;
        [self setUpViewDataWithDoctor:doctorInfo];
        
        //更新数据库中的信息
        [self updateUserInfo];
        
    } failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}

//初始化数据
- (void)initData{
    //加载本地数据
    UserObject *user = [AccountManager shareInstance].currentUser;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:user.img] placeholderImage:[UIImage imageNamed:@"user_icon"] options:SDWebImageRefreshCached];
    
    self.userName.text = user.name;
    self.userSex.text = [user.doctor_gender isEqualToString:@"0"] ? @"女" : @"男";
    //计算出生年份
    if ([user.doctor_birthday isNotEmpty]) {
        NSInteger birthYear = [[user.doctor_birthday substringToIndex:4] integerValue];
        self.userAge.text = [NSString stringWithFormat:@"%d",(int)([self getYear] - birthYear)];
    }
    self.userDepartment.text = user.department;
    self.userHospital.text = user.hospitalName;
    self.userAcademicTitle.text = user.title;
    self.userDegree.text = user.degree;
    self.userDesc.text = user.doctor_cv;
    self.userSkills.text = user.doctor_skill;
    
    self.currentDoctor = [[DoctorInfoModel alloc] initWithUserObj:user];
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
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:doctorInfo.doctor_image] placeholderImage:[UIImage imageNamed:@"user_icon"]];
    
    self.userName.text = doctorInfo.doctor_name;
    self.userSex.text = [doctorInfo.doctor_gender isEqualToString:@"0"] ? @"女" : @"男";
    //计算出生年份
    NSInteger birthYear = [[doctorInfo.doctor_birthday substringToIndex:4] integerValue];
    NSString *ageStr = [NSString stringWithFormat:@"%d",(int)([self getYear] - birthYear)];
    self.userAge.text = [ageStr intValue] == 0 ? @"" : ageStr;
    self.userDepartment.text = doctorInfo.doctor_dept;
    self.userHospital.text = doctorInfo.doctor_hospital;
    self.userAcademicTitle.text = doctorInfo.doctor_position;
    self.userDegree.text = doctorInfo.doctor_degree;
    self.userDesc.text = doctorInfo.doctor_cv;
    self.userSkills.text = doctorInfo.doctor_skill;
}

#pragma mark - UITableViewDataSource/UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
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
            [self updateInfoWithPlaceHolder:@"请填写姓名" title:@"修改姓名" content:self.userName.text isNumberKeyBoard:NO];
        }else if (indexPath.row == 1){
            [self updateWithChooseType:XLDataSelectViewControllerSex content:self.userSex.text];
        }else if (indexPath.row == 2){
            [self updateInfoWithPlaceHolder:@"请填写年龄" title:@"修改年龄" content:self.userAge.text isNumberKeyBoard:YES];
        }else if (indexPath.row == 3){
            [self updateWithChooseType:XLDataSelectViewControllerDepartment content:self.userDepartment.text];
        }else if (indexPath.row == 4){
            [self updateInfoWithPlaceHolder:@"请填写医院名称" title:@"医院" content:self.userHospital.text isNumberKeyBoard:NO];
        }else if (indexPath.row == 5){
            [self updateWithChooseType:XLDataSelectViewControllerProfressional content:self.userAcademicTitle.text];
        }else if (indexPath.row == 6){
            [self updateWithChooseType:XLDataSelectViewControllerDegree content:self.userDegree.text];
        }else if (indexPath.row == 7){
            [self updateSkillWithTitle:@"个人简介" content:self.userDesc.text placeHolder:@"请填写300字以内个人简介" limit:300];
        }else if (indexPath.row == 8){
            [self updateSkillWithTitle:@"擅长项目" content:self.userSkills.text placeHolder:@"请填写100字以内擅长项目" limit:100];
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

#pragma mark - 修改医生的个人简介和擅长项目
- (void)updateSkillWithTitle:(NSString *)title content:(NSString *)content placeHolder:(NSString *)placeHolder limit:(int)limit{
    XLContentWriteViewController *writeVc = [[XLContentWriteViewController alloc] init];
    writeVc.placeHolder = placeHolder;
    writeVc.title = title;
    writeVc.currentContent = content;
    writeVc.delegate = self;
    writeVc.limit = limit;
    [self pushViewController:writeVc animated:YES];
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
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex > 1) {
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    if (buttonIndex == 0) {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    } else if (buttonIndex == 1) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    [self presentViewController:picker animated:YES completion:^{
    }];
}

#pragma mark - 解决取消按钮靠左问题
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithCustomView:[UIView new]];
    [viewController.navigationItem setRightBarButtonItem:btn animated:NO];
}
#pragma mark - UIImagePicker Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (info != nil) {
        @autoreleasepool {
            UIImage* image = info[UIImagePickerControllerEditedImage];
            __weak typeof(self) weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf saveImage:image WithName:@"userAvatar"];
            });
        }
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
        if ([respond.code integerValue] == 200) {
            //清空原来图片的缓存
            [[SDImageCache sharedImageCache] removeImageForKey:[AccountManager shareInstance].currentUser.img];
            //清空二维码缓存
            NSString *qrcodeUrl = [CRMUserDefalut objectForKey:QRCODE_URL_KEY];
            if (qrcodeUrl) {
                [[SDImageCache sharedImageCache] removeImageForKey:qrcodeUrl];
                [CRMUserDefalut setObject:nil forKey:QRCODE_URL_KEY];
            }
            weakSelf.iconImageView.image = tempImage;
            [SVProgressHUD showSuccessWithStatus:@"图片上传成功"];
            //更新数据库中的imgUrl
            [[DBManager shareInstance] upDateUserHeaderImageUrlWithUserId:[AccountManager currentUserid] imageUrl:respond.result];
            //更新缓存中的imgUrl
            [AccountManager shareInstance].currentUser.img = respond.result;
            
        }else{
            [SVProgressHUD showImage:nil status:@"图片上传失败"];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showImage:nil status:@"图片上传失败"];
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
    if ([title isEqualToString:@"修改姓名"]) {
        if (![content isNotEmpty]) {
            [SVProgressHUD showImage:nil status:@"请输入姓名"];
            return;
        }
        //判断输入的姓名的长度是否合格
        if ([content charaterCount] > 32) {
            [SVProgressHUD showImage:nil status:@"姓名过长，请重新输入"];
            return;
        }
        self.currentDoctor.doctor_name = content;
        
    }else if ([title isEqualToString:@"修改年龄"]){
        if ([content integerValue] > 150) {
            [SVProgressHUD showImage:nil status:@"年龄无效，请重新输入"];
            return;
        }
        //计算出生年份
        NSInteger yearCount = [self getYear] - [content integerValue];
        self.currentDoctor.doctor_birthday = [NSString stringWithFormat:@"%ld-01-01",(long)yearCount];
    }else if ([title isEqualToString:@"电话"]){
        //验证电话是否合法
        BOOL ret = [NSString checkTelNumber:content];
        if (!ret) {
            [SVProgressHUD showImage:nil status:@"手机号无效，请重新输入"];
            return;
        }
        self.currentDoctor.doctor_phone = content;
    }else if ([title isEqualToString:@"医院"]){
        if (![content isNotEmpty]) {
            [SVProgressHUD showImage:nil status:@"请输入医院名称"];
            return;
        }
        //判断输入的姓名的长度是否合格
        if ([content charaterCount] > 100) {
            [SVProgressHUD showImage:nil status:@"医院名称过长，请重新输入"];
            return;
        }
        self.currentDoctor.doctor_hospital = content;
    }else if ([title isEqualToString:@"个人简介"]){
        self.currentDoctor.doctor_cv = content;
    }else if ([title isEqualToString:@"擅长项目"]){
        self.currentDoctor.doctor_skill = content;
    }
    
    [self uploadDoctorInfo];
}

#pragma mark - XLContentWriteViewControllerDelegate
- (void)contentWriteViewController:(XLContentWriteViewController *)contentVC didWriteContent:(NSString *)content{
    if ([contentVC.title isEqualToString:@"个人简介"]) {
        self.currentDoctor.doctor_cv = content;
    }else{
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
            [self updateUserInfo];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"修改失败"];
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}

- (void)updateUserInfo{
    //更新数据库中的信息
    UserObject *userobj = [[AccountManager shareInstance] currentUser];
    [userobj setName:self.userName.text];
    [userobj setDepartment:self.userDepartment.text];
    [userobj setPhone:userobj.phone];
    [userobj setHospitalName:self.userHospital.text];
    [userobj setTitle:self.userAcademicTitle.text];
    [userobj setDegree:self.userDegree.text];
    [userobj setAuthStatus:userobj.authStatus];
    [userobj setAuthText:userobj.authText];
    [userobj setImg:self.currentDoctor.doctor_image];
    
    [userobj setDoctor_birthday:self.currentDoctor.doctor_birthday];
    [userobj setDoctor_cv:self.currentDoctor.doctor_cv];
    [userobj setDoctor_gender:self.currentDoctor.doctor_gender];
    [userobj setDoctor_skill:self.currentDoctor.doctor_skill];
    [[DBManager shareInstance] updateUserWithUserObject:userobj];
    
}


#pragma mark - 获取年份
- (NSInteger)getYear{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:[NSDate date]];
    NSInteger year = [dateComponent year];
    return year;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
