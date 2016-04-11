//
//  AccountViewController.m
//  CRM
//
//  Created by lsz on 15/9/11.
//  Copyright (c) 2015年 TimTiger. All rights reserved.
//

#import "AccountViewController.h"
#import "SettingViewController.h"
#import "RepairDoctorViewController.h"
#import "MaterialsViewController.h"
#import "DBTableMode.h"
#import "AccountManager.h"
#import "DBManager+User.h"
#import "QrCodeViewController.h"
#import "DBManager+Doctor.h"
#import "ShuJuFenXiViewController.h"
#import "CommonMacro.h"
#import "UIImageView+WebCache.h"

#import "MyClinicViewController.h"
#import "MyBillViewController.h"
#import "WMPageController.h"
#import "PayedBillViewController.h"

#import "DoctorTool.h"
#import "DoctorInfoModel.h"

#import "CRMUserDefalut.h"
#import "CRMHttpRequest+Sync.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "Share.h"

#import "XLAvatarBrowser.h"
#import "XLMaterialsViewController.h"
#import "XLRepairDoctorViewController.h"
#import "XLDoctorLibraryViewController.h"
#import "UserProfileManager.h"
#import "XLDataAnalyseViewController.h"
#import "XLMessageTemplateTool.h"
#import "XLMessageTemplateViewController.h"
#import "XLPersonInfoViewController.h"
#import "AddressBoolTool.h"
#import "XLBaseSettingViewController.h"
#import "XLPersonalStepOneViewController.h"

#import "XLJoinTeamSegumentController.h"
#import "PatientManager.h"
#import "XLContactsViewController.h"
#import "XLBackUpViewController.h"
#import "DBManager+AutoSync.h"
#import "NSString+TTMAddtion.h"

@interface AccountViewController ()<UIAlertViewDelegate,UIActionSheetDelegate>{
    
    __weak IBOutlet UITableView *_tableView;
    IBOutlet UITableViewCell *_zhangHuCell;
    __weak IBOutlet UILabel *_nameLabel;
    __weak IBOutlet UILabel *_detailLabel;
    
    
    IBOutlet UITableViewCell *_doctorCell;
    IBOutlet UITableViewCell *_zhongZhiTiCell;
    IBOutlet UITableViewCell *_tiXingMuBanCell;
    IBOutlet UITableViewCell *_shuJuFenXiCell;
    IBOutlet UITableViewCell *_sheZhiCell;
    IBOutlet UITableViewCell *_myClinicCell;
    
    IBOutlet UITableViewCell *_shareCell;
    
    IBOutlet UITableViewCell *_myBillCell;
    __weak IBOutlet UIImageView *iconImageView;
    __weak IBOutlet UITableViewCell *_copyCell;
}

@property (weak, nonatomic) IBOutlet UIView *targetView;

@property (nonatomic, assign)BOOL isSign; //是否签约



@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //如果是测试环境
    if ([DomainName isEqualToString:@"http://118.244.234.207/"]) {
        [self setRightBarButtonWithTitle:@"测试"];
    }else{
//        [self setRightBarButtonWithTitle:@"存在"];
    }
    
    self.title = @"我";
    
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor = MyColor(248, 248, 248);
    
    
    UIImage *image1 = [[UIImage imageNamed:@"ic_tabbar_me"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *image2 = [[UIImage imageNamed:@"ic_tabbar_me_active"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:self.title image:image1 selectedImage:image2];
    [self.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                             [UIColor colorWithRed:59.0f/255.0f green:161.0f/255.0f blue:233.0f/255.0f alpha:1], NSForegroundColorAttributeName,
                                             nil] forState:UIControlStateSelected];
    [self.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                             [UIColor lightGrayColor], NSForegroundColorAttributeName,
                                             nil] forState:UIControlStateNormal];
 
    iconImageView.layer.cornerRadius = 25;
    iconImageView.layer.masksToBounds = YES;
    iconImageView.userInteractionEnabled = YES;
    //设置头像的默认图片
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [iconImageView addGestureRecognizer:tap];
    
    //设置标记图片样式
    self.targetView.layer.cornerRadius = 5;
    self.targetView.layer.masksToBounds = YES;
}

- (void)onRightButtonAction:(id)sender{

}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    [XLAvatarBrowser showImage:iconImageView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

//获取用户的医生列表
/*
- (void)getDoctorListSuccessWithResult:(NSDictionary *)result {
    [SVProgressHUD dismiss];
    NSArray *dicArray = [result objectForKey:@"Result"];
    if (dicArray && dicArray.count > 0) {
        for (NSDictionary *dic in dicArray) {
            UserObject *obj = [UserObject userobjectFromDic:dic];
            [[DBManager shareInstance] updateUserWithUserObject:obj];
            [[AccountManager shareInstance] refreshCurrentUserInfo];
            _detailLabel.text = obj.hospitalName;
            _nameLabel.text = [NSString stringWithFormat:@"%@   %@",obj.name,obj.title];
            
            if (obj.img.length > 0) {
                //下载图片
//                [self downloadImageWithImageUrl:obj.img];
                [iconImageView sd_setImageWithURL:[NSURL URLWithString:obj.img] placeholderImage:[UIImage imageNamed:@"user_icon"]];
            }
            
            self.isSign = [dic[@"is_sign"] intValue] == 1 ? YES : NO;
            //更新用户偏好中的数据
            NSString *key = [NSString stringWithFormat:@"%@isSign",obj.userid];
            [CRMUserDefalut setObject:[NSString stringWithFormat:@"%d",[dic[@"is_sign"] intValue]] forKey:key];
            
            [self refreshView];
            return;
        }
    }
}
- (void)getDoctorListFailedWithError:(NSError *)error {
    [SVProgressHUD showImage:nil status:error.localizedDescription];
}
*/
- (void)refreshView{
    [super refreshView];
    
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    UserObject *userobj = [[AccountManager shareInstance] currentUser];
//    [[DoctorManager shareInstance] getDoctorListWithUserId:userobj.userid successBlock:^{
//        
//    } failedBlock:^(NSError *error) {
//        [SVProgressHUD showImage:nil status:error.localizedDescription];
//    }];
    
    UserObject *user = [AccountManager shareInstance].currentUser;
    _detailLabel.text = user.hospitalName;
    _nameLabel.text = [NSString stringWithFormat:@"%@   %@",user.name,user.title];
    [iconImageView sd_setImageWithURL:[NSURL URLWithString:user.img] placeholderImage:[UIImage imageNamed:@"user_icon"] options:SDWebImageRefreshCached];
    
    //查询数据库，是否有未同步的数据
    NSArray *array = [[DBManager shareInstance] getInfoListWithSyncStatus:@"4"];
    if (array.count > 0) {
        self.targetView.hidden = NO;
    }else{
        self.targetView.hidden = YES;
    }
}

#pragma mark - UITableViewDataSource/Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.isSign == YES) {
        return 6;
    }else{
        return 5;
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isSign == YES) {
        if(section==0){
            return 1;
        }else if (section==1){
            return 1;
        }else if (section==2){
            return 2;
        }else if (section==3){
            return 2;
        }else if(section == 4){
            return 2;
        }else{
            return 2;
        }
    }else{
        if(section==0){
            return 1;
        }else if (section==1){
            return 1;
        }else if (section==2){
            return 2;
        }else if(section == 3){
            return 2;
        }else{
            return 2;
        }
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 20;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.isSign == YES) {
        if(indexPath.section == 0){
            return _zhangHuCell;
        }else if (indexPath.section == 1){
            if (indexPath.row == 0){
                return _doctorCell;
            }
        }else if (indexPath.section == 2){
            if (indexPath.row == 0) {
                return _zhongZhiTiCell;
            }else{
                return _tiXingMuBanCell;
            }
        }else if (indexPath.section == 3){
            if(indexPath.row == 0){
                return _myBillCell;
            }else if (indexPath.row == 1){
                return _myClinicCell;
            }
        }else if (indexPath.section == 4){
            if (indexPath.row == 0) {
                return _shuJuFenXiCell;
            }else if(indexPath.row == 1){
                return _shareCell;
            }
            
        }else if (indexPath.section == 5){
            if (indexPath.row == 0) {
                return _copyCell;
            }else{
                return _sheZhiCell;
            }
            
        }
    }else{
        if(indexPath.section == 0){
            return _zhangHuCell;
        }else if (indexPath.section == 1){
            if (indexPath.row == 0){
                return _doctorCell;
            }
        }else if (indexPath.section == 2){
            if (indexPath.row == 0) {
                return _zhongZhiTiCell;
            }else{
                return _tiXingMuBanCell;
            }
        }else if (indexPath.section == 3){
            if (indexPath.row == 0) {
                return _shuJuFenXiCell;
            }else if(indexPath.row == 1){
                return _shareCell;
            }
        }else if (indexPath.section == 4){
            if (indexPath.row == 0) {
                return _copyCell;
            }
            return _sheZhiCell;
        }
    }
    
        return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        return 70;
    }else{
        return 44;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
            XLPersonInfoViewController *userInfoVC = [storyBoard instantiateViewControllerWithIdentifier:@"XLPersonInfoViewController"];
            userInfoVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:userInfoVC animated:YES];
        }
    }
    if(indexPath.section == 1){
        if(indexPath.row == 0){
            XLDoctorLibraryViewController *doctorLibrary = [[XLDoctorLibraryViewController alloc] init];
            doctorLibrary.hidesBottomBarWhenPushed = YES;
            [self pushViewController:doctorLibrary animated:YES];
            
        }
        //else if (indexPath.row == 1){
//            XLJoinTeamSegumentController *segumentVc = [[XLJoinTeamSegumentController alloc] init];
//            segumentVc.hidesBottomBarWhenPushed = YES;
//            [self pushViewController:segumentVc animated:YES];
            
        //}
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            XLMaterialsViewController *materialsVC = [[XLMaterialsViewController alloc] init];
            materialsVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:materialsVC animated:YES];
        }else if (indexPath.row == 1){
            XLMessageTemplateViewController *templateVc = [[XLMessageTemplateViewController alloc] initWithStyle:UITableViewStyleGrouped];
            templateVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:templateVc animated:YES];
        }
    }
    
    if (self.isSign == YES) {
        if (indexPath.section == 3) {
            if (indexPath.row == 0) {
                
                WMPageController *pageController = [self p_defaultController];
                pageController.title = @"我的账单";
                pageController.menuViewStyle = WMMenuViewStyleLine;
                pageController.titleSizeSelected = 15;
                pageController.titleColorSelected = MyColor(0, 139, 232);
                pageController.menuHeight = 44;
                pageController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:pageController animated:YES];
                
                
            }else if(indexPath.row == 1){
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
                MyClinicViewController *clinicVc = [storyboard instantiateViewControllerWithIdentifier:@"MyClinicViewController"];
                clinicVc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:clinicVc animated:YES];
            }
        }
        
        if(indexPath.section == 4){
            if(indexPath.row == 0){
                XLDataAnalyseViewController *analyse = [[XLDataAnalyseViewController alloc] initWithStyle:UITableViewStylePlain];
                analyse.hidesBottomBarWhenPushed = YES;
                [self pushViewController:analyse animated:YES];
            }else{
                [self showShareActionChoose];
            }
        }
        if(indexPath.section == 5){
            if (indexPath.row == 0) {
                UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
                XLBackUpViewController *backUpVc = [storyBoard instantiateViewControllerWithIdentifier:@"XLBackUpViewController"];
                backUpVc.hidesBottomBarWhenPushed = YES;
                [self pushViewController:backUpVc animated:YES];
            }else if(indexPath.row == 1){
                XLBaseSettingViewController *baseSetting = [[XLBaseSettingViewController alloc] initWithStyle:UITableViewStyleGrouped];
                baseSetting.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:baseSetting animated:YES];
                
            }
            
        }
    }else{
        if(indexPath.section == 3){
            if(indexPath.row == 0){
                XLDataAnalyseViewController *analyse = [[XLDataAnalyseViewController alloc] initWithStyle:UITableViewStylePlain];
                analyse.hidesBottomBarWhenPushed = YES;
                [self pushViewController:analyse animated:YES];
            }else{
                [self showShareActionChoose];
            }
        }
        if(indexPath.section == 4){
            if(indexPath.row == 0){
                UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
                XLBackUpViewController *backUpVc = [storyBoard instantiateViewControllerWithIdentifier:@"XLBackUpViewController"];
                backUpVc.hidesBottomBarWhenPushed = YES;
                [self pushViewController:backUpVc animated:YES];
            }else if(indexPath.row == 1){
                XLBaseSettingViewController *baseSetting = [[XLBaseSettingViewController alloc] initWithStyle:UITableViewStyleGrouped];
                baseSetting.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:baseSetting animated:YES];
            }
        }
    }
    
    
}
//分享选择
- (void)showShareActionChoose{
    UIActionSheet *sheetView = [[UIActionSheet alloc] initWithTitle:@"分享" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"微信" otherButtonTitles:@"朋友圈", nil];
    [sheetView showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(![WXApi isWXAppInstalled]){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请先安装微信客户端" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }else{
        UserObject *userobj = [[AccountManager shareInstance] currentUser];
        ShareMode *mode = [[ShareMode alloc]init];
        mode.title = @"牙医新生活倡导者：年种植上千颗不是梦";
        mode.message = [NSString stringWithFormat:@"他，3张牙椅上千颗植体；他，拥有上万名高端用户；种牙管家，开启牙医新生活！"];
        mode.url = [NSString stringWithFormat:@"%@%@/view/InviteFriends.aspx?doctorId=%@",DomainRealName,Method_Weixin,userobj.userid];
        mode.image = [UIImage imageNamed:@"crm_logo"];
        
        
        if (buttonIndex == 0) {
            //微信
            [Share shareToPlatform:weixinFriend WithMode:mode];
        }else if(buttonIndex ==1){
            //朋友圈
            [Share shareToPlatform:weixin WithMode:mode];
        }
    }
}

//创建控制器
- (WMPageController *)p_defaultController {
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    NSMutableArray *titles = [[NSMutableArray alloc] init];
    Class class;
    for (int i = 0; i < 2; i++) {
        NSString *title;
        if (i == 0) {
            title = @"待付款";
            class = [MyBillViewController class];
        }else{
            title = @"已付款";
            class = [PayedBillViewController class];
        }
        [viewControllers addObject:class];
        [titles addObject:title];
    }
    WMPageController *pageVC = [[WMPageController alloc] initWithViewControllerClasses:viewControllers andTheirTitles:titles];
    pageVC.pageAnimatable = YES;
    pageVC.menuItemWidth = kScreenWidth * 0.5;
    pageVC.postNotification = YES;
    pageVC.bounces = YES;
    return pageVC;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
