//
//  XLClinicSeatCell.m
//  CRM
//
//  Created by Argo Zhang on 16/5/24.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLClinicSeatCell.h"
#import "XLClinicSeatDetailView.h"
#import "XLImageScrollView.h"
#import "XLSegmentView.h"
#import "ClinicDetailModel.h"
#import "SeatModel.h"
#import "SeatImgInfosModel.h"
#import "UIColor+Extension.h"
#import <Masonry.h>

@interface XLClinicSeatCell ()

@property (nonatomic, strong)XLSegmentView *buttonScrollView;
@property (nonatomic, strong)XLClinicSeatDetailView *seatDetailView;
@property (nonatomic, strong)XLImageScrollView *imageScrollView;

@end

@implementation XLClinicSeatCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"seat_cell";
    XLClinicSeatCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //初始化
        [self setUp];
    }
    return self;
}
#pragma mark 初始化
- (void)setUp{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.buttonScrollView];
    [self.contentView addSubview:self.seatDetailView];
    [self.contentView addSubview:self.imageScrollView];
    
    [self setUpFrame];
}
#pragma mark 计算frame
- (void)setUpFrame{

    [self.seatDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.buttonScrollView.mas_bottom);
        make.left.and.right.equalTo(self.contentView);
        make.height.mas_equalTo(200);
    }];
    
    [self.imageScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.seatDetailView.mas_bottom);
        make.left.equalTo(self.contentView).with.offset(10);
        make.right.equalTo(self.contentView).with.offset(-10);
        make.height.mas_equalTo(150);
    }];
}

- (void)setModel:(ClinicDetailModel *)model{
    _model = model;
    
    //设置椅位按钮
    [self setUpSeatButtons];
    //设置椅位详情
    [self setUpSeatDetailWithIndex:0];
    //设置椅位图片
    [self setUpSeatImagesWithIndex:0];
}

#pragma mark 设置按钮图片
- (void)setUpSeatButtons{
    NSArray *seats = self.model.Seats;
    NSMutableArray *seatNames = [NSMutableArray array];
    for (SeatModel *model in seats) {
        [seatNames addObject:model.seat_name];
    }
    __weak typeof(self) weakSelf = self;
    self.buttonScrollView.titleArray = seatNames;
    self.buttonScrollView.block = ^(NSInteger index) {
        //刷新数据
        [weakSelf setUpSeatDetailWithIndex:index - 1];
        [weakSelf setUpSeatImagesWithIndex:index - 1];
    };
}
#pragma mark 设置椅位详情
- (void)setUpSeatDetailWithIndex:(NSInteger)index{
    //将数据都设置为空
    SeatModel *model = self.model.Seats[index];
    //设置数据
    self.seatDetailView.brandLabel.text = model.seat_brand;
    self.seatDetailView.modelTypeLabel.text = model.seat_desc;
    
    //用水判断
    if ([model.seat_tapwater isEqualToString:@"1"] && [model.seat_distillwater isEqualToString:@"1"]) {
        self.seatDetailView.waterLabel.text = [NSString stringWithFormat:@"自来水/蒸馏水可切换"];
    }else if ([model.seat_tapwater isEqualToString:@"0"]){
        self.seatDetailView.waterLabel.text = @"蒸馏水";
    }else if ([model.seat_distillwater isEqualToString:@"0"]){
        self.seatDetailView.waterLabel.text = @"自来水";
    }
    
    //超声功率
    if ([model.seat_ultrasound isEqualToString:@"0"]) {
        self.seatDetailView.powerLabel.text = @"可洗牙";
    }else{
        self.seatDetailView.powerLabel.text = @"可切割牙体组织";
    }
    //光固灯
    if ([model.seat_light isEqualToString:@"0"]) {
        self.seatDetailView.lightLabel.text = @"牙椅自带";
    }else{
        self.seatDetailView.lightLabel.text = @"可移动灯";
    }
    
    //收费标准
    self.seatDetailView.assistPriceLabel.text = [NSString stringWithFormat:@"助理:%@元/小时",model.assistant_price];
    self.seatDetailView.seatPriceLabel.text = [NSString stringWithFormat:@"椅位:%@元/小时",model.seat_price];
}

#pragma mark 设置椅位图片
- (void)setUpSeatImagesWithIndex:(NSInteger)index{
    SeatModel *model = self.model.Seats[index];
    NSArray *seatImages = model.SeatImgInfos;
    
    if (seatImages.count == 0) {
        self.imageScrollView.hidden = YES;
        return;
    }
    self.imageScrollView.hidden = NO;
    NSMutableArray *mArray = [NSMutableArray array];
    for (SeatImgInfosModel *infoModel in seatImages) {
        XLImageScrollViewModel *model = [[XLImageScrollViewModel alloc] init];
        model.imageUrl = infoModel.img_info;
        [mArray addObject:model];
    }
    self.imageScrollView.imageModelsArray = mArray;
}


#pragma mark - ********************* Lazy Method ***********************
- (XLSegmentView *)buttonScrollView{
    if (!_buttonScrollView) {
        _buttonScrollView = [[XLSegmentView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        _buttonScrollView.titleSelectColor = [UIColor colorWithHex:0x00a0ea];
    }
    return _buttonScrollView;
}

- (XLClinicSeatDetailView *)seatDetailView{
    if (!_seatDetailView) {
        _seatDetailView = [[[NSBundle mainBundle] loadNibNamed:@"XLClinicSeatDetailView" owner:self options:nil] lastObject];
    }
    return _seatDetailView;
}

- (XLImageScrollView *)imageScrollView{
    if (!_imageScrollView) {
        _imageScrollView = [[XLImageScrollView alloc] init];
    }
    return _imageScrollView;
}


@end
