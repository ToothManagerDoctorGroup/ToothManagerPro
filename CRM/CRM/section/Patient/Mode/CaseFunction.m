//
//  CaseFunction.m
//  CRM
//
//  Created by mac on 14-5-21.
//  Copyright (c) 2014年 TimTiger. All rights reserved.
//

#import "CaseFunction.h"
#import <CommonCrypto/CommonDigest.h>
#import "TimFramework.h"

@implementation CaseFunction

//通过patient对象，拼接图像路径
+ (NSString *)getCasePath:(NSString *)caseid patientId:(NSString *)patientId;
{
    //创建一个文件夹是用Caseid来命名（id是自增的，删除病历之后，文件系统可能出错；要确保id是唯一的）
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"patientPhotos"];
    NSString * case_id = [NSString stringWithFormat:@"%@/%@",patientId,caseid];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:case_id];
    return documentsDirectory;
}

+ (NSString *)getPatientPath:(NSString *)patientId {
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"patientPhotos"];
    NSString * case_id = patientId;
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:case_id];
    return documentsDirectory;
}

//检查是否存在该患者的文件夹，没有就新建
+ (NSString *)checkCaseDirectoryWithCaseId:(NSString *)caseid patientId:(NSString *)patientId;
{
    //检查Documents下的目录，(Documents/patientPhotos/patientId)用来存放病人的图片；没有则创建
    NSString * documentsDirectory = [CaseFunction getCasePath:caseid patientId:patientId];
    NSFileManager * fm = [NSFileManager defaultManager];
    BOOL bl=[fm fileExistsAtPath:documentsDirectory];
    if (!bl)
        [fm createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    return documentsDirectory;
}

//保存患者的CT图像，和路径(path)对应起来
+ (BOOL)saveImageWithImage:(UIImage *)image AndWithCTLib:(CTLib *)ctlib
{
    NSString * imageName = [NSString stringWithFormat:@"%@",ctlib.ct_image];
    NSData *data = UIImagePNGRepresentation(image);
    NSString *filePath = [CaseFunction checkCaseDirectoryWithCaseId:ctlib.case_id patientId:ctlib.patient_id];
    NSString * imagePath = [filePath stringByAppendingPathComponent:imageName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:imagePath]) {
        return YES;
    }
    if ([data writeToFile:imagePath atomically:YES]) {
        return YES;
    } else {
        return NO;
    }
}


//删除当前图片
+ (BOOL)deleteImageWithCTLib:(CTLib *)ctlib
{
    NSString *filePath = [CaseFunction getCasePath:ctlib.case_id patientId:ctlib.patient_id];
    NSFileManager * fm = [NSFileManager defaultManager];
    NSString * imagePath = [filePath stringByAppendingPathComponent:ctlib.ct_image];
    if ([fm removeItemAtPath:imagePath error:nil])
        return YES;
    else
        return NO;
}

+ (BOOL)deleteImageWithCase:(MedicalCase *)medicalcase {
    NSString *filePath = [CaseFunction getCasePath:medicalcase.ckeyid patientId:medicalcase.patient_id];
    NSFileManager * fm = [NSFileManager defaultManager];
    if ([fm removeItemAtPath:filePath error:nil])
        return YES;
    else
        return NO;
}

+ (BOOL)deleteImageWithPatientId:(NSString *)patientId {
    NSString *filePath = [CaseFunction getPatientPath:patientId];
    NSFileManager * fm = [NSFileManager defaultManager];
    if ([fm removeItemAtPath:filePath error:nil])
        return YES;
    else
        return NO;
}

//给图片起名字，是以当前放进文件夹的时间字符串命名
+ (NSString *)generateImageNameWithId:(NSString *)ctlibid
{
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSNumber *counter = [userDefalut objectForKey:@"counter"];
    NSInteger counterInteger = 0;
    if (counter == nil) {
        counter = @(1);
    } else {
        counterInteger = [counter integerValue];
    }
    counterInteger++;
    [userDefalut setObject:[NSNumber numberWithInteger:counterInteger] forKey:@"counter"];
    [userDefalut synchronize];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString =  [NSString stringWithFormat:@"%@%@%d.png",[dateFormatter stringFromDate:[NSDate date]],ctlibid,(int)counterInteger];// [NSString stringWithFormat:@"%@%ld",[[dateFormatter stringFromDate:[NSDate date]],ctlibid]];
    dateString = [dateString MD5];
    return dateString;
}

//获取文件夹下得所有图片,返回一个图片数组
+ (NSArray *)getImageByCase:(MedicalCase *)mCase
{
    NSMutableArray * imageArray = [[NSMutableArray alloc]initWithCapacity:0];
    NSString * recodeDocumentsDirectory=[CaseFunction getCasePath:mCase.ckeyid patientId:mCase.patient_id];
    NSFileManager * rfm=[NSFileManager defaultManager];
    NSArray * tmpArray=[rfm contentsOfDirectoryAtPath:recodeDocumentsDirectory error:nil];
    for (NSString * elem in tmpArray){
        UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",recodeDocumentsDirectory,elem]];
        [imageArray addObject:image];
    }
    return imageArray;
}

//获取文件夹下的所有图片的文件名，返回一个数组
+ (NSArray *)getImageNameByCase:(MedicalCase *)mCase
{
    NSString * recodeDocumentsDirectory=[CaseFunction getCasePath:mCase.ckeyid patientId:mCase.patient_id];
    NSFileManager * rfm=[NSFileManager defaultManager];
    NSArray * imageNameArray = [rfm subpathsAtPath:recodeDocumentsDirectory];
    return imageNameArray;
}

//将字符串转化为时间
+ (NSDate *)stringToDate:(NSString *)string style:(NSString *)style
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:style];
    NSDate *date = [dateFormatter dateFromString:string];
//    //解决系统时区与本地时区差
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    //和格林尼治时间差
//    NSInteger timeOff = [zone secondsFromGMT];
//    NSDate * timeOffDate = [date dateByAddingTimeInterval:timeOff];
    return date;
}
@end
