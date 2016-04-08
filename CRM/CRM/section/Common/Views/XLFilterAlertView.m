//
//  XLFilterAlertView.m
//  CRM
//
//  Created by Argo Zhang on 16/3/31.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLFilterAlertView.h"
#import "XLCustomFilterView.h"
#import "XLFilterPatientStateView.h"
#import "XLFilterPatientTimeView.h"

@interface XLFilterAlertView ()<XLCustomFilterViewDataSource,XLCustomFilterViewDelegate,XLFilterPatientStateViewDelegate,XLFilterPatientTimeViewDelegate>

@property (nonatomic, strong)NSArray *dataList;

@end

@implementation XLFilterAlertView

#pragma mark - 懒加载
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.6];

    }
    return self;
}

- (NSArray *)dataList{
    if (!_dataList) {
        _dataList = @[@"全部",@"患者状态",@"新增患者",@"完成种植",@"完成修复"];
    }
    return _dataList;
}

- (void)showInView:(UIView *)superView{
    XLCustomFilterView *filterView = [[XLCustomFilterView alloc] initWithFrame:CGRectMake(0, 0, superView.width, 250) dataSource:self delegate:self];
    [self addSubview:filterView];
    [superView addSubview:self];
}

- (void)dismiss{
    if (self.delegate && [self.delegate respondsToSelector:@selector(filterAlertViewDidDismiss:)]) {
        [self.delegate filterAlertViewDidDismiss:self];
    }
    [self removeFromSuperview];
}

#pragma mark - XLCustomFilterViewDataSource
- (NSInteger)numberOfItemsInCustomFilterView:(XLCustomFilterView *)filterView{
    return self.dataList.count;
}
- (NSString *)customFilterView:(XLCustomFilterView *)filterView titleForItemAtIndex:(NSUInteger)index{
    return self.dataList[index];
}

- (UIView *)customFilterView:(XLCustomFilterView *)filterView viewForItemAtIndex:(NSUInteger)index{
    
    if (index == 0) {
        return nil;
    }else if (index == 1){
        XLFilterPatientStateView *stateView = [[XLFilterPatientStateView alloc] initWithFrame:CGRectMake(0, 0, filterView.width - 90, filterView.height)];
        stateView.delegate = self;
        return stateView;
    }else{
        XLFilterPatientTimeView *timeView = [[XLFilterPatientTimeView alloc] initWithFrame:CGRectMake(0, 0, filterView.width - 90, filterView.height)];
        timeView.delegate = self;
        switch (index) {
            case 2:
                timeView.type = FilterPatientTimeViewTypeNewPatient;
                break;
            case 3:
                timeView.type = FilterPatientTimeViewTypeImplanted;
                break;
            case 4:
                timeView.type = FilterPatientTimeViewTypeRepaired;
                break;
                
            default:
                break;
        }
        
        return timeView;
    }
}

- (void)customFilterView:(XLCustomFilterView *)filterView didSelectItem:(NSInteger)index{
    if (index == 0) {
        [self dismiss];
        if (self.delegate && [self.delegate respondsToSelector:@selector(filterAlertView:filterAlertViewType:patientStatus:startTime:endTime:)]) {
            [self.delegate filterAlertView:self filterAlertViewType:FilterAlertViewAll patientStatus:PatientStatuspeAll startTime:nil endTime:nil];
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    if(CGRectContainsPoint(CGRectMake(0, 0, kScreenWidth, 250), touchPoint)) return;
    [self dismiss];
}

#pragma mark - XLFilterPatientStateViewDelegate
- (void)filterPatientStateView:(XLFilterPatientStateView *)stateView didSelectItem:(NSInteger)index{
    [self dismiss];
    if (self.delegate && [self.delegate respondsToSelector:@selector(filterAlertView:filterAlertViewType:patientStatus:startTime:endTime:)]) {
        [self.delegate filterAlertView:self filterAlertViewType:FilterAlertViewPatientState patientStatus:index startTime:nil endTime:nil];
    }
}

#pragma mark - XLFilterPatientTimeViewDelegate
- (void)filterPatientTimeView:(XLFilterPatientTimeView *)timeView startTime:(NSString *)startTime endTime:(NSString *)endTime{
    [self dismiss];
    
    FilterAlertViewType type = FilterAlertViewNewPatient;
    if (timeView.type == FilterPatientTimeViewTypeImplanted) {
        type = FilterAlertViewImplanted;
    }else if (timeView.type == FilterPatientTimeViewTypeNewPatient){
        type = FilterAlertViewNewPatient;
    }else{
        type = FilterAlertViewRepaired;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(filterAlertView:filterAlertViewType:patientStatus:startTime:endTime:)]) {
        [self.delegate filterAlertView:self filterAlertViewType:type patientStatus:PatientStatuspeAll startTime:startTime endTime:endTime];
    }
}

@end
