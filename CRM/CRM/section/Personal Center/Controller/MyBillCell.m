//
//  MyBillCell.m
//  CRM
//
//  Created by Argo Zhang on 15/11/13.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "MyBillCell.h"
#import "BillModel.h"
#import "BillDetailViewController.h"
#import "UIView+WXViewController.h"
#import "NSString+MyString.h"

#define NameFontSize [UIFont systemFontOfSize:16]
#define OtherFontSize [UIFont systemFontOfSize:14]
#define MarginX 10
#define MarginY 13

@interface MyBillCell ()<UIAlertViewDelegate,BillDetailViewControllerDelegate>{
    UILabel *_clinicNameLabel; //诊所名称
    UIImageView *_clinicNextImageView;//图片名称
    
    UILabel *_costTimeLabel; //耗时视图
    UILabel *_timeLabel;  //时间视图
    UILabel *_userNameLabel; //名称视图
    UILabel *_typeLabel;  //类型视图
    UILabel *_actionLabel; //操作视图
    UILabel *_moneyLabel; //价格视图
    UIButton *_payButton; //付款按钮
    
    UIView *_dividerView;//分割线
}

@property (nonatomic, strong)NSTimer *timer;

@end

@implementation MyBillCell

- (void)dealloc{
    [self.timer invalidate];
    self.timer = nil;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"bill_cell";
    MyBillCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //初始化子视图
        [self initSubViews];
    }
    return self;
}

#pragma mark -初始化方法
- (void)initSubViews{
    //分割线
    _dividerView = [[UIView alloc] init];
    _dividerView.backgroundColor = MyColor(239, 239, 239);
    [self.contentView addSubview:_dividerView];
    
    //诊所名称
    _clinicNameLabel = [[UILabel alloc] init];
    _clinicNameLabel.textColor = [UIColor blackColor];
    _clinicNameLabel.font = NameFontSize;
    [self.contentView addSubview:_clinicNameLabel];
    //图片名称
    _clinicNextImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dfk_yjt"]];
    [self.contentView addSubview:_clinicNextImageView];
    
    //耗时视图
    _costTimeLabel = [[UILabel alloc] init];
    _costTimeLabel.textColor = MyColor(117, 117, 117);
    _costTimeLabel.font = OtherFontSize;
    [self.contentView addSubview:_costTimeLabel];
    
    
    //时间视图
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = MyColor(117, 117, 117);
    _timeLabel.font = OtherFontSize;
    [self.contentView addSubview:_timeLabel];

    //名称视图
    _userNameLabel = [[UILabel alloc] init];
    _userNameLabel.textColor = MyColor(117, 117, 117);
    _userNameLabel.font = OtherFontSize;
    [self.contentView addSubview:_userNameLabel];
    
    //类型视图
    _typeLabel = [[UILabel alloc] init];
    _typeLabel.textColor = MyColor(117, 117, 117);
    _typeLabel.font = OtherFontSize;
    [self.contentView addSubview:_typeLabel];
    
    //操作视图
    _actionLabel = [[UILabel alloc] init];
    _actionLabel.textColor = MyColor(117, 117, 117);
    _actionLabel.font = OtherFontSize;
    [self.contentView addSubview:_actionLabel];
    
    //价格视图
    _moneyLabel = [[UILabel alloc] init];
    _moneyLabel.textColor = [UIColor redColor];
    _moneyLabel.font = NameFontSize;
    [self.contentView addSubview:_moneyLabel];
    
    //付款按钮
    _payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_payButton setBackgroundImage:[UIImage imageNamed:@"dfk_qfk"] forState:UIControlStateNormal];
    [_payButton setTitleColor:MyColor(38, 156, 230) forState:UIControlStateNormal];
    _payButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [_payButton addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_payButton];
}


#pragma mark -设置子视图的frame
- (void)setModel:(BillModel *)model{
    _model = model;
    //分割线
    _dividerView.frame = CGRectMake(0, 0, kScreenWidth, 5);
    
    //诊所名称
    NSString *clinicName = self.model.clinic_name;
    CGSize clinicNameSize = [clinicName sizeWithFont:NameFontSize];
    _clinicNameLabel.frame = CGRectMake(MarginX, MarginY + 5, clinicNameSize.width, clinicNameSize.height);
    _clinicNameLabel.text = clinicName;
    CGFloat commenH = clinicNameSize.height + MarginY * 2;
    
    //图片按钮
    _clinicNextImageView.frame = CGRectMake(CGRectGetMaxX(_clinicNameLabel.frame) + MarginY, (commenH - clinicNameSize.height) * 0.5 + 5, 10, clinicNameSize.height);
    
    //耗时视图
    NSString *costTime = [NSString stringWithFormat:@"共用时:%@",[self minChangeToHour:self.model.use_time]];
    CGSize costTimeSize = [costTime sizeWithFont:OtherFontSize];
    _costTimeLabel.frame = CGRectMake(kScreenWidth - costTimeSize.width - MarginX, (commenH - costTimeSize.height) * 0.5 + 5, costTimeSize.width, costTimeSize.height);
    //设置字体颜色
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:costTime];
    int length = (int)costTime.length - 3;
    [str addAttribute:NSForegroundColorAttributeName value:MyColor(0, 139, 232) range:NSMakeRange(3,length)];
    _costTimeLabel.attributedText = str;
    
    
    NSString *time = self.model.bill_time;
    CGSize timeSize = [time sizeWithFont:OtherFontSize];
    NSString *name = self.model.patient_name;
    CGSize nameSize = [name sizeWithFont:OtherFontSize];
//    NSString *type = self.model.seat_name;
//    CGSize typeSize = [type sizeWithFont:OtherFontSize];
    NSString *action = self.model.type;
    CGSize actionSize = [action sizeWithFont:OtherFontSize];
    
    CGFloat middleMargin = (kScreenWidth - timeSize.width - nameSize.width - actionSize.width - MarginX * 2) / 2;
    
    //时间视图
    CGFloat timeY = commenH + (commenH - timeSize.height) * 0.5 + 5;
    _timeLabel.frame = CGRectMake(MarginX, timeY, timeSize.width, timeSize.height);
    _timeLabel.text = time;
    
    //名称视图
    CGFloat userNameX = CGRectGetMaxX(_timeLabel.frame) + middleMargin;
    CGFloat userNameY = timeY;
    CGFloat userNameW = nameSize.width;
    CGFloat userNameH = nameSize.height;
    _userNameLabel.frame = CGRectMake(userNameX, userNameY, userNameW, userNameH);
    _userNameLabel.text = name;
    
    //类型视图
//    CGFloat typeX = CGRectGetMaxX(_userNameLabel.frame) + middleMargin;
//    CGFloat typeY = timeY;
//    CGFloat typeW = typeSize.width;
//    CGFloat typeH = typeSize.height;
//    _typeLabel.frame = CGRectMake(typeX, typeY, typeW, typeH);
//    _typeLabel.text = type;
    
    //类型视图
    CGFloat actionX = CGRectGetMaxX(_userNameLabel.frame) + middleMargin;
    CGFloat actionY = timeY;
    CGFloat actionW = actionSize.width;
    CGFloat actionH = actionSize.height;
    _actionLabel.frame = CGRectMake(actionX, actionY, actionW, actionH);
    _actionLabel.text = action;
    
    CGSize moneySize = [@"已用时" sizeWithFont:NameFontSize];
    CGFloat moneyX = MarginX;
    CGFloat moneyY = commenH * 2 + (commenH - moneySize.height) / 2 + 5;
    CGFloat moneyW = 200;
    CGFloat moneyH = moneySize.height;
    _moneyLabel.frame = CGRectMake(moneyX, moneyY, moneyW, moneyH);
    
    //付款按钮
    CGFloat payW = 100;
    CGFloat payH = commenH - MarginY;
    CGFloat payX = kScreenWidth - payW - MarginX;
    CGFloat payY = commenH * 2 + (commenH - payH) * 0.5 + 5;
    _payButton.frame = CGRectMake(payX, payY, payW, payH);
    
    //价格视图
    NSString *money;
        _payButton.hidden = YES;
        if ([self.model.reserve_status isEqualToString:@"0"]) {//等待计时
            money = @"等待计时";
            _payButton.hidden = NO;
            [_payButton setTitle:@"取消预约" forState:UIControlStateNormal];
            _moneyLabel.text = money;
            
            [self.timer invalidate];
            self.timer = nil;
        }else if([self.model.reserve_status isEqualToString:@"1"]){//手术中
            
            _moneyLabel.text = [NSString stringWithFormat:@"已用时 %@", [self.model.start_time timeToNow]];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
            NSRunLoop *currentRunLoop = [NSRunLoop currentRunLoop];
            [currentRunLoop addTimer:self.timer forMode:NSRunLoopCommonModes];
            //开启一个定时器
            _payButton.hidden = YES;
        }else if ([self.model.reserve_status isEqualToString:@"2"]){//手术结束
            money = @"手术结束";
            _payButton.hidden = YES;
            _moneyLabel.text = money;
            
            [self.timer invalidate];
            self.timer = nil;
        }else{ //3   待付款
            _payButton.hidden = NO;
            [_payButton setTitle:@"去付款" forState:UIControlStateNormal];
            money = [NSString stringWithFormat:@"待付款：￥%@",self.model.total_money];
            _moneyLabel.text = money;
            
            [self.timer invalidate];
            self.timer = nil;
        }
    
}

- (void)calculateFrameWithContent:(NSString *)content commenH:(CGFloat)commenH{
    CGSize moneySize = [content sizeWithFont:NameFontSize];
    CGFloat moneyX = MarginX;
    CGFloat moneyY = commenH * 2 + (commenH - moneySize.height) / 2 + 5;
    CGFloat moneyW = moneySize.width;
    CGFloat moneyH = moneySize.height;
    _moneyLabel.frame = CGRectMake(moneyX, moneyY, moneyW, moneyH);
    _moneyLabel.text = content;
}

#pragma mark -按钮点击事件
- (void)buttonAction{
    if ([self.model.reserve_status isEqualToString:@"0"]) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"取消订单" message:@"确定取消预约订单？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        
    }else{
        //创建跳转页面
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
        BillDetailViewController *detailVc = [storyboard instantiateViewControllerWithIdentifier:@"BillDetailViewController"];
        detailVc.hidesBottomBarWhenPushed = YES;
        detailVc.billId = self.model.KeyId;
        detailVc.delegate = self;
        detailVc.type = @"1";
        [self.viewController.navigationController pushViewController:detailVc animated:YES];
    }
}

#pragma mark -UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        if ([self.delegate respondsToSelector:@selector(didClickAppointCancleButtonWithBillModel:)]) {
            [self.delegate didClickAppointCancleButtonWithBillModel:self.model];
        }
    }
}

#pragma mark -BillDetailViewControllerDelegate
- (void)didPaySuccess:(NSString *)result{
    if ([self.delegate respondsToSelector:@selector(didPaySuccessWithResult:)]) {
        [self.delegate didPaySuccessWithResult:result];
    }
}

#pragma mark -定时器
- (void)timerAction{
    _moneyLabel.text = [NSString stringWithFormat:@"已用时 %@", [self.model.start_time timeToNow]];
}

//将分钟转换为小时
- (NSString *)minChangeToHour:(NSString *)str{
    int min = [str intValue];
    NSString *hourStr;
    NSString *minStr;
    NSString *result;
    if (min > 60) {
        hourStr = [NSString stringWithFormat:@"%d",min / 60];
        minStr = [NSString stringWithFormat:@"%d",min % 60];
        result = [NSString stringWithFormat:@"%@小时%@分",hourStr,minStr];
    }else{
        minStr = [NSString stringWithFormat:@"%d",min];
        result = [NSString stringWithFormat:@"%@分钟",minStr];
    }
    return result;
}



@end
