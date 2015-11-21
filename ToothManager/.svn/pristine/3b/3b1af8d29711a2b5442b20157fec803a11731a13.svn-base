

#import "TTMEditAddressController.h"
#import "UIBarButtonItem+TTMAddtion.h"
#import "TTMClinicInfoCell.h"
#import "TTMDistrictController.h"
#import "TTMClinicModel.h"
#import "HZAreaPickerView.h"

#define kRowH 44.f

@interface TTMEditAddressController ()<
    UITableViewDelegate,
    UITableViewDataSource,
    HZAreaPickerDelegate>

@property (nonatomic, weak)   UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@property (strong, nonatomic) HZAreaPickerView *locatePicker;

@end

@implementation TTMEditAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑诊所地址";
    
    [self setupRightItem];
    [self setupTableView];
}

- (void)setupRightItem {
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithTitle:@"保存"
                                                                     normalImageName:@"member_bar_item_bg"
                                                                              action:@selector(buttonAction:)
                                                                              target:self];
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
    tableView.rowHeight = kRowH;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}


- (NSArray *)dataArray {
    if (!_dataArray) {
        TTMClinicInfoCellModel *district = [TTMClinicInfoCellModel modelWithTitle:@"所在地区"
                                                                      content:nil
                                                                     imageURL:@""
                                                                         type:TTMClinicCellModelTypeNormal
                                                              controllerClass:[TTMDistrictController class]];
        district.textFieldString = self.model.clinic_area;
        
        TTMClinicInfoCellModel *detail = [TTMClinicInfoCellModel modelWithTitle:@"详细地址"
                                                                        content:nil
                                                                       imageURL:@""
                                                                           type:TTMClinicCellModelTypeTextField
                                                                controllerClass:nil];
        detail.textFieldString = self.model.clinic_location;
        _dataArray = @[district, detail];
    }
    return _dataArray;
}


#pragma maek - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TTMClinicInfoCell *cell = [TTMClinicInfoCell cellWithTableView:tableView];
    if (self.dataArray.count > 0) {
        TTMClinicInfoCellModel *model = self.dataArray[indexPath.row];
        cell.model = model;
        cell.contentLabel.textAlignment = NSTextAlignmentLeft;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) { // 选择地区
        [self.locatePicker cancelPicker];
        self.locatePicker = [[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCityAndDistrict delegate:self];
        [self.locatePicker showInView:self.view];
    }
}

#pragma mark - HZAreaPicker delegate
-(void)pickerDidChaneStatus:(HZAreaPickerView *)picker
{
    if (picker.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict) {
        TTMClinicInfoCellModel *district = self.dataArray[0];
        district.content = [NSString stringWithFormat:@"%@%@%@", [picker.locate.state hasValue] ? picker.locate.state : @"",
                            [picker.locate.city hasValue] ? picker.locate.city : @"",
                            [picker.locate.district hasValue] ? picker.locate.district : @""];
        [self.tableView reloadData];
    }
}


/**
 *  点击保存
 *
 */
- (void)buttonAction:(UIButton *)button {
    TTMClinicInfoCellModel *district = self.dataArray[0];
    TTMClinicInfoCellModel *detail = self.dataArray[1];
    
    if (![detail.textFieldString hasValue]) {
        [MBProgressHUD showToastWithText:@"请输入详细地址"];
        return;
    }
    TTMClinicModel *model = self.model;
    model.clinic_location = [NSString stringWithFormat:@"%@%@",[district.content hasValue] ? district.content : @"",
                             [detail.textFieldString hasValue] ? detail.textFieldString : @""];
//    model.clinic_area = [district.content hasValue] ? district.content : @"";
    
    MBProgressHUD *loading = [MBProgressHUD showLoading];
    __weak __typeof(&*self) weakSelf = self;
    
    
    [TTMClinicModel updateWithClinic:model complete:^(id result) {
        [loading hide:YES];
        if ([result isKindOfClass:[NSString class]]) {
            [MBProgressHUD showToastWithText:result];
        } else {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
