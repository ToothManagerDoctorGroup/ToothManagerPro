//
//  XLMedicalImageView.m
//  CRM
//
//  Created by Argo Zhang on 16/3/1.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLMedicalImageView.h"
#import "UIColor+Extension.h"
#import "DBManager+Patients.h"
#import "UIImageView+WebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

#define CommonTextColor [UIColor colorWithHex:0xffffff]
#define CommonTextFont [UIFont systemFontOfSize:12]

@interface XLMedicalImageView ()<UIScrollViewDelegate>

@property (nonatomic, weak)UIScrollView *imageScrollView;//图片视图

@property (nonatomic, weak)UIView *flowView;//浮层视图
@property (nonatomic, weak)UILabel *reserveTypeLabel;//事项
@property (nonatomic, weak)UILabel *doctorNameLabel;//医生姓名
@property (nonatomic, weak)UILabel *timeLabel;//时间

@property (nonatomic, weak)UIButton *preButton;//上一张
@property (nonatomic, weak)UIButton *nextButton;//下一站

@property (nonatomic, strong)NSArray *cTLibs;

@property (nonatomic, assign)NSInteger index;

@end

@implementation XLMedicalImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化
        [self setUp];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setUp];
    }
    return self;
}
#pragma mark -初始化
- (void)setUp{
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    //图片视图
    UIScrollView *imageScrollView = [[UIScrollView alloc] init];
    imageScrollView.showsHorizontalScrollIndicator = NO;
    imageScrollView.pagingEnabled = YES;
    imageScrollView.bounces = NO;
    imageScrollView.delegate = self;
    self.imageScrollView = imageScrollView;
    [self addSubview:imageScrollView];
    
    //浮层视图
    UIView *flowView = [[UIView alloc] init];
    flowView.backgroundColor = [UIColor blackColor];
    flowView.alpha = .7;
    self.flowView = flowView;
    [self addSubview:flowView];
    
    //事项
    UILabel *reserveTypeLabel = [[UILabel alloc] init];
    reserveTypeLabel.textColor = CommonTextColor;
    reserveTypeLabel.font = CommonTextFont;
    self.reserveTypeLabel = reserveTypeLabel;
    [flowView addSubview:reserveTypeLabel];
    
    //医生姓名
    UILabel *doctorNameLabel = [[UILabel alloc] init];
    doctorNameLabel.textColor = CommonTextColor;
    doctorNameLabel.font = CommonTextFont;
    self.doctorNameLabel = doctorNameLabel;
    [flowView addSubview:doctorNameLabel];
    
    //时间
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.textColor = CommonTextColor;
    timeLabel.font = CommonTextFont;
    self.timeLabel = timeLabel;
    [flowView addSubview:timeLabel];
    
    UIButton *preButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [preButton setImage:[UIImage imageNamed:@"team_left"] forState:UIControlStateNormal];
    preButton.hidden = YES;
    self.preButton = preButton;
    [preButton addTarget:self action:@selector(preButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:preButton];
 
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setImage:[UIImage imageNamed:@"team_right"] forState:UIControlStateNormal];
    nextButton.hidden = YES;
    self.nextButton = nextButton;
    [nextButton addTarget:self action:@selector(nextButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:nextButton];
}

- (void)setMedicalCase:(MedicalCase *)medicalCase{
    _medicalCase = medicalCase;
    
    self.imageScrollView.frame = CGRectMake(0, 0, self.width, self.height);
    
    CGFloat flowW = self.width;
    CGFloat flowH = 30;
    CGFloat flowX = 0;
    CGFloat flowY = self.height - 30;
    self.flowView.frame = CGRectMake(flowX, flowY, flowW, flowH);
    
    NSString *type = @"种植";
    NSString *name = @"陈云";
    NSString *time = @"2015-08-09 12:00";
    
    CGSize typeSize = [type sizeWithFont:CommonTextFont];
    CGSize nameSize = [name sizeWithFont:CommonTextFont];
    CGSize timeSize = [time sizeWithFont:CommonTextFont];
    
    CGFloat margin = 10;
    CGFloat marginMid = (self.width - 20 - typeSize.width - nameSize.width - timeSize.width) / 2;
    
    self.reserveTypeLabel.frame = CGRectMake(margin, 0, typeSize.width, flowH);
    self.reserveTypeLabel.text = type;
    self.doctorNameLabel.frame = CGRectMake(self.reserveTypeLabel.right + marginMid, 0, nameSize.width, flowH);
    self.doctorNameLabel.text = name;
    self.timeLabel.frame = CGRectMake(flowW - timeSize.width - margin, 0, timeSize.width, flowH);
    self.timeLabel.text = time;
    
    CGFloat preW = 25;
    CGFloat preH = 25;
    CGFloat preX = margin;
    CGFloat preY = (self.height - preH) / 2;
    self.preButton.frame = CGRectMake(preX, preY, preW, preH);
    
    CGFloat nextW = preW;
    CGFloat nextH = preH;
    CGFloat nextX = self.width - nextW - margin;
    CGFloat nextY = preY;
    self.nextButton.frame = CGRectMake(nextX, nextY, nextW, nextH);

    //获取所有的ct图片信息
    NSMutableArray *cTLibs = [NSMutableArray array];
    NSArray *libArray = [[DBManager shareInstance] getCTLibArrayWithCaseId:self.medicalCase.ckeyid isAsc:YES];
    if (libArray != nil && libArray.count > 0) {
        [cTLibs addObjectsFromArray:libArray];
    } else {
        CTLib *libtmp = [[CTLib alloc]init];
        libtmp.ckeyid = @"-100";
        libtmp.ct_image = @"ctlib_placeholder.png";
        libtmp.creation_date = self.medicalCase.creation_date;
        libtmp.ct_desc = self.medicalCase.creation_date;
        [cTLibs addObject:libtmp];
    }
    //设置滑动图片视图的frame
    if (cTLibs.count > 0) {
        
        self.cTLibs = cTLibs;
        CGFloat imageViewW = self.imageScrollView.width;
        CGFloat imageViewH = self.imageScrollView.height;
        //计算偏移量
        self.imageScrollView.contentSize = CGSizeMake(cTLibs.count * imageViewW, self.imageScrollView.height);
        
        //首先移除所有的imageView
        for (UIView *view in self.imageScrollView.subviews) {
            if ([view isKindOfClass:[UIImageView class]]) {
                [view removeFromSuperview];
            }
        }
        for (int i = 0; i < cTLibs.count; i++) {
            CTLib *ct = cTLibs[i];
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.tag = i;
            imageView.userInteractionEnabled = YES;
            imageView.frame = CGRectMake(i * imageViewW, 0, imageViewW, imageViewH);
            //显示图片
            if ([ct.ckeyid isEqualToString:@"-100"]) {
                imageView.image = [UIImage imageNamed:ct.ct_image];
            }else{
                //如果有ct图片，则添加单击事件
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
                tap.numberOfTapsRequired = 1;
                tap.numberOfTouchesRequired = 1;
                [imageView addGestureRecognizer:tap];
                
                [imageView sd_setImageWithURL:[NSURL URLWithString:ct.ct_image] placeholderImage:[UIImage imageNamed:ct.ct_image]];
            }
            [self.imageScrollView addSubview:imageView];
        }
    }
    
    //判断当前是否有2张以上的图片
    if (cTLibs.count <= 1) {
        self.preButton.hidden = YES;
        self.nextButton.hidden = YES;
    }else{
        self.nextButton.hidden = NO;
    }
}

#pragma mark - 上一个和下一个按钮的点击事件
- (void)preButtonAction{
    self.index--;
    //移动scrollView
    self.imageScrollView.contentOffset = CGPointMake(self.imageScrollView.width * self.index , 0);
}

- (void)nextButtonAction{
    self.index++;
    //移动scrollView
    self.imageScrollView.contentOffset = CGPointMake(self.imageScrollView.width * self.index, 0);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //计算当前的偏移量
    NSInteger offset = scrollView.contentOffset.x;

    NSInteger page = (offset + scrollView.width * 0.5) / scrollView.width;
    self.index = page;
    if (self.index == 0) {
        self.preButton.hidden = YES;
    }else if (self.index == self.cTLibs.count - 1){
        self.nextButton.hidden = YES;
    }else{
        self.preButton.hidden = NO;
        self.nextButton.hidden = NO;
    }
}

#pragma mark -单击事件
- (void)tapAction:(UITapGestureRecognizer *)tap{
    //获取当前点击的视图
    UIImageView *imageView = (UIImageView *)tap.view;
    //遍历当前图片数组，将LBPhoto模型转换成MJPhoto模型
    NSMutableArray *mJPhotos = [NSMutableArray array];
    int i = 0;
    for (CTLib *photo in self.cTLibs) {
        //将图片url转换成高清的图片url
        MJPhoto *mjPhoto = [[MJPhoto alloc] init];
        mjPhoto.url = [NSURL URLWithString:photo.ct_image];
        mjPhoto.srcImageView = imageView;
        mjPhoto.index = i;
        [mJPhotos addObject:mjPhoto];
        i++;
    }
    
    //创建图片显示控制器对象
    //    if (!_browser) {
    //        _browser = [[MJPhotoBrowser alloc] init];
    //    }
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.photos = mJPhotos;
    browser.currentPhotoIndex = imageView.tag;
    //显示
    [browser show];
}

@end
