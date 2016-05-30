//
//  PatientManager.m
//  CRM
//
//  Created by TimTiger on 5/31/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "PatientManager.h"
#import "SDImageCache.h"
#import "UIImage+Resize.h"

@implementation PatientManager
+ (NSString *)pathImageSaveToCache:(UIImage *)image withKey:(NSString *)key {
    NSData *imageData = UIImageJPEGRepresentation(image, 0);
    UIImage *storeImage = [UIImage imageWithData:imageData];
    [[SDImageCache sharedImageCache] storeImage:storeImage forKey:key toDisk:NO];
    return key;
}

+ (NSString *)pathImageSaveToDisk:(UIImage *)image withKey:(NSString *)key {
    NSData *imageData = UIImageJPEGRepresentation(image, 0);
    UIImage *storeImage = [UIImage imageWithData:imageData];
    [[SDImageCache sharedImageCache] storeImage:storeImage forKey:key toDisk:YES];
    return key;
}

+ (CGSize)getSizeWithString:(NSString *)string {
    CGSize size = [string sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(175, 10000) lineBreakMode:NSLineBreakByCharWrapping];
    return size;
}

+ (NSData *)pathImageGetFromDisk:(NSString *)key {

   return UIImageJPEGRepresentation([[SDImageCache sharedImageCache] imageFromDiskCacheForKey:key], 0);
}

+ (BOOL)IsImageExisting:(NSString *)key {
    
    return [[SDImageCache sharedImageCache] diskImageExistsWithKey:key];
    
}


@end
