//
//  CacheFactory.m
//  hotelHelper
//
//  Created by doctor on 14-6-4.
//  Copyright (c) 2014年 doctor. All rights reserved.
//

#import "CacheFactory.h"

@implementation CacheFactory

+ (CacheFactory *)sharedCacheFactory
{
    static CacheFactory *sharedCacheFactory = nil;
    if (sharedCacheFactory == nil)
    {
        sharedCacheFactory = [[CacheFactory alloc] init];
    }
    return sharedCacheFactory;
}

-(NSString*)saveToPathAsFileName:(NSString*)fileName;
{
    if (!fileName) {
        return nil;
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = [paths objectAtIndex:0];
    cacheDirectory = [cacheDirectory stringByAppendingPathComponent:@"/data"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:cacheDirectory]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:cacheDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
//    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *path = [paths objectAtIndex:0];
    
    return [cacheDirectory stringByAppendingPathComponent:fileName];
}

@end
