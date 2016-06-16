//
//  XLAppointImageUploadParam.m
//  CRM
//
//  Created by Argo Zhang on 16/5/19.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLAppointImageUploadParam.h"
#import "AccountManager.h"
#import "MyDateTool.h"
#import "MJExtension.h"
#import "NSString+TTMAddtion.h"

@implementation XLAppointImageUploadParam

+ (NSArray *)ignoredPropertyNames{
    return @[@"imageData",@"imageUrl",@"thumbnailImage"];
}

- (instancetype)initWithThumbnailImage:(UIImage *)thumbnailImage
                              fileType:(NSString *)fileType
                             imageData:(NSData *)imageData{
    if (self = [super init]) {
        self.thumbnailImage = thumbnailImage;
        self.reserver_id = @"";
        self.file_name = @"image.jpg";
        self.file_type = fileType;
        self.doctor_id = [AccountManager currentUserid];
        self.creation_time = [MyDateTool stringWithDateWithSec:[NSDate date]];
        self.imageData = imageData;
    }
    return self;
}

@end
