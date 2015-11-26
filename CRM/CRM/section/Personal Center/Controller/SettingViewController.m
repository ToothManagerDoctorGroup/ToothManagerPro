//
//  SettingViewController.m
//  CRM
//
//  Created by lsz on 15/9/12.
//  Copyright (c) 2015年 TimTiger. All rights reserved.
//

#import "SettingViewController.h"
#import "AboutProductViewController.h"
#import "UMFeedback.h"
#import "ServerPrivacyViewController.h"
#import "ChangePasswdViewController.h"
#import "AccountManager.h"
#import "TimNavigationViewController.h"

@interface SettingViewController (){
    
    __weak IBOutlet UITableView *_tableView;
    IBOutlet UITableViewCell *_guanyuwomenCell;
    IBOutlet UITableViewCell *_yijianfankuiCell;
    IBOutlet UITableViewCell *_fuwuCell;
    IBOutlet UITableViewCell *_gengxinCell;
    __weak IBOutlet UILabel *_versionLabel;
    IBOutlet UITableViewCell *_genggaimimaCell;
    IBOutlet UITableViewCell *_tuichuCell;
}

@end

@implementation SettingViewController

- (void)initView{
    
}

- (void)initData{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"设置";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    self.view.backgroundColor = [UIColor clearColor];
    
    _versionLabel.text = [NSString stringWithFormat:@"v%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    
  
    
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor colorWithRed:248.0f/255.0f green:248.0f/255.0f blue:248.0f/255.0f alpha:1];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==0){
        return 4;
    }else{
        return 2;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    view.backgroundColor = [UIColor colorWithRed:248.0f/255.0f green:248.0f/255.0f blue:248.0f/255.0f alpha:1];
    return view;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (indexPath.section == 0){
        if(indexPath.row == 0){
            return _guanyuwomenCell;
        }else if (indexPath.row == 1){
            return _yijianfankuiCell;
        }else if (indexPath.row == 2){
            return _fuwuCell;
        }else if (indexPath.row == 3){
            return _gengxinCell;
        }
    }else if (indexPath.section == 1){
        if(indexPath.row == 0){
            return _genggaimimaCell;
        }else if (indexPath.row == 1){
            return _tuichuCell;
        }
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return 44;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0){
        if(indexPath.row == 0){
                      UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
                            AboutProductViewController *aboutVC = [storyBoard instantiateViewControllerWithIdentifier:@"AboutProductViewController"];
            aboutVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:aboutVC animated:YES];
            
        }
        else if (indexPath.row == 1){
            UIViewController *feedbackVC = [UMFeedback feedbackViewController];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 0, 45, 44);
            [button setImage:[UIImage imageNamed:@"btn_back.png"] forState:UIControlStateNormal];
            [[UMFeedback sharedInstance] setBackButton:button];
            feedbackVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:feedbackVC animated:YES];
            
        }else if (indexPath.row == 2){
                     UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
                        ServerPrivacyViewController *serverVC = [storyBoard instantiateViewControllerWithIdentifier:@"ServerPrivacyViewController"];
            serverVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:serverVC animated:YES];
        }
        
    }
    
    if(indexPath.section == 1){
        if(indexPath.row == 0){
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
        ChangePasswdViewController *changepasswdVC = [storyBoard instantiateViewControllerWithIdentifier:@"ChangePasswdViewController"];
            
            changepasswdVC.hidesBottomBarWhenPushed = YES;
            
         [self.navigationController pushViewController:changepasswdVC animated:YES];
        }else if (indexPath.row == 1){
            [[AccountManager shareInstance] logout];
            
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
