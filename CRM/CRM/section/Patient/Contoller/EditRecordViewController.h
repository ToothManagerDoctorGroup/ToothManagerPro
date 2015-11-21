//
//  EditRecordViewController.h
//  CRM
//
//  Created by mac on 14-5-14.
//  Copyright (c) 2014年 TimTiger. All rights reserved.
//

#import "TimFramework.h"

@interface EditRecordViewController : TimViewController <UIScrollViewDelegate>
{
    UIPageControl * pageCtl;
    UIScrollView * headImageScroll;
    NSMutableArray *ImageArry;
    
    UIView * upView;
    UIView * middleView;
    UIView * bottomView;
}
@end
