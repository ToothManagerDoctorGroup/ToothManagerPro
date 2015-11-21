//
//  THCPhotoPickerView.m
//  THCPhotoPicker
//
//  Created by thc on 15/4/13.
//  Copyright (c) 2015年 roger. All rights reserved.
//

#import "MCPhotoPickerView.h"
#import "ZLPhoto.h"
#import "UIButton+WebCache.h"

#define kColumns 4
#define kMaxPhotos 9
#define kPadding 5
#define kCornRadius 2

@interface MCPhotoPickerView ()<
    ZLPhotoPickerBrowserViewControllerDelegate,
    ZLPhotoPickerBrowserViewControllerDataSource>

@property (nonatomic, strong) ZLCameraViewController *cameraVC;
@end

@implementation MCPhotoPickerView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.columns = kColumns;
    self.maxPhotos = kMaxPhotos;
    self.photoArray = [NSMutableArray array];
}

- (void)reloadView {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // 图片张数等于最大了，就不放加号图片
    NSUInteger allCount = self.photoArray.count == self.maxPhotos ? self.photoArray.count : self.photoArray.count + 1;
    for (NSInteger i = 0; i < allCount; i ++) {
        CGFloat width = (self.frame.size.width - (kPadding * (self.columns + 1))) / self.columns ;
        CGFloat height = width;
        
        CGFloat row = i / self.columns;
        CGFloat col = i % self.columns;
        
        UIButton *imageButton = [[UIButton alloc] init];
        imageButton.frame = CGRectMake(col * (kPadding + width) + kPadding, row * (height + kPadding), width, height);
        imageButton.tag = i; // 用来记录照片index
        [imageButton addTarget:self action:@selector(clickImage:) forControlEvents:UIControlEventTouchUpInside];
        imageButton.layer.cornerRadius = kCornRadius;
        imageButton.clipsToBounds = YES;
        [self addSubview:imageButton];
        
        if (i == self.photoArray.count) { // 在数组最后添加加号图片
            [imageButton setBackgroundImage:[UIImage imageNamed:@"clinic_plus"] forState:UIControlStateNormal];
        } else {
            ZLPhotoAssets *asset = self.photoArray[i];
            if ([asset isKindOfClass:[ZLPhotoAssets class]]) {
                [imageButton setBackgroundImage:asset.thumbImage forState:UIControlStateNormal];
            } else if ([asset isKindOfClass:[UIImage class]]) {
                [imageButton setBackgroundImage:(UIImage *)asset forState:UIControlStateNormal];
            }
        }
    }
    
}
/**
 *  点击图片事件
 *
 *  @param sender 图片按钮
 */
- (void)clickImage:(UIButton *)sender {
    if (sender.tag == self.photoArray.count) { // 点击为加号按钮
        if (self.photoArray.count != self.maxPhotos) { // 张数没有到最大
            ZLCameraViewController *cameraVC = [[ZLCameraViewController alloc] init];
            cameraVC.selectType = ZLCameraViewControllerSelectTypeActionSheet;
            cameraVC.selectPickers = self.photoArray;
            UIViewController *control = [[[[UIApplication sharedApplication] windows] firstObject] rootViewController];
            // 多选相册+相机多拍 回调
            [cameraVC startCameraOrPhotoFileWithViewController:control
                                                      complate:^(NSArray *array) {
                                                          self.photoArray = [NSMutableArray arrayWithArray:array];
                                                          [self reloadView];
            }];
            self.cameraVC = cameraVC; // 必须添加一个强引用
        }
    } else {
        ZLPhotoPickerBrowserViewController *browserVC = [[ZLPhotoPickerBrowserViewController alloc] init];
        browserVC.toView = sender;
        browserVC.delegate = self;
        browserVC.dataSource = self;
        browserVC.editing = YES;
        browserVC.currentIndexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
        [browserVC show];
        
//        // 修改为点击图片删除
//        [self.photoArray removeObjectAtIndex:sender.tag];
//        [self reloadView];
    }
}

#pragma browserDelegate dataSource delegate

- (NSInteger)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section {
    return self.photoArray.count;
}

- (ZLPhotoPickerBrowserPhoto *)photoBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser
                           photoAtIndexPath:(NSIndexPath *)indexPath {
    ZLPhotoPickerBrowserPhoto *photo = [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:self.photoArray[indexPath.row]];
    return photo;
}

- (void)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser removePhotoAtIndexPath:(NSIndexPath *)indexPath {
    [self.photoArray removeObjectAtIndex:indexPath.row];
    [self reloadView];
}


@end
