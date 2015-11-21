//
//  ClinicAnnotation.m
//  CRM
//
//  Created by Argo Zhang on 15/11/17.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "ClinicAnnotation.h"
#import "UnSignClinicModel.h"

@implementation ClinicAnnotation

- (NSString *)title{
    return self.model.clinic_name;
}

- (NSString *)subtitle{
    return self.model.clinic_location;
}

@end
