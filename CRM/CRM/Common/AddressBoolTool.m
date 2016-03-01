//
//  AddressBoolTool.m
//  CRM
//
//  Created by Argo Zhang on 16/2/26.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "AddressBoolTool.h"
#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>
#import "DBTableMode.h"

@implementation AddressBoolTool
Realize_ShareInstance(AddressBoolTool);

- (UIImage *)drawImageWithSourceImage:(UIImage *)sourceImage plantTime:(NSString *)plantTime{
    //首先取到要作为背景的图片（原始图片）
    UIImage *black = [UIImage imageNamed:@"draw_bg_black"];
    
    // 1.开启一个BitMap上下文，大小和原始图片一样（最简单的方法是通过UIKit框架来创建）
    CGSize imageSize = CGSizeMake(kScreenWidth, kScreenHeight);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    
    [black drawInRect:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    
    // 3.画种植时间
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    if ([plantTime isNotEmpty] && plantTime.length > 0) {
        NSString *time1 = [NSString stringWithFormat:@"种植时间:%@",[plantTime componentsSeparatedByString:@" "][0]];
        CGSize time1Size = [time1 sizeWithFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
        CGFloat time1Y = 140 + 20 + 20;
        CGFloat time1X = (kScreenWidth - time1Size.width) / 2;
        [time1 drawAtPoint:CGPointMake(time1X, time1Y) withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial-BoldMT" size:16],NSForegroundColorAttributeName:[UIColor whiteColor]}];
        
        imageY = time1Y + time1Size.height + 20;
    }else{
        imageY = 140 + 20 + 20;
    }
    
    // 2.往BitMap中画背景图片
    [sourceImage drawInRect:CGRectMake(imageX, imageY, kScreenWidth, 180)];
    
    // 4.从上下文中取得画好的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 5.关闭上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - 修改通讯录联系人的头像
- (void)saveWithImage:(UIImage *)image person:(NSString *)personName phone:(NSString *)personPhone{
    ABAddressBookRef addressBook = [self getAddressBook];
    
    NSArray* contacts = (__bridge NSArray *)(ABAddressBookCopyPeopleWithName(addressBook, (__bridge CFStringRef)(personName)));
    for (int i = 0; i < contacts.count; i++) {
        ABRecordRef person = (__bridge ABRecordRef)[contacts objectAtIndex:i];
        NSString *phone = [self phoneNumberWithABRecordRef:person];
        if ([phone isEqualToString:personPhone]) {
            //设置头像
            NSData *data=UIImagePNGRepresentation(image);
            ABPersonRemoveImageData(person, NULL);
            ABAddressBookAddRecord(addressBook, person, nil);
            ABAddressBookSave(addressBook, nil);
            CFDataRef cfData=CFDataCreate(NULL, [data bytes], [data length]);
            ABPersonSetImageData(person, cfData, nil);
            ABAddressBookAddRecord(addressBook, person, nil);
            ABAddressBookSave(addressBook, nil);
        }
    }
    // 释放通讯录对象的引用
    [self releaseAddressBook:addressBook];
}

#pragma mark - Private API
//
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

#pragma mark - 根据姓名查询联系人
- (BOOL)getContactsWithName:(NSString *)contactName phone:(NSString *)contactPhone{
    ABAddressBookRef addressBook = [self getAddressBook];
    
    NSArray* contacts = (__bridge NSArray *)(ABAddressBookCopyPeopleWithName(addressBook, (__bridge CFStringRef)(contactName)));
    
    //判断联系人是否存在
    BOOL exist = NO;
    for (int i = 0; i < [contacts count]; i++)
    {
        ABRecordRef person = (__bridge ABRecordRef)[contacts objectAtIndex:i];
        NSString *phone = [self phoneNumberWithABRecordRef:person];
        //        UIImage *image = [self imageWithABRecordRef:person];
        if ([phone isEqualToString:contactPhone]) {
            //表明联系人已经存在
            exist = YES;
        }
    }
    // 释放通讯录对象的引用
    [self releaseAddressBook:addressBook];
    
    return exist;
}

#pragma mark - 将患者插入到通讯录
- (void)addContactToAddressBook:(Patient *)patient{
    ABAddressBookRef addressBook = [self getAddressBook];
    // 新建一个联系人
    // ABRecordRef是一个属性的集合，相当于通讯录中联系人的对象
    // 联系人对象的属性分为两种：
    // 只拥有唯一值的属性和多值的属性。
    // 唯一值的属性包括：姓氏、名字、生日等。
    // 多值的属性包括:电话号码、邮箱等。
    ABRecordRef person = ABPersonCreate();
    // 保存到联系人对象中，每个属性都对应一个宏，例如：kABPersonFirstNameProperty
    // 设置firstName属性
    NSString *nameStr = patient.patient_name;
    CFStringRef nameRef = (__bridge CFStringRef)nameStr;
    NSString *phoneStr = patient.patient_phone;
    CFStringRef phoneRef = (__bridge CFStringRef)phoneStr;
    
    
    ABRecordSetValue(person, kABPersonFirstNameProperty,nameRef, NULL);
    // ABMultiValueRef类似是Objective-C中的NSMutableDictionary
    // 添加电话号码与其对应的名称内容
    ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multiPhone, phoneRef, kABPersonPhoneMainLabel, NULL);
    // 设置phone属性
    ABRecordSetValue(person, kABPersonPhoneProperty, multiPhone, NULL);
    // 释放该数组
    CFRelease(multiPhone);
    // 将新建的联系人添加到通讯录中
    ABAddressBookAddRecord(addressBook, person, NULL);
    // 保存通讯录数据
    ABAddressBookSave(addressBook, NULL);
    // 释放通讯录对象的引用
    [self releaseAddressBook:addressBook];
}

#pragma mark - 获取通讯录操作类
- (ABAddressBookRef)getAddressBook{
    ABAddressBookRef addressBook = nil;
    
    //获取通讯录权限 ios6.0以上需要获取权限读通信录
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
    {
        addressBook =  ABAddressBookCreateWithOptions(NULL, NULL);
        
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error){dispatch_semaphore_signal(sema);});
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        addressBook = ABAddressBookCreate();
#pragma clang diagnostic pop
    }
   
    return addressBook;
}

#pragma mark - 释放通讯录操作类
- (void)releaseAddressBook:(ABAddressBookRef)addressBook{
    if (addressBook) {
        CFRelease(addressBook);
    }
}

@end