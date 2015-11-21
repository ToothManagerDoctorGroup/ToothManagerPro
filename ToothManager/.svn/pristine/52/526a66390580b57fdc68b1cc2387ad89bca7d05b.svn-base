
#import "TTMClinicInfoController.h"
#import "TTMClinicInfoCell.h"
#import "TTMEditAddressController.h"
#import "TTMChairSettingController.h"
#import "TTMRealisticSceneController.h"
#import "TTMEditInfoController.h"
#import "TTMClinicModel.h"

#define kMargin 10.f
#define kHeadH 60.f
#define kCellH 44.f

@interface TTMClinicInfoController ()<
    UITableViewDelegate,
    UITableViewDataSource,
    UINavigationControllerDelegate,
    UIImagePickerControllerDelegate,
    UIActionSheetDelegate>

@property (nonatomic, weak)   UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) TTMClinicModel *pageModel; // 页面model

@end

@implementation TTMClinicInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"诊所信息";
    
    [self setupTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self queryClinicInfo];
}

/**
 *  加载tableview
 */
- (void)setupTableView {
    CGFloat tableHeight = ScreenHeight;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, tableHeight)
                                                          style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        TTMClinicInfoCellModel *head = [TTMClinicInfoCellModel modelWithTitle:@"头像"
                                                                      content:nil
                                                                     imageURL:@""
                                                                         type:TTMClinicCellModelTypeHead
                                                              controllerClass:nil];
        
//        TTMClinicInfoCellModel *qrcode = [TTMClinicInfoCellModel modelWithTitle:@"二维码"
//                                                                      content:nil
//                                                                     imageURL:@""
//                                                                         type:TTMClinicCellModelTypeQRCode
//                                                              controllerClass:nil];
        TTMClinicInfoCellModel *name = [TTMClinicInfoCellModel modelWithTitle:@"诊所名称"
                                                                      content:nil
                                                                     imageURL:@""
                                                                         type:TTMClinicCellModelTypeNormal
                                                              controllerClass:[TTMEditInfoController class]];
        TTMClinicInfoCellModel *introduce = [TTMClinicInfoCellModel modelWithTitle:@"诊所简介"
                                                                      content:nil
                                                                     imageURL:@""
                                                                         type:TTMClinicCellModelTypeNormal
                                                              controllerClass:[TTMEditInfoController class]];
        TTMClinicInfoCellModel *address = [TTMClinicInfoCellModel modelWithTitle:@"诊所地址"
                                                                      content:nil
                                                                     imageURL:@""
                                                                         type:TTMClinicCellModelTypeNormal
                                                              controllerClass:[TTMEditAddressController class]];
        TTMClinicInfoCellModel *dateTime = [TTMClinicInfoCellModel modelWithTitle:@"营业时间"
                                                                      content:nil
                                                                     imageURL:@""
                                                                         type:TTMClinicCellModelTypeNormal
                                                              controllerClass:[TTMEditInfoController class]];
        TTMClinicInfoCellModel *service = [TTMClinicInfoCellModel modelWithTitle:@"客服电话"
                                                                      content:nil
                                                                     imageURL:@""
                                                                         type:TTMClinicCellModelTypeNormal
                                                              controllerClass:[TTMEditInfoController class]];
        TTMClinicInfoCellModel *chair = [TTMClinicInfoCellModel modelWithTitle:@"椅位配置"
                                                                      content:nil
                                                                     imageURL:@""
                                                                         type:TTMClinicCellModelTypeNormal
                                                              controllerClass:[TTMChairSettingController class]];
        TTMClinicInfoCellModel *images = [TTMClinicInfoCellModel modelWithTitle:@"诊所实景图"
                                                                      content:nil
                                                                     imageURL:@""
                                                                         type:TTMClinicCellModelTypeNormal
                                                              controllerClass:[TTMRealisticSceneController class]];
        
        NSArray *section0 = @[head];
        NSArray *section1 = @[name, introduce, address, dateTime, service];
        NSArray *section2 = @[chair, images];
        
        _dataArray = @[section0, section1, section2];
    }
    return _dataArray;
}


#pragma maek - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kMargin;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return kHeadH;
        } else {
            return kCellH;
        }
    } else {
        return kCellH;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TTMClinicInfoCell *cell = [TTMClinicInfoCell cellWithTableView:tableView];
    if (self.dataArray.count > 0) {
        TTMClinicInfoCellModel *model = self.dataArray[indexPath.section][indexPath.row];
        cell.model = model;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TTMClinicInfoCellModel *model = self.dataArray[indexPath.section][indexPath.row];
    if (model.controllerClass) {
        UIViewController *vc = [[model.controllerClass alloc] init];
        if (model.controllerClass == [TTMEditAddressController class]) { // 诊所地址
            TTMEditAddressController *addressVC = (TTMEditAddressController *)vc;
            addressVC.model = self.pageModel;
        } else if (model.controllerClass == [TTMEditInfoController class]){
            TTMEditInfoController *editVC = (TTMEditInfoController *)vc;
            editVC.title = model.title;
            editVC.model = self.pageModel;
        }
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        if ([model.title isEqualToString:@"头像"]) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                     delegate:self
                                                            cancelButtonTitle:@"取消"
                                                       destructiveButtonTitle:nil
                                                            otherButtonTitles:@"拍照", @"从相册选择", nil];
            actionSheet.tag = 1;
            actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
            [actionSheet showInView:self.view];
        }
    }
}

#pragma mark - 图片选择
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    if (buttonIndex == 0) { // 拍照
        if (TARGET_IPHONE_SIMULATOR) {
            [MBProgressHUD showToastWithText:@"请使用真机"];
            return;
        }
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    } else if (buttonIndex == 1) { // 从相册选择
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
        [self presentViewController:picker animated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerControllerDelegate
// 选择了图片或者拍照了
- (void)imagePickerController:(UIImagePickerController *)aPicker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [aPicker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    if (image) {
        [self editImage:image];
    }
    return;
}

- (void)refreshData {
    TTMClinicModel *pageModel = self.pageModel;
    
    NSArray *tempArray = self.dataArray;
    for (NSUInteger i = 0; i < tempArray.count; i ++) {
        NSArray *section = tempArray[i];
        for (NSUInteger j = 0; j < section.count; j ++) {
            TTMClinicInfoCellModel *cellModel = section[j];
            switch (i) {
                case 0: { // section 0
                    switch (j) {
                        case 0: {
                            cellModel.imageURL = pageModel.clinic_img; // 头像
                            break;
                        }
                        case 1: {
                            cellModel.imageURL = pageModel.qrcodeImage; // 二维码
                            break;
                        }
                        default: {
                            break;
                        }
                    }
                    break;
                }
                case 1: { // section 1
                    switch (j) {
                        case 0: {
                            cellModel.content = pageModel.clinic_name; // 诊所名称
                            break;
                        }
                        case 1: {
                            cellModel.content = pageModel.clinic_summary; // 诊所简介
                            break;
                        }
                        case 2: {
                            cellModel.content = [NSString stringWithFormat:@"%@%@", [pageModel.clinic_area hasValue] ? pageModel.clinic_area : @"",
                                                 [pageModel.clinic_location hasValue] ? pageModel.clinic_location : @""]; // 诊所地址
                            break;
                        }
                        case 3: {
                            cellModel.content = pageModel.business_hours; // 营业时间
                            break;
                        }
                        case 4: {
                            cellModel.content = pageModel.clinic_phone; // 客服电话
                            break;
                        }
                        default: {
                            break;
                        }
                    }
                    break;
                }
                case 2: {
                    break;
                }
                default: {
                    break;
                }
            }
        }
    }
    [self.tableView reloadData];
}

/**
 *  查询诊所信息
 */
- (void)queryClinicInfo {
    __weak __typeof(&*self) weakSelf = self;
    [TTMClinicModel queryClinicDetailWithComplete:^(id result) {
        if ([result isKindOfClass:[NSString class]]) {
            [MBProgressHUD showToastWithText:result];
        } else {
            weakSelf.pageModel = result;
            [weakSelf queryQRCode];
        }
    }];
}

/**
 *  查询二维码
 */
- (void)queryQRCode {
    __weak __typeof(&*self) weakSelf = self;
    [TTMClinicModel queryClinicQRCodeWithComplete:^(id result) {
        if ([result isKindOfClass:[NSString class]]) {
            [MBProgressHUD showToastWithText:result];
        } else {
            weakSelf.pageModel.qrcodeImage = result[@"imageURL"];
            [weakSelf refreshData];
        }
    }];
}

/**
 *  编辑头像
 *
 *  @param image 图片
 */
- (void)editImage:(UIImage *)image {
    MBProgressHUD *hud = [MBProgressHUD showLoading];
    __weak __typeof(&*self) weakSelf = self;
    [TTMClinicModel editHeadImage:image complete:^(id result) {
        [hud hide:YES];
        if ([result isKindOfClass:[NSString class]]) {
            [MBProgressHUD showToastWithText:result];
        } else {
            [MBProgressHUD showToastWithText:@"修改成功"];
            [weakSelf queryClinicInfo];
        }
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
