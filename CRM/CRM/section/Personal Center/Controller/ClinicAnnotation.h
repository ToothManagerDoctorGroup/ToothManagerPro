//
//  ClinicAnnotation.h
//  CRM
//
//  Created by Argo Zhang on 15/11/17.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaiduMapHeader.h"

@class UnSignClinicModel;
@interface ClinicAnnotation : NSObject<BMKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property (nonatomic, strong)UnSignClinicModel *model;

@property (nonatomic, copy)NSString *clinic_id;

- (NSString *)title;
- (NSString *)subtitle;

@end
