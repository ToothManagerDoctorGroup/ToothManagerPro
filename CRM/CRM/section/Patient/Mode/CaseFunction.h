//
//  CaseFunction.h
//  CRM
//
//  Created by mac on 14-5-21.
//  Copyright (c) 2014年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBTableMode.h"

@interface CaseFunction : NSObject

//通过patient对象，拼接图像路径
+ (NSString *)getCasePath:(NSString *)caseid patientId:(NSString *)patientId;

//检查是否存在该病例的文件夹，没有就新建
+ (NSString *)checkCaseDirectoryWithCaseId:(NSString *)caseid patientId:(NSString *)patientId;

//保存患者的CT图像，和路径(path)对应起来
+ (BOOL)saveImageWithImage:(UIImage *)image AndWithCTLib:(CTLib *)ctlib;

//删除当前图片
+ (BOOL)deleteImageWithCTLib:(CTLib *)ctlib;

//给图片起名字，是以当前放进文件夹的时间字符串命名
+ (NSString *)generateImageNameWithId:(NSString *)ctlibid;

//获取文件夹下得所有图片,返回一个图片数组
+ (NSArray *)getImageByCase:(MedicalCase *)mCase;

//获取文件夹下的所有图片的文件名，返回一个数组
+ (NSArray *)getImageNameByCase:(MedicalCase *)mCase;

//将字符串转化为时间
+ (NSDate *)stringToDate:(NSString *)string style:(NSString *)style;

+ (UIImage *)getImageWithCaseid:(NSInteger)caseid ctLibId:(NSInteger)ctlibid;

+ (BOOL)deleteImageWithCase:(MedicalCase *)medicalcase;

+ (BOOL)deleteImageWithPatientId:(NSString *)patientId;

@end
