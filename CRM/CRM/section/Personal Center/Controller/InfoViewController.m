//
//  InfoViewController.m
//  MCRPages
//
//  Created by fankejun on 14-5-25.
//  Copyright (c) 2014年 CRM. All rights reserved.
//

#import "InfoViewController.h"

@interface InfoViewController ()

@end

@implementation InfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"个人信息";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self initView];
}

- (void)initView
{
    UIColor * bgColor = [UIColor colorWithRed:94.0f / 255.0f green:113.0f / 255.0f blue:197.0f / 255.0f alpha:1];
    [self.view setBackgroundColor:bgColor];
    
    float mag_x = 20.0f;
    float mag_y =20.0f;
    float lable_height = 35.0f;
    float lable_width = 200.0f;
    UIColor * textColor = [UIColor whiteColor];
    
    UILabel * title_lable1 = [[UILabel alloc]init];
    [title_lable1 setFrame:CGRectMake(mag_x, mag_y, 60, lable_height)];
    [title_lable1 setBackgroundColor:[UIColor clearColor]];
    [title_lable1 setTextColor:textColor];
    [title_lable1 setText:@"用户名:"];
    [self.view addSubview:title_lable1];
    
    name_lable = [[UILabel alloc]init];
    [name_lable setFrame:CGRectMake(title_lable1.frame.size.width + mag_x,
                                      mag_y,
                                      lable_width,
                                      lable_height)];
    [name_lable setBackgroundColor:[UIColor clearColor]];
    [name_lable setTextColor:textColor];
    [name_lable setText:@"张壮壮"];
    [self.view addSubview:name_lable];
    
    UILabel * title_lable2 = [[UILabel alloc]init];
    [title_lable2 setFrame:CGRectMake(mag_x, mag_y + lable_height + 4, 60, lable_height)];
    [title_lable2 setBackgroundColor:[UIColor clearColor]];
    [title_lable2 setTextColor:textColor];
    [title_lable2 setText:@"等   级:"];
    [self.view addSubview:title_lable2];
    
    level_lable = [[UILabel alloc]init];
    [level_lable setFrame:CGRectMake(name_lable.frame.origin.x,
                                    title_lable2.frame.origin.y,
                                    lable_width,
                                    lable_height)];
    [level_lable setBackgroundColor:[UIColor clearColor]];
    [level_lable setTextColor:textColor];
    [level_lable setText:@"4级"];
    [self.view addSubview:level_lable];
    
    UILabel * title_lable3 = [[UILabel alloc]init];
    [title_lable3 setFrame:CGRectMake(mag_x, mag_y + (lable_height + 4) * 2, 60, lable_height)];
    [title_lable3 setBackgroundColor:[UIColor clearColor]];
    [title_lable3 setTextColor:textColor];
    [title_lable3 setText:@"电   话:"];
    [self.view addSubview:title_lable3];
    
    phoneField = [[UITextField alloc]init];
    [phoneField setFrame:CGRectMake(name_lable.frame.origin.x,
                                   title_lable3.frame.origin.y,
                                   lable_width,
                                    lable_height)];
    [phoneField setPlaceholder:@"12890901234"];
    [phoneField setBackgroundColor:textColor];
    [phoneField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self.view addSubview:phoneField];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [phoneField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
