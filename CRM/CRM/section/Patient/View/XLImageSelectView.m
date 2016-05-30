//
//  XLImageSelectView.m
//  CRM
//
//  Created by Argo Zhang on 16/3/3.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLImageSelectView.h"
#import "ZYQAssetPickerController.h"
#import "UIView+WXViewController.h"
#import "UIImage+TTMAddtion.h"
#import "UINavigationItem+Margin.h"

@interface XLImageSelectView ()<ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, weak)UIImageView *addImageView;//添加按钮

@property (nonatomic, strong)NSMutableArray *sourceImages;

@end

@implementation XLImageSelectView

- (void)dealloc{
    NSLog(@"我被销毁了");
    [self.sourceImages removeAllObjects];
    self.sourceImages = nil;
    self.addImageView = nil;
}

- (NSMutableArray *)sourceImages{
    if (!_sourceImages) {
        _sourceImages = [NSMutableArray array];
    }
    return _sourceImages;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)awakeFromNib{
    [self setUp];
}

- (void)setUp{
    
    UIImageView *addImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"team_add_head"]];
    addImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [addImageView addGestureRecognizer:tap];
    self.addImageView = addImageView;
    [self addSubview:addImageView];
}

- (void)setImages:(NSArray *)images{
    _images = images;
    
    CGFloat margin = 10;
    CGFloat imageW = 60;
    CGFloat imageH = imageW;
    
    if (images.count == 0) {
        self.addImageView.frame = CGRectMake(margin, margin, imageW, imageH);
    }else{
        
        //移除所有视图
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        [self.sourceImages removeLastObject];
        [self.sourceImages addObjectsFromArray:self.images];
        [self.sourceImages addObject:[UIImage imageNamed:@"team_plus"]];
        //计算一行显示几张图片
        NSInteger countT = self.width / (imageW + margin);
        
        for (int i = 0; i < self.sourceImages.count; i++) {
            int index_x = i / countT;
            int index_y = i % countT;
            
            CGFloat imageX = margin + (margin + imageW) * index_y;
            CGFloat imageY = margin + (margin + imageW) * index_x;
            
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.userInteractionEnabled = YES;
            imageView.image = self.sourceImages[i];
            imageView.frame = CGRectMake(imageX, imageY, imageW, imageW);
            [self addSubview:imageView];
            if (i == self.sourceImages.count - 1) {
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
                [imageView addGestureRecognizer:tap];
            }
            
        }
    }
}

- (CGFloat)getTotalHeigth{
    CGFloat margin = 10;
    CGFloat imageW = 60;
    //计算一行显示几张图片
    NSInteger count = self.width / 70;
    //计算总共有几行
    NSInteger rows = self.sourceImages.count % count == 0 ? self.sourceImages.count / count : self.sourceImages.count / count + 1;
    
    return rows * (imageW + margin);
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
    [sheet showInView:self.viewController.view];
    
    
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        //拍照
        [self getImageFromCamera];
    }else if (buttonIndex == 1){
        //相册选择
        [self getImagesFromAlbum];
    }
}

#pragma mark - 手机拍照
- (void)getImageFromCamera{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self.viewController presentViewController:picker animated:YES completion:^{
    }];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        //压缩图片
        UIImage *resultImage = [UIImage imageCompressForSize:[info objectForKey:UIImagePickerControllerOriginalImage] targetSize:CGSizeMake(60, 60)];
        if (self.delegate && [self.delegate respondsToSelector:@selector(imageSelectView:didChooseImages:)]) {
            [self.delegate imageSelectView:self didChooseImages:@[resultImage]];
        }
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - 相册选择照片
- (void)getImagesFromAlbum{
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = 9;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups = NO;
    picker.delegate = self;
    
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 5;
        } else {
            return YES;
        }
    }];
    [self.viewController presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - ZYQAssetPickerController Delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *array = [NSMutableArray array];
        for (int i=0; i<assets.count; i++) {
            ALAsset *asset=assets[i];
            UIImage *tempImg = [UIImage imageWithCGImage:asset.thumbnail];
            [array addObject:tempImg];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(imageSelectView:didChooseImages:)]) {
                [weakSelf.delegate imageSelectView:weakSelf didChooseImages:array];
            }
        });
    });
}


@end
