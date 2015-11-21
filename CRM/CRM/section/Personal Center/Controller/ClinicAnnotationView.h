//
//  ClinicAnnotationView.h
//  CRM
//
//  Created by Argo Zhang on 15/11/14.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "BaiduMapHeader.h"

@interface ClinicAnnotationView : BMKAnnotationView{
    UIView *_commentView;
    UILabel *_titleLabel; //标题视图
    UILabel *_subTitleLabel; //子标题视图
}

+ (instancetype)clinicAnnotationViewWithMapView:(BMKMapView *)mapView annotation:(id <BMKAnnotation>)annotation;

@end
