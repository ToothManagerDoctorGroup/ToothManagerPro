//
//  IntroducerCellMode.h
//  CRM
//
//  Created by TimTiger on 6/1/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IntroducerCellMode : NSObject

@property (nonatomic,copy) NSString *name;
@property (nonatomic,readwrite) NSInteger count;
@property (nonatomic,readwrite) NSInteger level;
@property (nonatomic,copy) NSString *ckeyid;

@end
