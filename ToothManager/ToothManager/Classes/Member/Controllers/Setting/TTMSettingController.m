//
//  TTMSettingController.m
//  ToothManager
//

#import "TTMSettingController.h"
#import "TTMMemberCell.h"
#import "TTMGreenButton.h"
#import "TTMUpdatePayPasswordController.h"
#import "TTMUpdatePasswordController.h"
#import "TTMLoginController.h"
#import "TTMNavigationController.h"
#import "UMFeedback.h"
#import "TTMAboutController.h"
#import "TTMPrivateController.h"

#define kRowHeight 44.f
#define kMargin 10.f

@interface TTMSettingController ()<
    UITableViewDelegate,
    UITableViewDataSource>

@property (nonatomic, weak)   UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation TTMSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    [self setupTableView];
    [self setupFooterView];
}
/**
 *  懒加载模型数据
 *
 *  @return 数据
 */
- (NSArray *)dataArray {
    if (!_dataArray) {
        TTMMemberCellModel *updatePayPasswordModel = [[TTMMemberCellModel alloc] initWithTitle:@"修改支付密码"
                                                                             content:nil
                                                                         buttonTitle:nil
                                                                         contenColor:[UIColor redColor]
                                                                          messageNum:0
                                                                          accessType:TTMMemberCellModelAccessTypeArrow];
        updatePayPasswordModel.controllerClass = [TTMUpdatePayPasswordController class];
        TTMMemberCellModel *updatePasswordModel = [[TTMMemberCellModel alloc] initWithTitle:@"修改登录密码"
                                                                            content:nil
                                                                        buttonTitle:nil
                                                                        contenColor:nil
                                                                         messageNum:0
                                                                         accessType:TTMMemberCellModelAccessTypeArrow];
        updatePasswordModel.controllerClass = [TTMUpdatePasswordController class];
        TTMMemberCellModel *aboutModel = [[TTMMemberCellModel alloc] initWithTitle:@"关于我们"
                                                                             content:nil
                                                                         buttonTitle:nil
                                                                         contenColor:nil
                                                                          messageNum:0
                                                                          accessType:TTMMemberCellModelAccessTypeArrow];
        aboutModel.controllerClass = [TTMAboutController class];
        TTMMemberCellModel *fadebackModel = [[TTMMemberCellModel alloc] initWithTitle:@"意见反馈"
                                                                                 content:nil
                                                                             buttonTitle:nil
                                                                             contenColor:nil
                                                                              messageNum:0
                                                                              accessType:TTMMemberCellModelAccessTypeArrow];
        fadebackModel.controllerClass = [UMFeedback class];
        
        TTMMemberCellModel *protocolModel = [[TTMMemberCellModel alloc] initWithTitle:@"服务和隐私条款"
                                                                            content:nil
                                                                        buttonTitle:nil
                                                                        contenColor:nil
                                                                         messageNum:0
                                                                         accessType:TTMMemberCellModelAccessTypeArrow];
        protocolModel.controllerClass = [TTMPrivateController class];
        
//        NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
//        TTMMemberCellModel *versionModel = [[TTMMemberCellModel alloc] initWithTitle:@"版本号:"
//                                                                              content:version
//                                                                          buttonTitle:nil
//                                                                          contenColor:nil
//                                                                           messageNum:0
//                                                                           accessType:TTMMemberCellModelAccessTypeNone];
        
        NSArray *section1 = @[updatePayPasswordModel, updatePasswordModel];
        NSArray *section2 = @[aboutModel, fadebackModel, protocolModel];
        _dataArray = @[section1, section2];
    }
    return _dataArray;
}
/**
 *  加载tableview
 */
- (void)setupTableView {
    CGFloat tableHeight = ScreenHeight;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, tableHeight)
                                                          style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = kRowHeight;
    tableView.delaysContentTouches = NO;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}
/**
 *  加载tableFooterView
 */
- (void)setupFooterView {
    UIView *footerView = [[UIView alloc] init];
    TTMGreenButton *exitButton = [TTMGreenButton buttonWithType:UIButtonTypeCustom];
    [exitButton setTitle:@"安全退出" forState:UIControlStateNormal];
    [exitButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    exitButton.origin = CGPointMake(kMargin, 2 * kMargin);
    [footerView addSubview:exitButton];
    
    footerView.frame = CGRectMake(0, 0, ScreenWidth, 4 * kMargin + exitButton.width);
    
    self.tableView.tableFooterView = footerView;
}

#pragma maek - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 2 * kMargin;
    } else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TTMMemberCell *cell = [TTMMemberCell cellWithTableView:tableView];
    if (self.dataArray.count > 0) {
        TTMMemberCellModel *model = self.dataArray[indexPath.section][indexPath.row];
        cell.model = model;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TTMMemberCellModel *model = self.dataArray[indexPath.section][indexPath.row];
    if (model.controllerClass) {
        if (model.controllerClass == [UMFeedback class]) {
            [self.navigationController pushViewController:[UMFeedback feedbackViewController] animated:YES];
        } else {
            [self.navigationController pushViewController:[[[model.controllerClass class] alloc] init] animated:YES];
        }
    }
}
/**
 *  点击安全退出按钮
 *
 *  @param button 按钮
 */
- (void)buttonAction:(UIButton *)button {
    TTMUser *user = [TTMUser unArchiveUser];
    user.password = nil;
    [user archiveUser];
    TTMNavigationController *nav = [[TTMNavigationController alloc] initWithRootViewController:
                                    [[TTMLoginController alloc] init]];
    self.view.window.rootViewController = nav;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
