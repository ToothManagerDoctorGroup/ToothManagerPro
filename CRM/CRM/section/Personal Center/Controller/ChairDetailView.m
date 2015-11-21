//
//  ChairDetailView.m
//  CRM
//
//  Created by Argo Zhang on 15/11/11.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "ChairDetailView.h"
#import "SeatModel.h"
#import "UIImageView+WebCache.h"
#import "SeatImgInfosModel.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

@interface ChairDetailView ()
@property (weak, nonatomic) IBOutlet UILabel *brandLabel; //品牌
@property (weak, nonatomic) IBOutlet UILabel *descLabel; //说明
@property (weak, nonatomic) IBOutlet UILabel *waterTypeLabel; //用水
@property (weak, nonatomic) IBOutlet UILabel *ultraSoundLabel; //超声功率
@property (weak, nonatomic) IBOutlet UILabel *lightLabel;       //光固灯
@property (weak, nonatomic) IBOutlet UILabel *assistantPriceLabel; //助理价格
@property (weak, nonatomic) IBOutlet UILabel *seatPriceLabel;   //椅位价格
@property (weak, nonatomic) IBOutlet UIScrollView *seatImageScrollView; //椅位图片滑动视图


@property (nonatomic, strong)NSArray *seatImages;

@end

@implementation ChairDetailView

- (NSArray *)seatImages{
    if (!_seatImages) {
        _seatImages = [NSArray array];
    }
    return _seatImages;
}
#pragma mark -设置数据
- (void)setModel:(SeatModel *)model{
    _model = model;
    
    //给图片数组赋值
    _seatImages = model.SeatImgInfos;
    
    //设置数据
    self.brandLabel.text = model.seat_brand;
    self.descLabel.text = model.seat_desc;
    
    //用水判断
    if ([model.seat_tapwater isEqualToString:@"1"] && [model.seat_distillwater isEqualToString:@"1"]) {
        self.waterTypeLabel.text = [NSString stringWithFormat:@"自来水/蒸馏水可切换"];
    }else if ([model.seat_tapwater isEqualToString:@"0"]){
        self.waterTypeLabel.text = @"蒸馏水";
    }else if ([model.seat_distillwater isEqualToString:@"0"]){
        self.waterTypeLabel.text = @"自来水";
    }
    
    //超声功率
    if ([model.seat_ultrasound isEqualToString:@"0"]) {
        self.ultraSoundLabel.text = @"可洗牙";
    }else{
        self.ultraSoundLabel.text = @"可切割牙体组织";
    }
    //光固灯
    if ([model.seat_light isEqualToString:@"0"]) {
        self.lightLabel.text = @"牙椅自带";
    }else{
        self.lightLabel.text = @"可移动灯";
    }
    
    //收费标准
    self.assistantPriceLabel.text = [NSString stringWithFormat:@"助理:%@元/小时",model.assistant_price];
    self.seatPriceLabel.text = [NSString stringWithFormat:@"椅位:%@元/小时",model.seat_price];
    
    //椅位图片
    if (model.SeatImgInfos.count > 0) {
        //设置偏移量
        self.seatImageScrollView.contentSize = CGSizeMake(_seatImages.count * kScreenWidth, self.seatImageScrollView.frame.size.height);
        for (int i = 0; i < _seatImages.count; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * kScreenWidth, 0, kScreenWidth, self.seatImageScrollView.frame.size.height)];
            imageView.userInteractionEnabled = YES;
            imageView.tag = i;
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            
            //为图片添加点击事件
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
            [imageView addGestureRecognizer:tap];
            
            SeatImgInfosModel *imageModel = _seatImages[i];
            NSURL *imageUrl = [NSURL URLWithString:imageModel.img_info];
            [imageView sd_setImageWithURL:imageUrl];
            
            [self.seatImageScrollView addSubview:imageView];
        }
    }
}

#pragma mark -图片点击事件
- (void)tapAction:(UITapGestureRecognizer *)tap{
    //获取当前点击的视图
    UIImageView *imageView = (UIImageView *)tap.view;
    //遍历当前图片数组，将LBPhoto模型转换成MJPhoto模型
    NSMutableArray *mJPhotos = [NSMutableArray array];
    int i = 0;
    for (SeatImgInfosModel *photo in _seatImages) {
        //将图片url转换成高清的图片url
        MJPhoto *mjPhoto = [[MJPhoto alloc] init];
        mjPhoto.url = [NSURL URLWithString:photo.img_info];
        mjPhoto.srcImageView = imageView;
        mjPhoto.index = i;
        [mJPhotos addObject:mjPhoto];
        i++;
    }
    
    //创建图片显示控制器对象
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.photos = mJPhotos;
    browser.currentPhotoIndex = imageView.tag;
    //显示
    [browser show];
}


+ (instancetype)instanceView{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ChairDetailView" owner:nil options:nil];
    return [array lastObject];
}




@end
