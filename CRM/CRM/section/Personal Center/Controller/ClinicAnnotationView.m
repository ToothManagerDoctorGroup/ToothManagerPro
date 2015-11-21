//
//  ClinicAnnotationView.m
//  CRM
//
//  Created by Argo Zhang on 15/11/14.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "ClinicAnnotationView.h"
#import "ClinicAnnotation.h"
#import "UnSignClinicModel.h"

#define TitleFont [UIFont systemFontOfSize:16]

@implementation ClinicAnnotationView

+ (instancetype)clinicAnnotationViewWithMapView:(BMKMapView *)mapView annotation:(id <BMKAnnotation>)annotation{
    //设置重用id
    static NSString *ID = @"clinic_annotation";
    ClinicAnnotationView *clinicView = (ClinicAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    if (clinicView == nil) {
        clinicView = [[self alloc] initWithAnnotation:annotation reuseIdentifier:ID];
    }
    return clinicView;
}

- (instancetype)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        
        //设置标识图片
        self.image = [UIImage imageNamed:@"location.png"];
        //设置标识图片的位置
        //设置标识图片的位置(自定义的图片，默认坐标点是在中心点上)
        self.centerOffset = CGPointMake(0, -self.image.size.height * 0.5);
        
        self.canShowCallout = YES;
    }
    
    return self;
}

@end
