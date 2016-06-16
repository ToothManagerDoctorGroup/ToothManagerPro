//
//  CTView.m
//  CRM
//
//  Created by Kane.Zhu on 14-5-18.
//  Copyright (c) 2014年 TimTiger. All rights reserved.
//

#import "CTView.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "DBManager+Patients.h"
#import "CRMMacro.h"

#define CTIMAGE_TAG 1000
#define ALERT_TAG 2000
#define DELETE_BUTTON_TAG 3000

@interface CTView () <UIAlertViewDelegate>
{
    NSString * filePath;
    float space;
}
@end

@implementation CTView

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame WithSuperController:nil WithMedicalCase:nil];
}

- (id)initWithFrame:(CGRect)frame WithSuperController:(TimViewController *)controller WithMedicalCase:(MedicalCase *)mCase
{
    self = [super initWithFrame:frame];
    if (self){
        scrollWidth = frame.size.width;
        scrollHeight = frame.size.height;
        space = 5.0f;
        timViewController = controller;
        medicalcase = mCase;
        [self initData];
        [self initView];
    }
    return self;
}

- (BOOL)saveCTLibWithCaseId:(NSString *)caseid {
    
    BOOL ret = YES;
    for (NSInteger i = 0; i < ctlibArray.count; i++) {
        CTLib *tmpLib = [ctlibArray objectAtIndex:i];
        if ([tmpLib.ct_image isNotEmpty]) {
            continue;
        }
        tmpLib.case_id = caseid;
        tmpLib.ct_image = [CaseFunction generateImageNameWithId:caseid];

        if ([[DBManager shareInstance] insertCTLib:tmpLib]) {

            UIImage *image = [imageCacheArray objectAtIndex:i];
            if([CaseFunction saveImageWithImage:image AndWithCTLib:tmpLib]) {
                ret = YES;
            } else {
                //handle error
                ret = NO;
            }
        } else {
            //handler error
            ret = NO;
        }
    }
    
    return ret;
}

- (void)initData
{
    ctlibArray = [NSMutableArray arrayWithCapacity:0];
    photoArray = [NSMutableArray arrayWithCapacity:0];
    imageCacheArray = [NSMutableArray arrayWithCapacity:0];
    //路径
    filePath = [CaseFunction getCasePath:medicalcase.ckeyid patientId:medicalcase.patient_id];
    //路径里存在的照片
    NSArray *tmpLibArray = [[DBManager shareInstance] getCTLibArrayWithCaseId:medicalcase.ckeyid isAsc:NO];
    [ctlibArray addObjectsFromArray:tmpLibArray]; //这个病例对应的所有CTLib信息
}

- (void)initView
{
    //初始化UI
    NSInteger n = [ctlibArray count];
    CTScrollView = [[NewCaseScrollew alloc]initWithFrame:CGRectMake(0, 0, 320, scrollHeight)];
    CTScrollView.scrollEnabled = YES;
    [CTScrollView setContentSize:CGSizeMake((n + 2) * (scrollHeight + space), scrollHeight)]; //space图间距
    [self addSubview:CTScrollView];
    
    if (ctlibArray != nil && [ctlibArray count] > 0){
        for (NSInteger i = 0; i < [ctlibArray count]; i ++) {
            CTLib *tmpLib = [ctlibArray objectAtIndex:i];
            UIImage * image = [[UIImage alloc]initWithContentsOfFile:[filePath stringByAppendingPathComponent:tmpLib.ct_image]];
            if (image) {
                [self addImageViewWithImage:image atIndex:i];
                //把取来的图片加进缓存
                [imageCacheArray addObject:image];
            }
        }
    }
    
    addCTButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [addCTButton setFrame:CGRectMake(n * (scrollHeight + 5), 0, scrollHeight, scrollHeight)];
    [addCTButton setImage:[UIImage imageNamed:@"btn_new_orange"] forState:UIControlStateNormal];
    [addCTButton setBackgroundColor:[UIColor whiteColor]];
    [addCTButton addTarget:self action:@selector(addCTImage:) forControlEvents:UIControlEventTouchUpInside];
    [CTScrollView addSubview:addCTButton];
    
}

- (void)addImageViewWithImage:(UIImage *)image atIndex:(NSInteger)index {
    
    UITapGestureRecognizer * tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(checkPhotos:)];
    UIImageView * CTImageView = [[UIImageView alloc]init];
    [CTImageView setFrame:CGRectMake(index * (scrollHeight + space), 0, scrollHeight, scrollHeight)];
    [CTImageView setImage:image];
    [CTImageView setUserInteractionEnabled:YES];
    [CTImageView setTag:CTIMAGE_TAG + index];
    [CTImageView addGestureRecognizer:tapGes];
    [CTScrollView addSubview:CTImageView];
    
    //添加删除按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(CTImageView.frame.size.width - 22, 0, 24, 24);
    [button setBackgroundImage:[UIImage imageNamed:@"btn_close"] forState:UIControlStateNormal];
    button.tag = DELETE_BUTTON_TAG +index;
    [button addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
    [CTImageView addSubview:button];
    [CTScrollView setContentSize:CGSizeMake((ctlibArray.count+2)*(scrollHeight + space), scrollHeight)];
}

- (void)removeImageViewWithIndex:(NSInteger)index {
    UIImageView *imageView = (UIImageView *)[CTScrollView viewWithTag:CTIMAGE_TAG + index];
    [imageView removeFromSuperview];
    UIButton *deleteButton = (UIButton *)[CTScrollView viewWithTag:DELETE_BUTTON_TAG+index];
    [deleteButton removeFromSuperview];
    for (NSInteger i = index; i < ctlibArray.count; i++) {
        UIImageView *imageView1 = (UIImageView *)[CTScrollView viewWithTag:CTIMAGE_TAG + index+1];
        [imageView1 setFrame:CGRectMake(imageView1.frame.origin.x-(scrollHeight + space), 0, scrollHeight, scrollHeight)];
        imageView1.tag = CTIMAGE_TAG+index;
        UIButton *deleteButton1 = (UIButton *)[CTScrollView viewWithTag:DELETE_BUTTON_TAG+index+1];
        [deleteButton1 setFrame:CGRectMake(deleteButton1.frame.origin.x-(scrollHeight + space), 0, 24, 24)];
        deleteButton1.tag = CTIMAGE_TAG+index;
    }
    [addCTButton setFrame:CGRectMake(addCTButton.frame.origin.x-(scrollHeight + space), 0, scrollHeight, scrollHeight)];
    [CTScrollView setContentSize:CGSizeMake((ctlibArray.count+1)*(scrollHeight + space), scrollHeight)];
}

- (void)addCTImage:(UIButton *)sender
{
    NSLog(@"add CT Image");
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [choiceSheet showInView:self];
}

- (void)checkPhotos:(UITapGestureRecognizer *)sender
{
    UIImageView * imageView = (UIImageView *)sender.view;

    for (NSInteger i=0;i<[imageCacheArray count];i++) {
        UIImage * image = [imageCacheArray objectAtIndex:i];
        MWPhoto* photo = [[MWPhoto alloc]initWithImage:image];// 设置图片
        [photoArray addObject:photo];
    }
    browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    
    // Set options
    browser.displayActionButton = NO; // 显示动作按钮允许共享，复制，等等（缺省值为“是”）
    browser.displayNavArrows = YES; // 是否显示导航工具栏上的左、右箭头（缺省为不）
    browser.displaySelectionButtons = NO; // 是否选择按钮上显示图像（缺省为不）
    browser.zoomPhotosToFill = YES; // 图像，几乎填满屏幕将初步放大到填充（缺省为的是的）
    browser.alwaysShowControls = NO; // 允许控制是否条和控件总是可见的或他们是否褪色显示照片完整（缺省为不）
    browser.enableGrid = YES; // 是否允许在网格中的所有照片的缩略图查看（缺省值为“是”）
    browser.startOnGrid = NO; // 是否开始在缩略图网格而不是第一张照片（缺省为不）
    browser.wantsFullScreenLayout = NO; //  iOS 5和6只：决定你想要的图片浏览器的全屏，即状态栏是否影响（缺省值为“是”）
    
    [browser setCurrentPhotoIndex:imageView.tag - CTIMAGE_TAG];
    
    [timViewController pushViewController:browser animated:YES];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // 拍照
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isFrontCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [timViewController presentViewController:controller
                                            animated:YES
                                          completion:^(void){
                                              NSLog(@"Picker View Controller is presented");
                                          }];
        }
        
    } else if (buttonIndex == 1) {
        // 从相册中选取
        if ([self isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [timViewController presentViewController:controller
                                            animated:YES
                                          completion:^(void){
                                              NSLog(@"Picker View Controller is presented");
                                          }];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        //在ScrollView上加上Image
        NSInteger count = [ctlibArray count];
        [self addImageViewWithImage:portraitImg atIndex:count];
        [addCTButton setFrame:CGRectMake(++count * (scrollHeight + space), 0, scrollHeight, scrollHeight)];
        
        //新建一个CTLib加入数组中
        CTLib *newCTLib = [[CTLib alloc]init];
        newCTLib.case_id = medicalcase.ckeyid;
        newCTLib.patient_id = medicalcase.patient_id;
        newCTLib.creation_date = medicalcase.creation_date;
        newCTLib.ct_desc = @"暂无描述";
        [ctlibArray addObject:newCTLib];
        
        //图片加入缓存中
        [imageCacheArray addObject:portraitImg];

    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}


#pragma mark -MWPhotoBrowser Delegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return [photoArray count];
}
- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (index < photoArray.count)
        return [photoArray objectAtIndex:index];
    return nil;
}

#pragma mark - Delete Image Method
- (void)deleteImage:(UIButton *)sender
{
    //保存点击的是第几张图片
    touchIndex = sender.tag - DELETE_BUTTON_TAG;
    //弹出警告框，防止误删
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"警告!" message:@"确定删除图片?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert setTag:ALERT_TAG + touchIndex];
    [alert setDelegate:self];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSInteger index = alertView.tag - ALERT_TAG;
        if (index < ctlibArray.count) {
            CTLib *lib = [ctlibArray objectAtIndex:index];
            if ([lib.ct_image isNotEmpty]) {
                //如果是已经存到了数据库的lib
                [[NSNotificationCenter defaultCenter] postNotificationName:MedicalCaseEditedNotification object:nil userInfo:nil];
                BOOL ret = [[DBManager shareInstance] deleteCTlibWithLibId:lib.ckeyid];
                if (ret == YES) {
                    [CaseFunction deleteImageWithCTLib:lib];
                    [ctlibArray removeObjectAtIndex:index];
                    [imageCacheArray removeObjectAtIndex:index];
                    [self removeImageViewWithIndex:index];
                }
            } else {
                //如果是还没有存到数据库的lib
                [ctlibArray removeObjectAtIndex:index];
                [imageCacheArray removeObjectAtIndex:index];
                [self removeImageViewWithIndex:index];
            }
        }
       
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
