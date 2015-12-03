//
//  EditCaseViewController.m
//  MCRPages
//
//  Created by fankejun on 14-5-14.
//  Copyright (c) 2014年 mifeo. All rights reserved.
//

#import "EditCaseViewController.h"

@interface EditCaseViewController ()
{
    
}
@end

#define LARGE_HEIGHT 118.0f
#define SMALL_HEIGHT 90.0f
#define BOUNDS_WIDTH self.view.frame.size.width
#define BOUNDS_HEIGHT self.view.frame.size.height

@implementation EditCaseViewController
@synthesize patient,medicalCase;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"编辑单条病程";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setRightBarButtonWithImage:[UIImage imageNamed:@"finish_button"]];
    [self initView];
    [self initCTView];
    [self initTimeView];
    [self initDescriptionView];
    [self initMaterialView];
}

#pragma mark - Button Action
- (void)onRightButtonAction:(id)sender {
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"保存病程" message:@"保存病程成功!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (void)initView
{
    UIColor * color = [UIColor colorWithRed:94.0f / 255.0f green:113.0f / 255.0f blue:197.0f / 255.0f alpha:1];
    [self.view setBackgroundColor:color];
    
    //CT片
    CTImageView = [[UIView alloc]init];
    [CTImageView setFrame:CGRectMake(0, 0, BOUNDS_WIDTH, LARGE_HEIGHT)];
//    [CTImageView setBackgroundColor:[UIColor orangeColor]];
    [self.view addSubview:CTImageView];
    
    //下次预约时间
    appointTimeView = [[UIView alloc]init];
    [appointTimeView setFrame:CGRectMake(0, CTImageView.frame.size.height + CTImageView.frame.origin.y, BOUNDS_WIDTH, SMALL_HEIGHT)];
//    [appointTimeView setBackgroundColor:[UIColor purpleColor]];
    [self.view addSubview:appointTimeView];
    
    //病情描述
    descriptionView = [[UIView alloc]init];
    [descriptionView setFrame:CGRectMake(0, appointTimeView.frame.size.height + appointTimeView.frame.origin.y , BOUNDS_WIDTH, SMALL_HEIGHT)];
//    [descriptionView setBackgroundColor:[UIColor yellowColor]];
    [self.view addSubview:descriptionView];
    
    //所用耗材
    materialView = [[UIView alloc]init];
    [materialView setFrame:CGRectMake(0, descriptionView.frame.size.height + descriptionView.frame.origin.y, BOUNDS_WIDTH, LARGE_HEIGHT)];
//    [materialView setBackgroundColor:[UIColor greenColor]];
    [self.view addSubview:materialView];
}

- (void)initCTView
{
    UILabel * CTLable = [[UILabel alloc]init];
    [CTLable setFrame:CGRectMake(5, 0, 50, 20)];
    [CTLable setText:@"CT片:"];
    [CTLable setTextColor:[UIColor whiteColor]];
    [CTLable setBackgroundColor:[UIColor clearColor]];
    [CTImageView addSubview:CTLable];
    
    UIView * imageView = [[UIView alloc]init];
    [imageView setFrame:CGRectMake(40,
                                   CTLable.frame.size.height + CTLable.frame.origin.y,
                                   BOUNDS_WIDTH - 2 * 40,
                                   LARGE_HEIGHT - CTLable.frame.size.height -10)];
    [imageView setBackgroundColor:[UIColor whiteColor]];
    [CTImageView addSubview:imageView];
    
    //自定义CTView
//    ctView = [[CTView alloc]initWithFrame:CGRectMake(10, 9, imageView.frame.size.width - 20, 70)];
    ctView = [[CTView alloc]initWithFrame:CGRectMake(10, 9, imageView.frame.size.width - 20, 70) WithSuperController:self WithMedicalCase:medicalCase];
    [imageView addSubview:ctView];
    
    UIView * linView = [[UIView alloc]init];
    [linView setFrame:CGRectMake(0, CTImageView.frame.origin.y + CTImageView.frame.size.height - 1, BOUNDS_WIDTH, 1)];
    [linView setBackgroundColor:[UIColor whiteColor]];
    [CTImageView addSubview:linView];
}

- (void)initTimeView
{
    UILabel * timeLable = [[UILabel alloc]init];
    [timeLable setFrame:CGRectMake(5, 0, 200, 20)];
    [timeLable setText:@"下次预约时间:"];
    [timeLable setTextColor:[UIColor whiteColor]];
    [timeLable setBackgroundColor:[UIColor clearColor]];
    [appointTimeView addSubview:timeLable];
    
    UIView * imageView = [[UIView alloc]init];
    [imageView setFrame:CGRectMake(40,
                                   timeLable.frame.size.height + timeLable.frame.origin.y,
                                   BOUNDS_WIDTH - 2 * 40,
                                   SMALL_HEIGHT - timeLable.frame.size.height -10)];
    [imageView setBackgroundColor:[UIColor whiteColor]];
    [appointTimeView addSubview:imageView];
    
    float mag_x = 50;
    float mag_y = 20;
    float height = 18;
    float width = 20;
    year_filed = [[UITextField alloc]init];
    [year_filed setFrame:CGRectMake(mag_x, mag_y, 37 + 5, height)];
    [year_filed setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [year_filed setText:@"2014"];
    [imageView addSubview:year_filed];
    
    //下划线
    UIView * lineView1 = [[UIView alloc]init];
    [lineView1 setFrame:CGRectMake(year_filed.frame.origin.x,
                                   year_filed.frame.size.height + year_filed.frame.origin.y + 1,
                                   year_filed.frame.size.width, 1)];
    [lineView1 setBackgroundColor:[UIColor blackColor]];
    [imageView addSubview:lineView1];
    
    UILabel * title1_lable = [[UILabel alloc]init];
    [title1_lable setFrame:CGRectMake(year_filed.frame.size.width + year_filed.frame.origin.x,
                                      mag_y,
                                      width,
                                      height)];
    [title1_lable setText:@"年"];
    [title1_lable setBackgroundColor:[UIColor clearColor]];
    [title1_lable setTextColor:[UIColor blackColor]];
    [imageView addSubview:title1_lable];
    
    month_filed = [[UITextField alloc]init];
    [month_filed setFrame:CGRectMake(title1_lable.frame.size.width + title1_lable.frame.origin.x,
                                     mag_y,
                                     width,
                                     height)];
    [month_filed setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [month_filed setText:@"12"];
    [imageView addSubview:month_filed];
    
    //下划线
    UIView * lineView2 = [[UIView alloc]init];
    [lineView2 setFrame:CGRectMake(month_filed.frame.origin.x,
                                   month_filed.frame.size.height + month_filed.frame.origin.y + 1,
                                   month_filed.frame.size.width, 1)];
    [lineView2 setBackgroundColor:[UIColor blackColor]];
    [imageView addSubview:lineView2];
    
    UILabel * title2_lable = [[UILabel alloc]init];
    [title2_lable setFrame:CGRectMake(month_filed.frame.size.width + month_filed.frame.origin.x,
                                      mag_y,
                                      width,
                                      height)];
    [title2_lable setText:@"月"];
    [title2_lable setBackgroundColor:[UIColor clearColor]];
    [title2_lable setTextColor:[UIColor blackColor]];
    [imageView addSubview:title2_lable];
    
    day_filed = [[UITextField alloc]init];
    [day_filed setFrame:CGRectMake(title2_lable.frame.size.width + title2_lable.frame.origin.x,
                                     mag_y,
                                     width,
                                     height)];
    [day_filed setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [day_filed setText:@"12"];
    [imageView addSubview:day_filed];
    
    //下划线
    UIView * lineView3 = [[UIView alloc]init];
    [lineView3 setFrame:CGRectMake(day_filed.frame.origin.x,
                                   day_filed.frame.size.height + day_filed.frame.origin.y + 1,
                                   day_filed.frame.size.width, 1)];
    [lineView3 setBackgroundColor:[UIColor blackColor]];
    [imageView addSubview:lineView3];
    
    UILabel * title3_lable = [[UILabel alloc]init];
    [title3_lable setFrame:CGRectMake(day_filed.frame.size.width + day_filed.frame.origin.x,
                                      mag_y,
                                      width,
                                      height)];
    [title3_lable setText:@"日"];
    [title3_lable setBackgroundColor:[UIColor clearColor]];
    [title3_lable setTextColor:[UIColor blackColor]];
    [imageView addSubview:title3_lable];
    
    UIView * linView = [[UIView alloc]init];
    [linView setFrame:CGRectMake(0, appointTimeView.frame.size.height - 1, BOUNDS_WIDTH, 1)];
    [linView setBackgroundColor:[UIColor whiteColor]];
    [appointTimeView addSubview:linView];
}

- (void)initDescriptionView
{
    UILabel * descriptionLable = [[UILabel alloc]init];
    [descriptionLable setFrame:CGRectMake(5, 0, 200, 20)];
    [descriptionLable setText:@"病情描述:"];
    [descriptionLable setTextColor:[UIColor whiteColor]];
    [descriptionLable setBackgroundColor:[UIColor clearColor]];
    [descriptionView addSubview:descriptionLable];
    
    UIButton * voiceButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [voiceButton setFrame:CGRectMake(10, descriptionLable.frame.size.height + descriptionLable.frame.origin.y, 30, 20)];
    [voiceButton setTitle:@"语音" forState:UIControlStateNormal];
    [voiceButton addTarget:self action:@selector(getVoice:) forControlEvents:UIControlEventTouchUpInside];
    [descriptionView addSubview:voiceButton];
    
    description_field = [[UITextField alloc]init];
    [description_field setFrame:CGRectMake(40,
                                   descriptionLable.frame.size.height + descriptionLable.frame.origin.y,
                                   BOUNDS_WIDTH - 2 * 40,
                                   SMALL_HEIGHT - descriptionLable.frame.size.height -10)];
    [description_field setDelegate:self];
    [description_field setTag:1001];
    [description_field setBackgroundColor:[UIColor whiteColor]];
    [descriptionView addSubview:description_field];
    
    UIView * linView = [[UIView alloc]init];
    [linView setFrame:CGRectMake(0,descriptionView.frame.size.height - 1, BOUNDS_WIDTH, 1)];
    [linView setBackgroundColor:[UIColor whiteColor]];
    [descriptionView addSubview:linView];
}

- (void)initMaterialView
{
    UILabel * materialLable = [[UILabel alloc]init];
    [materialLable setFrame:CGRectMake(5, 0, 200, 20)];
    [materialLable setText:@"所用耗材:"];
    [materialLable setTextColor:[UIColor whiteColor]];
    [materialLable setBackgroundColor:[UIColor clearColor]];
    [materialView addSubview:materialLable];
    
    UIView * imageView = [[UIView alloc]init];
    [imageView setFrame:CGRectMake(40,
                                   materialLable.frame.size.height + materialLable.frame.origin.y,
                                   BOUNDS_WIDTH - 2 * 40,
                                   LARGE_HEIGHT - materialLable.frame.size.height -40)];
    [imageView setBackgroundColor:[UIColor whiteColor]];
    [materialView addSubview:imageView];
    
    float mag_y = 20;
    float height = 18;
    float width = 60;
    
    UILabel * title1_lable = [[UILabel alloc]init];
    [title1_lable setFrame:CGRectMake(0,mag_y,77,height)];
    [title1_lable setText:@"材料名称:"];
    [title1_lable setBackgroundColor:[UIColor clearColor]];
    [title1_lable setTextColor:[UIColor blackColor]];
    [imageView addSubview:title1_lable];
    
    materialName_filed = [[UITextField alloc]init];
    [materialName_filed setFrame:CGRectMake(title1_lable.frame.size.width + title1_lable.frame.origin.x,
                                     mag_y ,
                                     width,
                                     height)];
    [materialName_filed setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [materialName_filed setDelegate:self];
    [materialName_filed setTag:1002];
    [materialName_filed setText:@"什么什么这么暗"];
    [imageView addSubview:materialName_filed];
    
    UIView * lineView1 = [[UIView alloc]init];
    [lineView1 setFrame:CGRectMake(materialName_filed.frame.origin.x,
                                   materialName_filed.frame.size.height + materialName_filed.frame.origin.y + 1,
                                   materialName_filed.frame.size.width, 1)];
    [lineView1 setBackgroundColor:[UIColor blackColor]];
    [imageView addSubview:lineView1];
    
    UILabel * title2_lable = [[UILabel alloc]init];
    [title2_lable setFrame:CGRectMake(materialName_filed.frame.size.width + materialName_filed.frame.origin.x,
                                      mag_y,
                                      77,
                                      height)];
    [title2_lable setText:@"使用数量:"];
    [title2_lable setBackgroundColor:[UIColor clearColor]];
    [title2_lable setTextColor:[UIColor blackColor]];
    [imageView addSubview:title2_lable];
    
    materialNumb_filed = [[UITextField alloc]init];
    [materialNumb_filed setFrame:CGRectMake(title2_lable.frame.size.width + title2_lable.frame.origin.x,
                                            mag_y,
                                            20,
                                            height)];
    [materialNumb_filed setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [materialNumb_filed setDelegate:self];
    [materialNumb_filed setTag:1003];
    [materialNumb_filed setText:@"20"];
    [imageView addSubview:materialNumb_filed];
    
    UIView * lineView2 = [[UIView alloc]init];
    [lineView2 setFrame:CGRectMake(materialNumb_filed.frame.origin.x,
                                   materialNumb_filed.frame.size.height + materialNumb_filed.frame.origin.y + 1,
                                   materialNumb_filed.frame.size.width, 1)];
    [lineView2 setBackgroundColor:[UIColor blackColor]];
    [imageView addSubview:lineView2];
}

#pragma mark - keyboard delegate
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [year_filed resignFirstResponder];
    [month_filed resignFirstResponder];
    [day_filed resignFirstResponder];
    [materialName_filed resignFirstResponder];
    [materialNumb_filed resignFirstResponder];
    [description_field resignFirstResponder];
}

//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 1001)
    {
        [self moveViewUp:65];
    }
    if (textField.tag == 1002 || textField.tag == 1003)
    {
        [self moveViewUp:160];
    }
}

//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 1001)
    {
        [self moveViewDown:65];
    }
    if (textField.tag == 1002 || textField.tag == 1003)
    {
        [self moveViewDown:160];
    }
}

-(void)moveViewUp:(float)move{
    NSTimeInterval animationDuration = 0.30f;
    CGRect frame = self.view.frame;
    frame.origin.y -=move;//view的X轴上移
    self.view.frame = frame;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];//设置调整界面的动画效果
}

-(void)moveViewDown:(float)move{
    NSTimeInterval animationDuration = 0.30f;
    CGRect frame = self.view.frame;
    frame.origin.y +=move;//view的X轴上移
    self.view.frame = frame;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];//设置调整界面的动画效果
}

- (void)getVoice:(UIButton *)sender
{
    NSLog(@"语音");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
