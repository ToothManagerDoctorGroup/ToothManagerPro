//
//  AddressBookViewController.m
//  CRM
//
//  Created by TimTiger on 6/6/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "AddressBookViewController.h"
#import "DBManager+Patients.h"
#import "DBManager+Introducer.h"
#import <AddressBook/AddressBook.h>
#import "ChineseSearchEngine.h"
#import "CRMMacro.h"
#import "DBManager+RepairDoctor.h"
#import "CRMHttpRequest+Sync.h"
#import "DBManager+sync.h"
#import "AddressBookCell.h"

@interface AddressBookViewController () <UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,AddressBookCellDelegate>

@property (nonatomic,retain) NSMutableArray *tableViewDataSource;
@property (nonatomic) NSArray *searchResults;
@property (nonatomic,readwrite) BOOL useSearchResult;

@end

@implementation AddressBookViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)initView {
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
//    [self setRightBarButtonWithImage:[UIImage imageNamed:@"btn_complet"]];
    if (self.type == ImportTypePatients) {
        self.title = @"通讯录导入患者";
    }
    if (self.type == ImportTypeIntroducer) {
        self.title = @"通讯录导入介绍人";
    }
    if (self.type == ImportTypeRepairDoctor) {
        self.title = @"通讯录导入修复医生";
    }
    self.tableView.allowsSelection = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)initData {
    [super initData];
    _tableViewDataSource = [NSMutableArray arrayWithCapacity:0];
    
    ABAddressBookRef addressBook = nil;
    
    //获取通讯录权限 ios6.0以上需要获取权限读通信录
    if (IOS_6_OR_LATER)
    {
        addressBook =  ABAddressBookCreateWithOptions(NULL, NULL);
        
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error){dispatch_semaphore_signal(sema);});
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
        // dispatch_release(sema);
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        addressBook = ABAddressBookCreate();
#pragma clang diagnostic pop
    }
    
    NSArray* friendArray = (__bridge_transfer NSArray*)(ABAddressBookCopyArrayOfAllPeople(addressBook));
    
    for (int i = 0; i < [friendArray count]; i++)
    {
        ABRecordRef person = (__bridge ABRecordRef)[friendArray objectAtIndex:i];
        AddressBookCellMode *mode = [[AddressBookCellMode alloc]init];
        mode.name = [self nameWithABRecordRef:person];
        mode.phone = [self phoneNumberWithABRecordRef:person];
        mode.image = [self imageWithABRecordRef:person];
        if (mode.phone != nil) {
            if (self.type == ImportTypePatients) {
               mode.hasAdded = [[DBManager shareInstance] isInPatientsTable:mode.phone];
            } else if (self.type == ImportTypeIntroducer) {
                mode.hasAdded = [[DBManager shareInstance] isInIntroducerTable:mode.phone];
            } else if (self.type == ImportTypeRepairDoctor) {
                mode.hasAdded = [[DBManager shareInstance] isInRepairDoctorTable:mode.phone];
            }
            [self.tableViewDataSource addObject:mode];
        }
    }
    
    //按姓名排序
    self.tableViewDataSource = [NSMutableArray arrayWithArray:[self.tableViewDataSource sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSComparisonResult result;
        if (self.type == ImportTypePatients) {
            AddressBookCellMode *object1 = (AddressBookCellMode *)obj1;
            AddressBookCellMode *object2 = (AddressBookCellMode *)obj2;
            result= [object1.name localizedCompare:object2.name];
        } else {
            AddressBookCellMode *object1 = (AddressBookCellMode *)obj1;
            AddressBookCellMode *object2 = (AddressBookCellMode *)obj2;
            result = [object1.name localizedCompare:object2.name];
        }
        return result == NSOrderedDescending;
    }]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Button Action
- (void)onAddButtonAction:(UIButton *)button {
    AddressBookCellMode *mode = nil;
    NSInteger row = button.tag - 100;
    if (_useSearchResult) {
        mode = [self.searchResults objectAtIndex:row];
    } else {
        mode = [self.tableViewDataSource objectAtIndex:row];
    }
    BOOL ret = NO;
    if (self.type == ImportTypePatients) {
        Patient *patient = [[Patient alloc]init];
        patient.patient_name = mode.name;
        patient.patient_phone = mode.phone;
        patient.patient_age = @"0";
        patient.patient_gender = @"2";//表示没有设置性别
        ret = [[DBManager shareInstance] insertPatientsWithArray:@[patient]];
        if (ret) {
             [[DBManager shareInstance]updateUpdateDate:patient.ckeyid];
            [self postNotificationName:PatientCreatedNotification object:nil];
            [[CRMHttpRequest shareInstance] postAllNeedSyncPatient:[NSArray arrayWithObjects:patient, nil]];
            
        }
    } else  if (self.type == ImportTypeIntroducer){
        Introducer *introducer = [[Introducer alloc]init];
        introducer.intr_name = mode.name;
        introducer.intr_phone = mode.phone;
        introducer.intr_level = 1;
        introducer.intr_id = @"0";
        ret = [[DBManager shareInstance] insertIntroducersWithArray:@[introducer]];
        if (ret) {
            [self postNotificationName:IntroducerCreatedNotification object:nil];
            
            NSArray *recordArray = [NSMutableArray  arrayWithArray:[[DBManager shareInstance] getAllNeedSyncIntroducer]];
            if (0 != [recordArray count])
            {
                [[CRMHttpRequest shareInstance] postAllNeedSyncIntroducer:recordArray];
            }
        }
    } else if (self.type == ImportTypeRepairDoctor) {
        RepairDoctor *repairdoctor = [[RepairDoctor alloc] init];
        repairdoctor.doctor_name = mode.name;
        repairdoctor.doctor_phone = mode.phone;
        repairdoctor.data_flag = @"0";
        ret = [[DBManager shareInstance] insertRepairDoctor:repairdoctor];
        if (ret) {
             [self postNotificationName:RepairDoctorCreatedNotification object:nil];
        }
    }
    if (ret) {
        mode.hasAdded = YES;
        button.enabled = NO;
    }
}

#pragma mark - Private API

- (NSString *)nameWithABRecordRef:(ABRecordRef)recordRef {
    //todo 可能还需要判断是否为中文 中文姓在前
    NSMutableString* fullName = [NSMutableString stringWithCapacity:0];
    
    NSString *lastName = (__bridge_transfer NSString *) ABRecordCopyValue(recordRef, kABPersonLastNameProperty);
    
    if (lastName) {
        //英文名种名，姓之间有空格
        
        //[fullName appendFormat:@"%@ ",lastName];
        [fullName appendString:lastName];
    }
    
    NSString* firstName = (__bridge_transfer NSString *) ABRecordCopyValue(recordRef, kABPersonFirstNameProperty);
    
    if (firstName) {
        [fullName appendString:firstName];
    }
    return fullName;
}

- (NSString *)phoneNumberWithABRecordRef:(ABRecordRef)recordRef {
    //手机号码
    NSString *returnString = nil;
    ABMultiValueRef phones = (ABMultiValueRef) ABRecordCopyValue(recordRef, kABPersonPhoneProperty);
    for(int i = 0 ;i < ABMultiValueGetCount(phones); i++)
    {
        NSString* phone = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phones, i);
    
        NSString* normalPhone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        if ([self matchString:normalPhone withExpression:@"^(1(3[0-9])|(14[579])|(15[0-9])|(18[0-9]))[0-9]{8}$"]) {
            returnString =[NSString stringWithFormat:@"%@",normalPhone];
            break;
        }
    }
    CFRelease(phones);
    return returnString;
}

- (UIImage *)imageWithABRecordRef:(ABRecordRef)recordRef
{
    //头像
    NSData* imageData = (__bridge_transfer NSData*)ABPersonCopyImageDataWithFormat(recordRef,kABPersonImageFormatThumbnail);
    UIImage* image = [UIImage imageWithData:imageData];;
    return image;
}

- (BOOL)matchString:(NSString *)string withExpression:(NSString *)expression
{
	NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:expression
																			options:NSRegularExpressionCaseInsensitive
																			  error:nil];
	if ( nil == regex )
		return NO;
	
	NSUInteger numberOfMatches = [regex numberOfMatchesInString:string
														options:0
														  range:NSMakeRange(0, string.length)];
	if ( 0 == numberOfMatches )
		return NO;
    
	return YES;
}

#pragma mark - TalbeVeiw Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self isSearchResultsTableView:tableView]) {
        _useSearchResult = YES;
        return self.searchResults.count;
    }
    _useSearchResult = NO;
    return self.tableViewDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
//        UIView *viewBG = [[UIView alloc]initWithFrame:CGRectMake(0, 0,tableView.bounds.size.width, 44)];
//        viewBG.backgroundColor = [UIColor whiteColor];
//        cell.backgroundView = viewBG;
//        //cell选中时的背景颜色要与圆圈的背景颜色一致
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        [button setTintColor:[UIColor blueColor]];
//        button.frame = CGRectMake(0, 0, 50, 35);
//        [button setTitle:@"添加" forState:UIControlStateNormal];
//        [button setBackgroundImage:[UIImage imageNamed:@"addManBtn"] forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [button setTitle:@"已添加" forState:UIControlStateDisabled];
//        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
//        [button addTarget:self action:@selector(onAddButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//        cell.accessoryView = button;
//    }
    AddressBookCell *cell = [AddressBookCell cellWithTableView:tableView];
    cell.delegate = self;
    
    AddressBookCellMode *mode = nil;
    if ([self isSearchResultsTableView:tableView]) {
        mode = [self.searchResults objectAtIndex:indexPath.row];
    } else {
        mode  = [self.tableViewDataSource objectAtIndex:indexPath.row];
    }
    cell.model = mode;
//    UIButton *button = (UIButton *)cell.accessoryView;
//    button.tag = 100+indexPath.row;
//    button.enabled = !mode.hasAdded;
//    cell.textLabel.text = mode.name;
//    cell.detailTextLabel.text = mode.phone;
//    cell.imageView.image = mode.image;
    return cell;
}

#pragma mark - AddressBookCellDelegate
- (void)addressBookCell:(AddressBookCell *)cell didclickAddButton:(UIButton *)button{
    AddressBookCellMode *mode = nil;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    if (_useSearchResult) {
        mode = [self.searchResults objectAtIndex:indexPath.row];
    } else {
        mode = [self.tableViewDataSource objectAtIndex:indexPath.row];
    }
    BOOL ret = NO;
    if (self.type == ImportTypePatients) {
        Patient *patient = [[Patient alloc]init];
        patient.patient_name = mode.name;
        patient.patient_phone = mode.phone;
        ret = [[DBManager shareInstance] insertPatientsWithArray:@[patient]];
        if (ret) {
            [[DBManager shareInstance]updateUpdateDate:patient.ckeyid];
            [self postNotificationName:PatientCreatedNotification object:nil];
            [[CRMHttpRequest shareInstance] postAllNeedSyncPatient:[NSArray arrayWithObjects:patient, nil]];
            
        }
    } else  if (self.type == ImportTypeIntroducer){
        Introducer *introducer = [[Introducer alloc]init];
        introducer.intr_name = mode.name;
        introducer.intr_phone = mode.phone;
        introducer.intr_level = 1;
        introducer.intr_id = @"0";
        ret = [[DBManager shareInstance] insertIntroducersWithArray:@[introducer]];
        if (ret) {
            [self postNotificationName:IntroducerCreatedNotification object:nil];
            
            NSArray *recordArray = [NSMutableArray  arrayWithArray:[[DBManager shareInstance] getAllNeedSyncIntroducer]];
            if (0 != [recordArray count])
            {
                [[CRMHttpRequest shareInstance] postAllNeedSyncIntroducer:recordArray];
            }
        }
    } else if (self.type == ImportTypeRepairDoctor) {
        RepairDoctor *repairdoctor = [[RepairDoctor alloc] init];
        repairdoctor.doctor_name = mode.name;
        repairdoctor.doctor_phone = mode.phone;
        repairdoctor.data_flag = @"0";
        ret = [[DBManager shareInstance] insertRepairDoctor:repairdoctor];
        if (ret) {
            [self postNotificationName:RepairDoctorCreatedNotification object:nil];
        }
    }
    if (ret) {
        mode.hasAdded = YES;
        button.enabled = NO;
    }
}

#pragma makr - UISearchBar Delegates
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    if ([searchString isNotEmpty]) {
        self.searchResults = [ChineseSearchEngine resultArraySearchAddressBookOnArray:self.tableViewDataSource withSearchText:searchString];
    }
    return YES;
}

@end

@implementation AddressBookCellMode



@end
