//
//  MedicalDetailView.m
//  CRM
//
//  Created by Argo Zhang on 15/11/20.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "MedicalDetailView.h"
#import "TTMMedicalCaseModel.h"
#import "TTMCTLibModel.h"

#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

#define Margin 5
#define CommenTitleColor RGBColor(69, 69, 70)
#define CommenTitleFont [UIFont systemFontOfSize:14]

#define ImageDown [NSString stringWithFormat:@"%@his.crm/UploadFiles/",DomainName]

@interface MedicalDetailView ()<UIAlertViewDelegate>

@property (nonatomic, weak)UIScrollView *imageScrollView;//图片视图
@property (nonatomic, strong)NSArray *cTLibs;

@end

@implementation MedicalDetailView
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
    //图片视图
    UIScrollView *imageScrollView = [[UIScrollView alloc] init];
    imageScrollView.showsHorizontalScrollIndicator = NO;
    imageScrollView.pagingEnabled = YES;
    imageScrollView.bounces = NO;
    self.imageScrollView = imageScrollView;
    [self addSubview:imageScrollView];
    
}

#pragma mark -创建文本视图
- (UILabel *)createLabel{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = CommenTitleColor;
    label.font = CommenTitleFont;
    return label;
}

- (void)setMedicalCase:(TTMMedicalCaseModel *)medicalCase{
    
    _medicalCase = medicalCase;
    
    //计算imageScrollView的frame
    self.imageScrollView.frame = CGRectMake(Margin, Margin, self.width - Margin * 2, 150);
    
    //获取所有的ct图片信息
    NSMutableArray *cTLibs = [NSMutableArray array];
    NSArray *libArray = self.medicalCase.ctLibs;
    if (libArray != nil && libArray.count > 0) {
        [cTLibs addObjectsFromArray:libArray];
    } else {
        TTMCTLibModel *libtmp = [[TTMCTLibModel alloc]init];
        libtmp.ckeyid = @"-100";
        libtmp.ct_image = @"ctlib_placeholder.png";
        libtmp.creation_time = self.medicalCase.creation_time;
        [cTLibs addObject:libtmp];
    }
    //设置滑动图片视图的frame
    if (cTLibs.count > 0) {
        
        self.cTLibs = cTLibs;
        
        self.imageScrollView.hidden = NO;
        CGFloat imageViewW = self.imageScrollView.width;
        CGFloat imageViewH = self.imageScrollView.height;
        //计算偏移量
        self.imageScrollView.contentSize = CGSizeMake(cTLibs.count * imageViewW, self.imageScrollView.height);
        
        for (int i = 0; i < cTLibs.count; i++) {
            TTMCTLibModel *ct = cTLibs[i];
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.tag = i;
            imageView.userInteractionEnabled = YES;
            imageView.layer.cornerRadius = 8;
            imageView.layer.masksToBounds = YES;
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
                
                NSURL *imgUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@_%@",ImageDown,ct.ckeyid,ct.ct_image]];
                [imageView sd_setImageWithURL:imgUrl];
            }
            [self.imageScrollView addSubview:imageView];
        }
    }
}
#pragma mark -单击事件
- (void)tapAction:(UITapGestureRecognizer *)tap{
    //获取当前点击的视图
    UIImageView *imageView = (UIImageView *)tap.view;
    //遍历当前图片数组，将LBPhoto模型转换成MJPhoto模型
    NSMutableArray *mJPhotos = [NSMutableArray array];
    int i = 0;
    for (TTMCTLibModel *photo in self.cTLibs) {
        //将图片url转换成高清的图片url
        MJPhoto *mjPhoto = [[MJPhoto alloc] init];
        mjPhoto.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@_%@",ImageDown,photo.ckeyid,photo.ct_image]];
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


@end
