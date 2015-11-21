//
//  EditRecordViewController.m
//  CRM
//
//  Created by mac on 14-5-14.
//  Copyright (c) 2014年 TimTiger. All rights reserved.
//

#import "EditRecordViewController.h"

@interface EditRecordViewController ()

@end

@implementation EditRecordViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //查看单条记录
        self.title = @"2014-4-28";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initSegMentView];
}

- (void)initData
{
    ImageArry = [[NSMutableArray alloc]initWithCapacity:0];
}

- (void)initSegMentView
{
    headImageScroll = [[UIScrollView alloc]init];
    [headImageScroll setFrame:CGRectMake(0,0,SELF_VIEW_BOUNDS_WIDTH, 180)];
    [headImageScroll setContentSize:CGSizeMake(320*ImageArry.count, headImageScroll.frame.size.height)];
    [headImageScroll setBackgroundColor:[UIColor blackColor]];
    [headImageScroll setPagingEnabled:YES];
    [self.view addSubview:headImageScroll];
    
    pageCtl=[[UIPageControl alloc]init];
    [pageCtl setFrame:CGRectMake(SELF_VIEW_BOUNDS_WIDTH/2, headImageScroll.frame.size.height+headImageScroll.frame.origin.y-20, 20, 20)];
//    [pageCtl setNumberOfPages:[ImageArry count]];
    [pageCtl setNumberOfPages:3];
    [pageCtl setCurrentPage:0];
    [pageCtl setBackgroundColor:[UIColor clearColor]];
    [pageCtl addTarget:self action:@selector(changePage) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:pageCtl];
}

- (void)initUpView
{
    
}

- (void)initMiddleView
{
    
}

- (void)initBottomView
{
    
}

-(void)changePage
{
    NSInteger page=[pageCtl currentPage];
    [headImageScroll setContentOffset:CGPointMake(self.view.frame.size.width*page, 0) animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
