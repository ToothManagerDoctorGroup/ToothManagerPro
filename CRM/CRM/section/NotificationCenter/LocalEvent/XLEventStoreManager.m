//
//  XLEventStoreManager.m
//  CRM
//
//  Created by Argo Zhang on 16/1/11.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLEventStoreManager.h"
#import <EventKit/EventKit.h>
#import "LocalNotificationCenter.h"
#import "MyDateTool.h"
#import "DBManager+Patients.h"

@interface XLEventStoreManager ()

@property (nonatomic, strong)EKEventStore *eventStore;

@end

@implementation XLEventStoreManager
Realize_ShareInstance(XLEventStoreManager);

//- (EKEventStore *)eventStore{
//    if (_eventStore) {
//        _eventStore = [[EKEventStore alloc] init];
//    }
//    return _eventStore;
//}

- (void)addEventToSystemCalendarWithLocalNotification:(LocalNotification *)noti patient:(Patient *)patient{
    if (self.eventStore == nil) {
        self.eventStore = [[EKEventStore alloc] init];
    }
    //6.0及以上通过下面方式写入事件
    if ([self.eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)])
    {
        [self.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error)
                {
                    //错误细心
                    // display error message here
                }
                else if (!granted)
                {
                    //被用户拒绝，不允许访问日历
                }
                else
                {
                    //事件保存到日历
                    //创建事件
                    EKEvent *event  = [EKEvent eventWithEventStore:self.eventStore];
                    event.title     = [NSString stringWithFormat:@"患者 %@ %@",patient.patient_name,noti.reserve_type];
                    event.location = noti.medical_place;
                    
                    NSDateFormatter *tempFormatter = [[NSDateFormatter alloc]init];
                    [tempFormatter setDateFormat:@"dd.MM.yyyy HH:mm"];
                    
                    NSString *startT = noti.reserve_time;
                    NSString *endT = [self reserve_time_end:noti];
                    
                    event.startDate = [MyDateTool dateWithStringWithSec:startT];
                    event.endDate   = [MyDateTool dateWithStringWithSec:endT];
                    event.allDay = NO;
                    
                    //添加提醒
                    [event addAlarm:[EKAlarm alarmWithRelativeOffset:60.0f * -60.0f * 24]];
                    [event addAlarm:[EKAlarm alarmWithRelativeOffset:60.0f * -15.0f]];
                    
                    [event setCalendar:[self.eventStore defaultCalendarForNewEvents]];
                    NSError *err;
                    [self.eventStore saveEvent:event span:EKSpanThisEvent error:&err];
                    
                    NSLog(@"保存成功");
                    
                }
            });
        }];
    }else
    {
        //4.0和5.0通过下述方式添加
        
        EKEvent *event  = [EKEvent eventWithEventStore:self.eventStore];
        event.title     = [NSString stringWithFormat:@"患者 %@ %@",patient.patient_name,noti.reserve_type];
        event.location = noti.medical_place;
        
        NSDateFormatter *tempFormatter = [[NSDateFormatter alloc]init];
        [tempFormatter setDateFormat:@"dd.MM.yyyy HH:mm"];
        
        NSString *startT = noti.reserve_time;
        NSString *endT = [self reserve_time_end:noti];
        
        event.startDate = [MyDateTool dateWithStringWithSec:startT];
        event.endDate   = [MyDateTool dateWithStringWithSec:endT];
        event.allDay = NO;
        
        
        [event addAlarm:[EKAlarm alarmWithRelativeOffset:60.0f * -60.0f * 24]];
        [event addAlarm:[EKAlarm alarmWithRelativeOffset:60.0f * -15.0f]];
        
        [event setCalendar:[self.eventStore defaultCalendarForNewEvents]];
        NSError *err;
        [self.eventStore saveEvent:event span:EKSpanThisEvent error:&err];
        
    }
}
//删除一个系统日历事件
- (void)removeEventToSystemCalendarWithLocalNotification:(LocalNotification *)noti{
    
    if (self.eventStore == nil) {
        self.eventStore = [[EKEventStore alloc] init];
    }
    //根据localNoti获取当前对应的日历事件
    NSArray *events = [self getEventWithLocalNotification:noti];
    
    //删除日历事件
    for (EKEvent *event in events) {
        //删除事件
        NSError *error;
        if([self.eventStore removeEvent:event span:EKSpanThisEvent error:&error]){
            NSLog(@"日历事件删除成功");
        }
    }
}

- (NSArray *)getEventWithLocalNotification:(LocalNotification *)noti{
//    // 获取适当的日期（Get the appropriate calendar）
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    
//    // 创建起始日期组件（Create the start date components）
//    NSDateComponents *oneDayAgoComponents = [[NSDateComponents alloc] init];
//    oneDayAgoComponents.day = -1;
//    NSDate *oneDayAgo = [calendar dateByAddingComponents:oneDayAgoComponents
//                                                  toDate:[NSDate date]
//                                                 options:0];
//    
//    // 创建结束日期组件（Create the end date components）
//    NSDateComponents *oneYearFromNowComponents = [[NSDateComponents alloc] init];
//    oneYearFromNowComponents.year = 1;
//    NSDate *oneYearFromNow = [calendar dateByAddingComponents:oneYearFromNowComponents
//                                                       toDate:[NSDate date]
//                                                      options:0];
    
    //获取起止时间
    NSString *startT = noti.reserve_time;
    NSString *endT = [self reserve_time_end:noti];
    // 用事件库的实例方法创建谓词 (Create the predicate from the event store's instance method)
    NSPredicate *predicate = [self.eventStore predicateForEventsWithStartDate:[MyDateTool dateWithStringWithSec:startT]
                                                            endDate:[MyDateTool dateWithStringWithSec:endT]
                                                          calendars:nil];
    
    // 获取所有匹配该谓词的事件(Fetch all events that match the predicate)
    NSArray *events = [self.eventStore eventsMatchingPredicate:predicate];
    Patient *tpatient = [[DBManager shareInstance] getPatientWithPatientCkeyid:noti.patient_id];
    NSString *title = [NSString stringWithFormat:@"患者 %@ %@",tpatient.patient_name,noti.reserve_type];
    NSString *location = noti.medical_place;
    
    NSMutableArray *searchEvents = [NSMutableArray array];
    for (EKEvent *event in events) {
        if ([event.title isEqualToString:title] && [event.location isEqualToString:location]) {
            [searchEvents addObject:event];
        }
    }
    return searchEvents;
}


//获取结束时间
- (NSString *)reserve_time_end:(LocalNotification *)noti{
    //获取开始时间
    NSDate *startTime = [MyDateTool dateWithStringWithSec:noti.reserve_time];
    NSDate *endTime = [startTime dateByAddingTimeInterval:(int)60 * 60 * [noti.duration floatValue]];
    
    return [MyDateTool stringWithDateWithSec:endTime];
}


@end
