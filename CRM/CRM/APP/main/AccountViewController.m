//
//  AccountViewController.m
//  CRM
//
//  Created by lsz on 15/9/11.
//  Copyright (c) 2015年 TimTiger. All rights reserved.
//

#import "AccountViewController.h"
#import "SettingViewController.h"
#import "IntroducerViewController.h"
#import "DoctorLibraryViewController.h"
#import "RepairDoctorViewController.h"
#import "MaterialsViewController.h"
#import "DBTableMode.h"
#import "AccountManager.h"
#import "DBManager+User.h"
#import "QrCodeViewController.h"
#import "DBManager+Doctor.h"
#import "UserInfoViewController.h"
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


@interface AccountViewController ()<UIAlertViewDelegate>{
    
    __weak IBOutlet UITableView *_tableView;
    IBOutlet UITableViewCell *_zhangHuCell;
    __weak IBOutlet UILabel *_nameLabel;
    __weak IBOutlet UILabel *_detailLabel;
    
    
    IBOutlet UITableViewCell *_doctorCell;
    IBOutlet UITableViewCell *_repairDoctorCell;
    IBOutlet UITableViewCell *_zhongZhiTiCell;
    IBOutlet UITableViewCell *_tiXingMuBanCell;
    IBOutlet UITableViewCell *_shuJuFenXiCell;
    IBOutlet UITableViewCell *_sheZhiCell;
    IBOutlet UITableViewCell *_myClinicCell;
    
    IBOutlet UITableViewCell *_shareCell;
    
    IBOutlet UITableViewCell *_myBillCell;
    __weak IBOutlet UIImageView *iconImageView;
    
    
}

@property (nonatomic, assign)BOOL isSign; //是否签约

/**
 *  线程队列,创建子线程
 */
@property (nonatomic, strong)NSOperationQueue *opQueue;

@end

@implementation AccountViewController

- (NSOperationQueue *)opQueue{
    if (!_opQueue) {
        _opQueue = [[NSOperationQueue alloc] init];
    }
    return _opQueue;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"我的空间";
    
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor clearColor];
    
    
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
    [iconImageView setImage:[UIImage imageNamed:@"user_icon"]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [iconImageView addGestureRecognizer:tap];
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    [XLAvatarBrowser showImage:iconImageView];
}

//获取用户的医生列表
- (void)getDoctorListSuccessWithResult:(NSDictionary *)result {
    [SVProgressHUD dismiss];
    NSArray *dicArray = [result objectForKey:@"Result"];
    if (dicArray && dicArray.count > 0) {
        for (NSDictionary *dic in dicArray) {
            UserObject *obj = [UserObject userobjectFromDic:dic];
            [[DBManager shareInstance] updateUserWithUserObject:obj];
            [[AccountManager shareInstance] refreshCurrentUserInfo];
            _detailLabel.text = [NSString stringWithFormat:@"%@-%@%@",obj.hospitalName,obj.department,obj.title];
            _nameLabel.text = obj.name;
            
            if (obj.img.length > 0) {
                //下载图片
                [self downloadImageWithImageUrl:obj.img];
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

- (void)refreshView{
    [super refreshView];
    
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    UserObject *userobj = [[AccountManager shareInstance] currentUser];
    [[DoctorManager shareInstance] getDoctorListWithUserId:userobj.userid successBlock:^{
        
    } failedBlock:^(NSError *error) {
        [SVProgressHUD showImage:nil status:error.localizedDescription];
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.isSign == YES) {
        return 5;
    }else{
        return 4;
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isSign == YES) {
        if(section==0){
            return 1;
        }else if (section==1){
            return 3;
        }else if (section==2){
            return 2;
        }else if (section==3){
            return 2;
        }else{
            return 1;
        }
    }else{
        if(section==0){
            return 1;
        }else if (section==1){
            return 3;
        }else if (section==2){
            return 2;
        }else{
            return 1;
        }
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 0;
    }
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.isSign == YES) {
        if(section == 4){
            return 30;
        }
    }else{
        if(section == 3){
            return 30;
        }
    }
    return 1;
}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    view.backgroundColor = [UIColor colorWithRed:248.0f/255.0f green:248.0f/255.0f blue:248.0f/255.0f alpha:1];
    return view;
}


- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (self.isSign == YES) {
        if(section == 4){
            UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
            // [view setBackgroundColor:[UIColor lightGrayColor]];
            
            view.backgroundColor = [UIColor colorWithRed:248.0f/255.0f green:248.0f/255.0f blue:248.0f/255.0f alpha:1];
            
            return view;
        }
    }else{
        if(section == 3){
            UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
            // [view setBackgroundColor:[UIColor lightGrayColor]];
            
            view.backgroundColor = [UIColor colorWithRed:248.0f/255.0f green:248.0f/255.0f blue:248.0f/255.0f alpha:1];
            
            return view;
        }
    }
    
    
    
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    [view setBackgroundColor:[UIColor whiteColor]];
    return view;
}
 

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.isSign == YES) {
        if(indexPath.section == 0){
            return _zhangHuCell;
        }else if (indexPath.section == 1){
            if (indexPath.row == 0){
                return _doctorCell;
            }else if (indexPath.row == 1){
                return _repairDoctorCell;
            }else if (indexPath.row == 2){
                return _zhongZhiTiCell;
            }
        }else if (indexPath.section == 2){
            
            if(indexPath.row == 0){
                return _myBillCell;
            }else if (indexPath.row == 1){
                return _myClinicCell;
            }
        }else if (indexPath.section == 3){
            if (indexPath.row == 0) {
                return _shuJuFenXiCell;
            }else if(indexPath.row == 1){
                return _shareCell;
            }
            
        }else if (indexPath.section == 4){
            return _sheZhiCell;
        }
    }else{
        if(indexPath.section == 0){
            return _zhangHuCell;
        }else if (indexPath.section == 1){
            if (indexPath.row == 0){
                return _doctorCell;
            }else if (indexPath.row == 1){
                return _repairDoctorCell;
            }else if (indexPath.row == 2){
                return _zhongZhiTiCell;
            }
        }else if (indexPath.section == 2){
            if (indexPath.row == 0) {
                return _shuJuFenXiCell;
            }else if(indexPath.row == 1){
                return _shareCell;
            }
        }else if (indexPath.section == 3){
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
            UserInfoViewController *userInfoVC = [storyBoard instantiateViewControllerWithIdentifier:@"UserInfoViewController"];
            userInfoVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:userInfoVC animated:YES];
        }
    }
    if(indexPath.section == 1){
        if(indexPath.row == 0){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"DoctorStoryboard" bundle:nil];
            DoctorLibraryViewController *doctorVC = [storyboard instantiateViewControllerWithIdentifier:@"DoctorLibraryViewController"];
            doctorVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:doctorVC animated:YES];
        }else if (indexPath.row == 1){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
            RepairDoctorViewController *repairDoctorVC = [storyboard instantiateViewControllerWithIdentifier:@"RepairDoctorViewController"];
            repairDoctorVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:repairDoctorVC animated:YES];
        }else if (indexPath.row == 2){
//            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
//            MaterialsViewController *materialsVC = [storyboard instantiateViewControllerWithIdentifier:@"MaterialsViewController"];
//            materialsVC.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:materialsVC animated:YES];
            
            XLMaterialsViewController *materialsVC = [[XLMaterialsViewController alloc] init];
            materialsVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:materialsVC animated:YES];
            
            
        }
    }
    if (self.isSign == YES) {
        if (indexPath.section == 2) {
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
        
        if(indexPath.section == 3){
            if(indexPath.row == 0){
                ShuJuFenXiViewController *shuju = [[ShuJuFenXiViewController alloc]initWithNibName:@"ShuJuFenXiViewController" bundle:nil];
                shuju.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:shuju animated:YES];
            }else{
                [self showShareActionChoose];
            }
        }
        if(indexPath.section == 4){
            if(indexPath.row == 0){
                SettingViewController *set = [[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
                set.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:set animated:YES];
                
            }
            
        }
    }else{
        if(indexPath.section == 2){
            if(indexPath.row == 0){
                ShuJuFenXiViewController *shuju = [[ShuJuFenXiViewController alloc]initWithNibName:@"ShuJuFenXiViewController" bundle:nil];
                shuju.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:shuju animated:YES];
            }else{
                [self showShareActionChoose];
            }
        }
        if(indexPath.section == 3){
            if(indexPath.row == 0){
                SettingViewController *set = [[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
                set.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:set animated:YES];
            }
        }
    }
    
    
}
//分享选择
- (void)showShareActionChoose{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享" message:@"确认打开微信进行分享吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self shareAction];
    }
}

//分享
- (void)shareAction{
    if(![WXApi isWXAppInstalled]){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请先安装微信客户端" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }else{
        UserObject *userobj = [[AccountManager shareInstance] currentUser];
        ShareMode *mode = [[ShareMode alloc]init];
        mode.title = @"牙医新生活倡导者：年种植上千颗不是梦";
        mode.message = [NSString stringWithFormat:@"他，3张牙椅上千颗植体；他，拥有上万名高端用户；种牙管家，开启牙医新生活！"];
        mode.url = [NSString stringWithFormat:@"http://122.114.62.57/Weixin/view/InviteFriends.aspx?doctorId=%@",userobj.userid];
        mode.image = [UIImage imageNamed:@"crm_logo"];
        [Share shareToPlatform:weixin WithMode:mode];
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
            iconImageView.image = image;
        }];
    }];
    // 2.必须将任务添加到队列中才能执行
    [self.opQueue addOperation:downOp];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
