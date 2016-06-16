//
//  XLImageScrollView.m
//  CRM
//
//  Created by Argo Zhang on 16/5/24.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLImageScrollView.h"
#import "XLImageScrollViewCell.h"
#import "NSString+TTMAddtion.h"
#import "UIImageView+WebCache.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import <Masonry.h>

#define kButtonWidth 35
#define kButtonHeight kButtonWidth
#define kMargin 20
#define kImageScrollViewID @"scrollView_image_cell"

@interface XLImageScrollView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong)UICollectionView *imageCollectionView;
@property (nonatomic, strong)UIButton *leftPreButton;//上一张按钮
@property (nonatomic, strong)UIButton *rightNextButton;//下一张按钮

@property (nonatomic, strong)NSMutableArray *imageSourceArray;//数据源

@end

@implementation XLImageScrollView

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

#pragma mark - 初始化
- (void)setUp{
    [self addSubview:self.imageCollectionView];
    [self addSubview:self.leftPreButton];
    [self addSubview:self.rightNextButton];
    
    [self setUpContrains];
}

#pragma mark - 设置约束
- (void)setUpContrains{
    [self.imageCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self.leftPreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).with.offset(kMargin);
        make.size.mas_equalTo(CGSizeMake(kButtonWidth, kButtonWidth));
    }];
    
    [self.rightNextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).with.offset(-kMargin);
        make.size.mas_equalTo(CGSizeMake(kButtonWidth, kButtonWidth));
    }];
}

- (void)setImageModelsArray:(NSArray *)imageModelsArray{
    _imageModelsArray = imageModelsArray;
    
    [self.imageSourceArray removeAllObjects];
    [self.imageSourceArray addObjectsFromArray:imageModelsArray];
    [self.imageCollectionView reloadData];
}

#pragma mark - ****************** Delegate / DataSource *******************
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageSourceArray.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.frame.size;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    XLImageScrollViewModel *model = self.imageSourceArray[indexPath.item];
    XLImageScrollViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kImageScrollViewID forIndexPath:indexPath];
    //判断当前model的URL
    if ([model.imageUrl isContainsString:@"http:"]) {
        //网络图片
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:[UIImage imageNamed:@"schedule_placeholder_loading"] options:SDWebImageRetryFailed];
    }else{
        //本地图片
        cell.imageView.image = [UIImage imageNamed:model.imageUrl];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    XLImageScrollViewCell *cell = (XLImageScrollViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    //获取当前点击的视图
    UIImageView *imageView = cell.imageView;
    //遍历当前图片数组，将LBPhoto模型转换成MJPhoto模型
    NSMutableArray *mJPhotos = [NSMutableArray array];
    int i = 0;
    for (XLImageScrollViewModel *model in self.imageSourceArray) {
        //将图片url转换成高清的图片url
        MJPhoto *mjPhoto = [[MJPhoto alloc] init];
        mjPhoto.url = [NSURL URLWithString:model.imageUrl];
        mjPhoto.srcImageView = imageView;
        mjPhoto.index = i;
        [mJPhotos addObject:mjPhoto];
        i++;
    }
    
    //创建图片显示控制器对象
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.photos = mJPhotos;
    browser.currentPhotoIndex = indexPath.item;
    //显示
    [browser show];
}



#pragma mark - ********************* Lazy Method ***********************
- (UICollectionView *)imageCollectionView{
    if (!_imageCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 0;
        
        _imageCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _imageCollectionView.delegate = self;
        _imageCollectionView.dataSource = self;
        _imageCollectionView.backgroundColor = [UIColor whiteColor];
        _imageCollectionView.showsHorizontalScrollIndicator = NO;
        _imageCollectionView.pagingEnabled = YES;
        _imageCollectionView.bounces = NO;
        [_imageCollectionView registerClass:[XLImageScrollViewCell class] forCellWithReuseIdentifier:kImageScrollViewID];
    }
    return _imageCollectionView;
}

- (UIButton *)leftPreButton{
    if (!_leftPreButton) {
        _leftPreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftPreButton.layer.cornerRadius = kButtonWidth / 2;
        _leftPreButton.layer.masksToBounds = YES;
        [_leftPreButton setImage:[UIImage imageNamed:@"team_left"] forState:UIControlStateNormal];
        _leftPreButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5];
    }
    return _leftPreButton;
}

- (UIButton *)rightNextButton{
    if (!_rightNextButton) {
        _rightNextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightNextButton.layer.cornerRadius = kButtonWidth / 2;
        _rightNextButton.layer.masksToBounds = YES;
        [_rightNextButton setImage:[UIImage imageNamed:@"team_right"] forState:UIControlStateNormal];
        _rightNextButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5];
    }
    return _rightNextButton;
}

- (NSMutableArray *)imageSourceArray{
    if (!_imageSourceArray) {
        _imageSourceArray = [NSMutableArray array];
    }
    return _imageSourceArray;
}

@end


@implementation XLImageScrollViewModel


@end
