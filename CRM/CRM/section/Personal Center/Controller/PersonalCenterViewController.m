//
//  PersonalCenterViewController.m
//  CRM
//
//  Created by TimTiger on 5/12/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "PersonalCenterViewController.h"

#import "InfoViewController.h"
#import "AboutProductViewController.h"

@interface PersonalCenterViewController ()

@end

@implementation PersonalCenterViewController
@synthesize version;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupView];
    version = [self getLocalVersion];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Set View/Data
- (void)setupView {
    self.title = @"个人中心";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    perCenTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    [perCenTableView setDelegate:self];
    [perCenTableView setDataSource:self];
    [self.view addSubview:perCenTableView];
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 || section == 2){
        return 2;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section;
    int row = indexPath.row;
    static NSString * ideString = @"persinCenterCell";
    UITableViewCell * cell = [perCenTableView dequeueReusableCellWithIdentifier:ideString];
    if (cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ideString];
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        switch (section) {
            case 0:
                if (row == 0){
                    [cell.textLabel setText:@"个人信息"];
                }else{
                    [cell.textLabel setText:@"账号设置"];
                }
                break;
            case 1:
                if (row == 0){
                    [cell.textLabel setText:@"其他设置"];
                }
                break;
            case 2:
                if (row == 0){
                    [cell.textLabel setText:@"关于产品"];
                }else{
                    [cell.textLabel setText:@"检查版本更新"];
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    NSLog(@"version:%@",version);
                    [cell.detailTextLabel setText:[NSString stringWithFormat:@"当前版本:%@",version]];
                    [cell.detailTextLabel setTextColor:[UIColor blackColor]];
                }
                break;
            default:
                break;
        }
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    int section = indexPath.section;
    int row = indexPath.row;
    switch (section) {
        case 0:
            if (row == 0){
                NSLog(@"个人信息");
                InfoViewController * userInfoCTL = [[InfoViewController alloc]init];
                [self.navigationController pushViewController:userInfoCTL animated:YES];
            }else{
                NSLog(@"账号设置");
            }
            break;
        case 1:
            NSLog(@"其他设置");
            break;
        case 2:
            if (row == 0){
                NSLog(@"关于产品");
                AboutProductViewController * proInfoCTL = [[AboutProductViewController alloc]init];
                [self.navigationController pushViewController:proInfoCTL animated:YES];
            }else{
                NSLog(@"检查版本更新");
            }
            break;
        default:
            break; 
    }
}

#pragma mark - get Version
- (NSString *)getLocalVersion
{
    return [[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

@end
