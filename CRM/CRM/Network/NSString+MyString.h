//
//  NSString+MyString.h
//  CRM
//
//  Created by Argo Zhang on 15/11/30.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MyString)

- (NSString *)hourMinutesSecondTimeFormat;

+ (NSString *)stringwithNumber:(NSNumber *)number;

- (NSString *)timeToNow;

- (NSMutableAttributedString *)changeStrColorWithIndex:(NSInteger)index;

@end
