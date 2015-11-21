//
//  BQCamera.m
//  BQCommunity
//
//  Created by ZL on 14-9-11.
//  Copyright (c) 2014年 beiqing. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <ImageIO/ImageIO.h>
#import <objc/message.h>
#import "ZLCameraViewController.h"
#import "ZLCameraImageView.h"
#import "ZLCameraView.h"
#import "ZLPhoto.h"
#import "MCPopoverView.h"
#import "MCPopoverPhotoView.h"

static CGFloat ZLCameraColletionViewW = 80;
static CGFloat ZLCameraColletionViewPadding = 20;
static CGFloat BOTTOM_HEIGHT = 60;

@interface ZLCameraViewController () <
    UIActionSheetDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegate,
    AVCaptureMetadataOutputObjectsDelegate,
    ZLCameraImageViewDelegate,
    ZLCameraViewDelegate,
    ZLPhotoPickerViewControllerDelegate,
    ZLPhotoPickerBrowserViewControllerDataSource,
    ZLPhotoPickerBrowserViewControllerDelegate>

@property (weak,nonatomic) ZLCameraView *caramView;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIViewController *currentViewController;

// Datas
@property (strong, nonatomic) NSMutableArray *images;
@property (strong, nonatomic) NSMutableDictionary *dictM;
// 完成后回调
@property (copy, nonatomic) ZLComplate complate;

// AVFoundation
@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) AVCaptureStillImageOutput *captureOutput;
@property (strong, nonatomic) AVCaptureDevice *device;

@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;
@end

@implementation ZLCameraViewController

#pragma mark - Getter
#pragma mark Data
- (NSMutableArray *)images{
    if (!_images) {
        _images = [NSMutableArray array];
    }
    return _images;
}

- (NSMutableDictionary *)dictM{
    if (!_dictM) {
        _dictM = [NSMutableDictionary dictionary];
    }
    return _dictM;
}

#pragma mark View
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(ZLCameraColletionViewW, ZLCameraColletionViewW);
        layout.minimumLineSpacing = ZLCameraColletionViewPadding;
        
        CGFloat collectionViewH = ZLCameraColletionViewW;
        CGFloat collectionViewY = self.caramView.height - collectionViewH - 10;
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(ZLCameraColletionViewPadding, collectionViewY, self.view.width, collectionViewH)
                                                              collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor clearColor];
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [self.caramView addSubview:collectionView];
        self.collectionView = collectionView;
    }
    return _collectionView;
}

- (void) initialize
{
    //1.创建会话层
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    self.captureOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
    [self.captureOutput setOutputSettings:outputSettings];
    
    // Session
    self.session = [[AVCaptureSession alloc]init];
    
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([self.session canAddInput:self.input])
    {
        [self.session addInput:self.input];
    }
    
    if ([self.session canAddOutput:_captureOutput])
    {
        [self.session addOutput:_captureOutput];
    }
    
    self.preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.preview.frame = self.view.bounds;
    
    ZLCameraView *caramView = [[ZLCameraView alloc] initWithFrame:CGRectMake(0, 40, self.view.width, self.view.height - 40 - BOTTOM_HEIGHT)];
    caramView.backgroundColor = [UIColor clearColor];
    caramView.delegate = self;
    [self.view addSubview:caramView];
    [self.view.layer insertSublayer:self.preview atIndex:0];
    self.caramView = caramView;
}

- (void)cameraDidSelected:(ZLCameraView *)camera{
    [self.device lockForConfiguration:nil];
    [self.device setFocusMode:AVCaptureFocusModeAutoFocus];
    [self.device setFocusPointOfInterest:CGPointMake(50,50)];
    //操作完成后，记得进行unlock。
    [self.device unlockForConfiguration];
}

//对焦回调
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if( [keyPath isEqualToString:@"adjustingFocus"] ){}
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self initialize];
    [self setup];
    if (self.session) {
        [self.session startRunning];
    }
}

#pragma mark 初始化按钮
- (UIButton *) setupButtonWithImageName : (NSString *) imageName andX : (CGFloat ) x{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    button.width = 50;
    button.y = 0;
    button.height = self.topView.height;
    button.x = x;
    [self.view addSubview:button];
    return button;
}

#pragma mark -初始化界面
- (void) setup{
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    CGFloat width = 50;
    CGFloat margin = 20;
    
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor blackColor];
    topView.frame = CGRectMake(0, 0, self.view.width, 40);
    [self.view addSubview:topView];
    self.topView = topView;
    
    // 头部View
    UIButton *deviceBtn = [self setupButtonWithImageName:@"xiang" andX:self.view.width - margin - width];
    [deviceBtn addTarget:self action:@selector(changeCameraDevice:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *flashBtn = [self setupButtonWithImageName:@"shanguangdeng" andX:10];
    [flashBtn addTarget:self action:@selector(flashCameraDevice:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *closeBtn = [self setupButtonWithImageName:@"shanguangdeng2" andX:60];
    [closeBtn addTarget:self action:@selector(closeFlashlight:) forControlEvents:UIControlEventTouchUpInside];
    
    
    // 底部View
    UIView *controlView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height-BOTTOM_HEIGHT, self.view.width, BOTTOM_HEIGHT)];
    controlView.backgroundColor = [UIColor clearColor];
    controlView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    self.controlView = controlView;
    
    UIView *contentView = [[UIView alloc] init];
    contentView.frame = controlView.bounds;
    contentView.backgroundColor = [UIColor blackColor];
    contentView.alpha = 0.3;
    [controlView addSubview:contentView];
    
    CGFloat x = (self.view.width - width) / 3;
    //取消
    UIButton *cancalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancalBtn.frame = CGRectMake(margin, 0, x, controlView.height);
    [cancalBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancalBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [controlView addSubview:cancalBtn];
    //拍照
    UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cameraBtn.frame = CGRectMake(x+margin, margin / 4, x, controlView.height - margin / 2);
    cameraBtn.showsTouchWhenHighlighted = YES;
    cameraBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [cameraBtn setImage:[UIImage imageNamed:@"paizhao"] forState:UIControlStateNormal];
    [cameraBtn addTarget:self action:@selector(stillImage:) forControlEvents:UIControlEventTouchUpInside];
    [controlView addSubview:cameraBtn];
    // 完成
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame = CGRectMake(self.view.width - 2 * margin - width, 0, width, controlView.height);
    [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
    [controlView addSubview:doneBtn];
    
    [self.view addSubview:controlView];
}

- (NSInteger ) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger ) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.images.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    ZLCamera *camera = self.images[indexPath.item];
    
    ZLCameraImageView *lastView = [cell.contentView.subviews lastObject];
    if(![lastView isKindOfClass:[ZLCameraImageView class]]){
        // 解决重用问题
        UIImage *image = camera.thumbImage;
        ZLCameraImageView *imageView = [[ZLCameraImageView alloc] init];
        imageView.delegatge = self;
        imageView.edit = YES;
        imageView.image = image;
        imageView.frame = cell.bounds;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [cell.contentView addSubview:imageView];
    }
    
    lastView.image = camera.thumbImage;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ZLPhotoPickerBrowserViewController *browserVc = [[ZLPhotoPickerBrowserViewController alloc] init];
    browserVc.toView = [[[[collectionView cellForItemAtIndexPath:indexPath] contentView] subviews] lastObject];
    browserVc.dataSource = self;
    browserVc.delegate = self;
    browserVc.currentIndexPath = [NSIndexPath indexPathForItem:indexPath.item inSection:0];
    browserVc.editing = YES;
    [self presentViewController:browserVc animated:NO completion:nil];
    
}


#pragma mark - <ZLPhotoPickerBrowserViewControllerDataSource>
- (NSInteger)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section{
    return self.images.count;
}

- (ZLPhotoPickerBrowserPhoto *) photoBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath{
    
    id imageObj = [[self.images objectAtIndex:indexPath.row] fullScreenImage];
    ZLPhotoPickerBrowserPhoto *photo = [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:imageObj];
    
    UICollectionViewCell *cell = (UICollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
    
    UIImageView *imageView = [[cell.contentView subviews] lastObject];
    photo.thumbImage = imageView.image;
    
    return photo;
}

- (void)deleteImageView:(ZLCameraImageView *)imageView{
    NSMutableArray *arrM = [self.images mutableCopy];
    for (ZLCamera *camera in self.images) {
        UIImage *image = camera.thumbImage;
        if ([image isEqual:imageView.image]) {
            [arrM removeObject:camera];
        }
    }
    self.images = arrM;
    [self.collectionView reloadData];
}

- (void)startCameraOrPhotoFileWithViewController:(UIViewController *)viewController complate:(ZLComplate)complate{
    self.currentViewController = viewController;
    if (self.selectType == ZLCameraViewControllerSelectTypePopover) {
//        CGPoint point = CGPointMake(ScreenWidth - 60, NavigationHeight);
//        NSArray *titles = @[@"拍照", @"手机相册"];
//        MCPopoverView *pop = [[MCPopoverView alloc] initWithPoint:point titles:titles images:nil];
//        pop.selectRowAtIndex = ^(NSInteger index){
//            switch (index)
//            {
//                case 0:  //打开照相机拍照
//                    [self takePhoto];
//                    break;
//                case 1:  //打开本地相册
//                    [self LocalPhoto];
//                    break;
//            }
//        };
//        [pop show];
        CGPoint point = CGPointMake(ScreenWidth - 100, NavigationHeight);
        NSArray *titles = @[@"拍照", @"手机相册"];
        MCPopoverPhotoView *pop = [[MCPopoverPhotoView alloc] initWithPoint:point titles:titles];
        pop.selectRowAtIndex = ^(NSInteger index){
            switch (index)
            {
                case 0:  //打开照相机拍照
                    [self takePhoto];
                    break;
                case 1:  //打开本地相册
                    [self LocalPhoto];
                    break;
            }
        };
        
        [pop show];
        
    } else {
        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:@"拍照", @"手机相册", nil];
        
        [action showInView:viewController.view];
    }
    self.complate = complate;
}

#pragma mark - actionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:  //打开照相机拍照
            [self takePhoto];
            break;
        case 1:  //打开本地相册
            [self LocalPhoto];
            break;
    }
}

-(void)Captureimage
{
    //get connection
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in self.captureOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) { break; }
    }
    
    //get UIImage
    [self.captureOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:
     ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
         CFDictionaryRef exifAttachments =
         CMGetAttachment(imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
         if (exifAttachments) {
             // Do something with the attachments.
         }
         
         // Continue as appropriate.
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
         UIImage *t_image = [UIImage imageWithData:imageData];
         
         NSDateFormatter *formater = [[NSDateFormatter alloc] init];
         formater.dateFormat = @"yyyyMMddHHmmss";
         NSString *currentTimeStr = [[formater stringFromDate:[NSDate date]] stringByAppendingFormat:@"_%d" ,arc4random_uniform(10000)];

         t_image = [self fixOrientation:t_image];
         
         NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:currentTimeStr];
         [UIImagePNGRepresentation(t_image) writeToFile:path atomically:YES];
         
         
         
         NSData *data = UIImageJPEGRepresentation(t_image, 0.3);
         ZLCamera *camera = [[ZLCamera alloc] init];
         camera.imagePath = path;
         camera.thumbImage = [UIImage imageWithData:data];
         [self.images addObject:camera];
         
         [self.collectionView reloadData];
         [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:self.images.count - 1 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionRight];
         
     }];
}

-(void)CaptureStillImage
{
    [self  Captureimage];
}

//开始拍照
-(void)takePhoto
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        ZLCameraViewController *camreaVc = [[ZLCameraViewController alloc] init];
        camreaVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        camreaVc.complate = self.complate;
        [self.currentViewController presentViewController:camreaVc animated:YES completion:nil];
        
    }else
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}


//打开本地相册
-(void)LocalPhoto
{
    ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];
    pickerVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    pickerVc.selectPickers = self.selectPickers;
    // 最多能选9张图片
    pickerVc.minCount = KPhotoShowMaxCount;
    pickerVc.status = PickerViewShowStatusCameraRoll;
    pickerVc.delegate = self;
    [pickerVc show];
}

- (void)pickerViewControllerDoneAsstes:(NSArray *)assets{
    if (self.complate) {
        self.complate(assets);
    }
    
    if ([self.currentViewController respondsToSelector:@selector(pickerViewControllerDoneAsstes:)]) {
        
        [self.currentViewController performSelectorInBackground:@selector(pickerViewControllerDoneAsstes:) withObject:assets];
    }
    
    
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices )
        if ( device.position == position )
            return device;
    return nil;
}

- (void)changeCameraDevice:(id)sender
{
    // 翻转
    [UIView beginAnimations:@"animation" context:nil];
    [UIView setAnimationDuration:.5f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    [UIView commitAnimations];
    
    NSArray *inputs = self.session.inputs;
    for ( AVCaptureDeviceInput *input in inputs ) {
        AVCaptureDevice *device = input.device;
        if ( [device hasMediaType:AVMediaTypeVideo] ) {
            AVCaptureDevicePosition position = device.position;
            AVCaptureDevice *newCamera = nil;
            AVCaptureDeviceInput *newInput = nil;
            
            if (position == AVCaptureDevicePositionFront)
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
            else
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
            newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
            
            [self.session beginConfiguration];
            
            [self.session removeInput:input];
            [self.session addInput:newInput];
            
            // Changes take effect once the outermost commitConfiguration is invoked.
            [self.session commitConfiguration];
            break;
        }
    }
}

- (void) flashLightModel : (codeBlock) codeBlock{
    if (!codeBlock) return;
    [self.session beginConfiguration];
    [self.device lockForConfiguration:nil];
    codeBlock();
    [self.device unlockForConfiguration];
    [self.session commitConfiguration];
    [self.session startRunning];
}
- (void) flashCameraDevice:(UIButton *)sender{
    [self flashLightModel:^{
        [self.device setTorchMode:AVCaptureTorchModeOn];
    }];
}

- (void) closeFlashlight:(UIButton *)sender{
    // self.device.torchMode == AVCaptureTorchModeOff 判断
    [self flashLightModel:^{
        [self.device setTorchMode:AVCaptureTorchModeOff];
    }];
}

- (void)cancel:(id)sender
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
}


//完成、取消
- (void)doneAction
{
    //关闭相册界面
    if(self.complate){
        self.complate(self.images);
    }
    [self cancel:nil];
}

//拍照
- (void)stillImage:(id)sender
{
    [self Captureimage];
    UIView *maskView = [[UIView alloc] init];
    maskView.frame = self.view.bounds;
    maskView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:maskView];
    [UIView animateWithDuration:.5 animations:^{
        maskView.alpha = 0;
    } completion:^(BOOL finished) {
        [maskView removeFromSuperview];
    }];
}

- (BOOL)shouldAutorotate{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

- (UIImage *)fixOrientation:(UIImage *)srcImg
{
    if (srcImg.imageOrientation == UIImageOrientationUp) return srcImg;
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (srcImg.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.width, srcImg.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, srcImg.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (srcImg.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, srcImg.size.width, srcImg.size.height,
                                             CGImageGetBitsPerComponent(srcImg.CGImage), 0,
                                             CGImageGetColorSpace(srcImg.CGImage),
                                             CGImageGetBitmapInfo(srcImg.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (srcImg.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,srcImg.size.height,srcImg.size.width), srcImg.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,srcImg.size.width,srcImg.size.height), srcImg.CGImage);
            break;
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

@end

