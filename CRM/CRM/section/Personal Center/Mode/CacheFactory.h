//
//  CacheFactory.h
//  hotelHelper
//
//  Created by doctor on 14-6-4.
//  Copyright (c) 2014年 doctor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheFactory : NSObject

+(CacheFactory *)sharedCacheFactory;
-(NSString*)saveToPathAsFileName:(NSString*)fileName;

@end
