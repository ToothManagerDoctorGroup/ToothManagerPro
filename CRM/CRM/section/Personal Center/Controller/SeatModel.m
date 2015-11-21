//
//  SeatModel.m
//  CRM
//
//  Created by Argo Zhang on 15/11/13.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "SeatModel.h"
#import "MJExtension.h"
#import "SeatInfosModel.h"
#import "SeatImgInfosModel.h"

@implementation SeatModel

+ (NSDictionary *)objectClassInArray{
    return @{@"SeatInfos":[SeatInfosModel class],@"SeatImgInfos":[SeatImgInfosModel class]};
}

@end
