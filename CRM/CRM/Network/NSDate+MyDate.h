//
//  NSDate+MyDate.h
//  CRM
//
//  Created by Argo Zhang on 15/11/30.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (MyDate)
+ (instancetype)fs_dateFromString:(NSString *)string format:(NSString *)format;
@end
