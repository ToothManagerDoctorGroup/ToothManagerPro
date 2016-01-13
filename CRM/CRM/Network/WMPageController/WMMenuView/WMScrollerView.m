//
//  WMScrollerView.m
//  CRM
//
//  Created by Argo Zhang on 16/1/13.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "WMScrollerView.h"

@implementation WMScrollerView

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (gestureRecognizer.state != 0) {
        return YES;
    } else {
        return NO;
    }
}

@end
