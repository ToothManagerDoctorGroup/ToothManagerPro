//
//  NVMContact.m
//  contacts
//
//  Created by PhilCai on 15/7/29.
//  Copyright (c) 2015年 Phil. All rights reserved.
//

#import "NVMContactManager.h"
#import "DBManager+Patients.h"
#import <AddressBookUI/AddressBookUI.h>

NSString *const NVMContactAccessAllowedNotification = @"NVMContactAccessAllowedNotification";
NSString *const NVMContactAccessDeniedNotification = @"NVMContactAccessDeniedNotification";
NSString *const NVMContactAccessFailedNotification = @"NVMContactAccessFailedNotification";

@interface NVMContact()

@end

@implementation NVMContact
- (NSString *)description {
    NSMutableString *phoneNumbers = [[NSMutableString alloc] init];
    for (NSString *phoneNum in self.phoneNumbers) {
        [phoneNumbers appendString:phoneNum];
        [phoneNumbers appendString:@"\n"];
    }
    return [NSString stringWithFormat:@"%@:%@-%@-%@--%@",[super description],self.firstName,self.middleName,self.lastName,[phoneNumbers copy]];
}

@end

@interface NVMContactManager()
@property (nonatomic, strong) NSMutableArray *people;
@property (nonatomic,strong) NSMutableArray *sequencePeoplesTmp;//排序后的数组
@property (nonatomic, strong) NSMutableArray *sequencePeopleTitlesTmp;//排序后分组的标题
@end

@implementation NVMContactManager
+ (instancetype)manager {
    static NVMContactManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
        [manager loadAllPeople];
    });
    return manager;
}
- (instancetype)init {
    if (self = [super init]) {
        _people = [NSMutableArray array];
        _sequencePeoplesTmp = [NSMutableArray array];
        _sequencePeopleTitlesTmp = [NSMutableArray array];
    }
    return self;
}

- (void) loadAllPeople {
    NSArray *statuses = @[@"kABAuthorizationStatusNotDetermined",@"kABAuthorizationStatusRestricted",@"kABAuthorizationStatusDenied",@"kABAuthorizationStatusAuthorized"];
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    NSLog(@"ABAddressBookGetAuthorizationStatus = %@",statuses[status]);
    
    if (status == kABAuthorizationStatusAuthorized){
        CFErrorRef *error = NULL;
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
        [self copyAddressBook:addressBook];
        CFRelease(addressBook);
    } else if (status == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error){
            NSLog(@"granted:%d",granted);
            if (granted) {
                CFErrorRef *error1 = NULL;
                ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error1);
                [self copyAddressBook:addressBook];
                CFRelease(addressBook);
                [NVMContactManager postMainThreadNotification:NVMContactAccessAllowedNotification];
            } else {
                [NVMContactManager postMainThreadNotification:NVMContactAccessDeniedNotification];
            }
        });
    }
    else {
        //        Restricted OR Denied
        [NVMContactManager postMainThreadNotification:NVMContactAccessFailedNotification];
//        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
//            [[[UIAlertView alloc] initWithTitle:statuses[status] message:@"" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:@"ok", nil] show];
//            //            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
//        } else {
//            [[[UIAlertView alloc] initWithTitle:statuses[status] message:@"" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:@"ok", nil] show];
//        }
    }
}
- (void)copyAddressBook:(ABAddressBookRef)addressBook
{
    [self.people removeAllObjects];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
    CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    for ( int i = 0; i < numberOfPeople; i++){
        ABRecordRef person = CFArrayGetValueAtIndex(people, i);
        NVMContact *contact = [NVMContact new];
        NSString *firstName = (NSString *)CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNameProperty));
        contact.firstName = firstName;
        NSString *middlename = (NSString*)CFBridgingRelease(ABRecordCopyValue(person, kABPersonMiddleNameProperty));
        contact.middleName = middlename;
        NSString *lastName = (NSString *)CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNameProperty));
        contact.lastName = lastName;
        
        NSMutableString *fullName = [[NSMutableString alloc] init];
        if (lastName && lastName.length > 0) {
            [fullName appendString:lastName];
        }
        if (middlename && middlename.length > 0) {
            [fullName appendString:middlename];
        }
        if (firstName && firstName.length > 0) {
            [fullName appendString:firstName];
        }
        contact.fullName = fullName;
        
        
        NSMutableArray *phones = [NSMutableArray array];
        ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
        for (int k = 0; k<ABMultiValueGetCount(phone); k++)
        {
            NSString * personPhone = (NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(phone, k));
            
            [phones addObject:[self editPhoneStyleWithPhone:personPhone]];
        }
        contact.phoneNumbers = phones.copy;
        
        CFRelease(phone);
        
        [self.people addObject:contact];
        //        //读取middlename
        //        NSString *middlename = (NSString*)CFBridgingRelease(ABRecordCopyValue(person, kABPersonMiddleNameProperty));
        //        //读取prefix前缀
        //        NSString *prefix = (NSString*)CFBridgingRelease(ABRecordCopyValue(person, kABPersonPrefixProperty));
        //        //读取suffix后缀
        //        NSString *suffix = (NSString*)CFBridgingRelease(ABRecordCopyValue(person, kABPersonSuffixProperty));
        //        //读取nickname呢称
        //        NSString *nickname = (NSString*)CFBridgingRelease(ABRecordCopyValue(person, kABPersonNicknameProperty));
        //        //读取firstname拼音音标
        //        NSString *firstnamePhonetic = (NSString*)CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNamePhoneticProperty));
        //        //读取lastname拼音音标
        //        NSString *lastnamePhonetic = (NSString*)CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNamePhoneticProperty));
        //        //读取middlename拼音音标
        //        NSString *middlenamePhonetic = (NSString*)CFBridgingRelease(ABRecordCopyValue(person, kABPersonMiddleNamePhoneticProperty));
        //        //读取organization公司
        //        NSString *organization = (NSString*)CFBridgingRelease(ABRecordCopyValue(person, kABPersonOrganizationProperty));
        //        //读取jobtitle工作
        //        NSString *jobtitle = (NSString*)CFBridgingRelease(ABRecordCopyValue(person, kABPersonJobTitleProperty));
        //        //读取department部门
        //        NSString *department = (NSString*)CFBridgingRelease(ABRecordCopyValue(person, kABPersonDepartmentProperty));
        //        //读取birthday生日
        //        NSDate *birthday = (NSDate*)CFBridgingRelease(ABRecordCopyValue(person, kABPersonBirthdayProperty));
        //        //读取note备忘录
        //        NSString *note = (NSString*)CFBridgingRelease(ABRecordCopyValue(person, kABPersonNoteProperty));
        //        //第一次添加该条记录的时间
        //        NSString *firstknow = (NSString*)CFBridgingRelease(ABRecordCopyValue(person, kABPersonCreationDateProperty));
        //        //        NSLog(@"第一次添加该条记录的时间%@\n",firstknow);
        //        //最后一次修改該条记录的时间
        //        NSString *lastknow = (NSString*)CFBridgingRelease(ABRecordCopyValue(person, kABPersonModificationDateProperty));
        //        //        NSLog(@"最后一次修改該条记录的时间%@\n",lastknow);
        //
        //        //获取email多值
        //        ABMultiValueRef email = ABRecordCopyValue(person, kABPersonEmailProperty);
        //        int emailcount = ABMultiValueGetCount(email);
        //        for (int x = 0; x < emailcount; x++)
        //        {
        //            //获取email Label
        //            NSString* emailLabel = (NSString*)CFBridgingRelease(ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(email, x)));
        //            //获取email值
        //            NSString* emailContent = (NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(email, x));
        //        }
        //        CFRelease(email);
        //        //读取地址多值
        //        ABMultiValueRef address = ABRecordCopyValue(person, kABPersonAddressProperty);
        //        CFIndex count = ABMultiValueGetCount(address);
        //
        //        for(int j = 0; j < count; j++)
        //        {
        //            //获取地址Label
        //            NSString* addressLabel = (NSString*)CFBridgingRelease(ABMultiValueCopyLabelAtIndex(address, j));
        //            //获取該label下的地址6属性
        //            NSDictionary* personaddress =(NSDictionary*) CFBridgingRelease(ABMultiValueCopyValueAtIndex(address, j));
        //            NSString* country = [personaddress valueForKey:(NSString *)kABPersonAddressCountryKey];
        //            NSString* city = [personaddress valueForKey:(NSString *)kABPersonAddressCityKey];
        //            NSString* state = [personaddress valueForKey:(NSString *)kABPersonAddressStateKey];
        //            NSString* street = [personaddress valueForKey:(NSString *)kABPersonAddressStreetKey];
        //            NSString* zip = [personaddress valueForKey:(NSString *)kABPersonAddressZIPKey];
        //            NSString* coutntrycode = [personaddress valueForKey:(NSString *)kABPersonAddressCountryCodeKey];
        //        }
        //
        //        CFRelease(address);
        //        //获取dates多值
        //        ABMultiValueRef dates = ABRecordCopyValue(person, kABPersonDateProperty);
        //        CFIndex datescount = ABMultiValueGetCount(dates);
        //        for (int y = 0; y < datescount; y++)
        //        {
        //            //获取dates Label
        //            NSString* datesLabel = (NSString*)CFBridgingRelease(ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(dates, y)));
        //            //获取dates值
        //            NSString* datesContent = (NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(dates, y));
        //        }
        //        CFRelease(dates);
        //        //获取kind值
        //        CFNumberRef recordType = ABRecordCopyValue(person, kABPersonKindProperty);
        //        if (recordType == kABPersonKindOrganization) {
        //            // it's a company
        //            //            NSLog(@"it's a company\n");
        //        } else {
        //            // it's a person, resource, or room
        //            //            NSLog(@"it's a person, resource, or room\n");
        //        }
        //
        //
        //        //获取IM多值
        //        ABMultiValueRef instantMessage = ABRecordCopyValue(person, kABPersonInstantMessageProperty);
        //        for (int l = 1; l < ABMultiValueGetCount(instantMessage); l++)
        //        {
        //            //获取IM Label
        //            NSString* instantMessageLabel = (NSString*)CFBridgingRelease(ABMultiValueCopyLabelAtIndex(instantMessage, l));
        //            //获取該label下的2属性
        //            NSDictionary* instantMessageContent =(NSDictionary*) CFBridgingRelease(ABMultiValueCopyValueAtIndex(instantMessage, l));
        //            NSString* username = [instantMessageContent valueForKey:(NSString *)kABPersonInstantMessageUsernameKey];
        //
        //            NSString* service = [instantMessageContent valueForKey:(NSString *)kABPersonInstantMessageServiceKey];
        //        }
        //        CFRelease(instantMessage);
        //        //读取电话多值
        //        ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
        //        for (int k = 0; k<ABMultiValueGetCount(phone); k++)
        //        {
        //            //获取电话Label≥
        //            NSString * personPhoneLabel = (NSString*)CFBridgingRelease(ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(phone, k)));
        //            //获取該Label下的电话值
        //            NSString * personPhone = (NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(phone, k));
        //
        //        }
        //        CFRelease(phone);
        //
        //        //获取URL多值
        //        ABMultiValueRef url = ABRecordCopyValue(person, kABPersonURLProperty);
        //        for (int m = 0; m < ABMultiValueGetCount(url); m++)
        //        {
        //            //获取电话Label
        //            NSString * urlLabel = (NSString*)CFBridgingRelease(ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(url, m)));
        //            //获取該Label下的电话值
        //            NSString * urlContent = (NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(url,m));
        //        }
        //        CFRelease(url);
        //        //读取照片
        //        NSData *imageData = (NSData*)CFBridgingRelease(ABPersonCopyImageData(person));
    }
    CFRelease(people);
    //对数组进行排序
//    [self setUpTableSectionWithArray:self.people];
#pragma clang diagnostic pop
}

#pragma mark - getter
- (NSArray *)allPeople {
    return self.people;
}

- (NSMutableArray *)sequencePeoples{
    return self.sequencePeoplesTmp;
}
- (NSMutableArray *)sequencePeopleTitles{
    return self.sequencePeopleTitlesTmp;
}
#pragma mark - helper
+ (void)postMainThreadNotification:(NSString *)notificationName {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    if ([NSThread isMainThread]) {
        [center postNotificationName:notificationName object:[self manager] userInfo:nil];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [center postNotificationName:notificationName object:[self manager] userInfo:nil];
        });
    }
}

#pragma mark - 数组排序
- (void) setUpTableSectionWithArray:(NSArray *)array{
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    
    //初始化一个数组newSectionsArray用来存放最终的数据，我们最终要得到的数据模型应该形如@[@[以A开头的数据数组], @[以B开头的数据数组], @[以C开头的数据数组], ... @[以#(其它)开头的数据数组]]
    NSUInteger numberOfSections = [[collation sectionTitles] count];
    NSMutableArray *newSectionArray =  [[NSMutableArray alloc] init];
    for (NSUInteger index = 0; index<numberOfSections; index++) {
        [newSectionArray addObject:[[NSMutableArray alloc]init]];
    }
    
    //初始化27个空数组加入newSectionsArray
    for (NVMContact *model in array) {
        NSUInteger sectionIndex = [collation sectionForObject:model collationStringSelector:@selector(fullName)];
        [newSectionArray[sectionIndex] addObject:model];
    }
    
    //对每个section中的数组按照name属性排序
    for (NSUInteger index=0; index<numberOfSections; index++) {
        NSMutableArray *personsForSection = newSectionArray[index];
        NSArray *sortedPersonsForSection = [collation sortedArrayFromArray:personsForSection collationStringSelector:@selector(fullName)];
        newSectionArray[index] = sortedPersonsForSection;
    }
    
    NSMutableArray *temp = [NSMutableArray new];
    
    [newSectionArray enumerateObjectsUsingBlock:^(NSArray *arr, NSUInteger idx, BOOL *stop) {
        if (arr.count == 0) {
            [temp addObject:arr];
        } else {
            [self.sequencePeopleTitlesTmp addObject:[collation sectionTitles][idx]];
        }
    }];
    [newSectionArray removeObjectsInArray:temp];
    
    self.sequencePeoplesTmp = newSectionArray;
}

#pragma mark - 修改电话号码格式
- (NSString *)editPhoneStyleWithPhone:(NSString *)phone{
    NSString* normalPhone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    if ([normalPhone hasPrefix:@"86"]) {
        NSString *formatStr = [normalPhone substringWithRange:NSMakeRange(2, [phone length]-2)];
        return formatStr;
    }
    else if ([normalPhone hasPrefix:@"+86"])
    {
        if ([normalPhone hasPrefix:@"+86·"]) {
            NSString *formatStr = [normalPhone substringWithRange:NSMakeRange(4, [phone length]-4)];
            return formatStr;
        }
        else
        {
            NSString *formatStr = [normalPhone substringWithRange:NSMakeRange(3, [normalPhone length]-3)];
            return formatStr;
        }
    }else{
        return normalPhone;
    }
}
@end
