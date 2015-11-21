

#import "TTMRealisticSceneController.h"
#import "TTMAddImageView.h"
#import "CYAlertView.h"
#import "HZPhotoBrowser.h"

@interface TTMRealisticSceneController ()<
    TTMAddImageViewDelegate,
    UIActionSheetDelegate,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate,
    UIAlertViewDelegate,
    HZPhotoBrowserDelegate>

@property (nonatomic, weak)   TTMAddImageView *addImageView; // 选择添加图片视图

@end

@implementation TTMRealisticSceneController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"诊所实景图";
    
    [self setupAddImageView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)setupAddImageView {
    CGFloat margin = 10.f;
    CGFloat pickerY = margin + NavigationHeight;
    CGFloat pickerW = ScreenWidth - 2 * margin;
    CGFloat pickerH = ScreenHeight - NavigationHeight - margin;
    
    TTMAddImageView *addImageView = [TTMAddImageView new];
    addImageView.frame = CGRectMake(margin, pickerY, pickerW, pickerH);
    addImageView.delegate = self;
    [self.view addSubview:addImageView];
    self.addImageView = addImageView;
    [self queryImages];
}

#pragma - mark TTMAddImageViewDelegate
- (void)addImageView:(TTMAddImageView *)addImageView clickedWithModel:(TTMRealisticModel *)model button:(UIButton *)button {
    if (model) {
        TTMLog(@"浏览大图");
        //启动图片浏览器
        HZPhotoBrowser *browserVc = [[HZPhotoBrowser alloc] init];
        browserVc.sourceImagesContainerView = addImageView; // 原图的父控件
        browserVc.imageCount = addImageView.photoArray.count; // 图片总数
        browserVc.currentImageIndex = (int)button.tag;
        browserVc.delegate = self;
        [browserVc show];
        
    } else { // 点击加号
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"拍照", @"从相册选择", nil];
        actionSheet.tag = 1;
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [actionSheet showInView:self.view];
    }
}

- (void)addImageView:(TTMAddImageView *)addImageView deleteWithModel:(TTMRealisticModel *)model {
    if (model) {
        __weak __typeof(&*self) weakSelf = self;
        CYAlertView *alert = [[CYAlertView alloc] initWithTitle:@"确定要删除这张图片吗?"
                                                        message:nil
                                                   clickedBlock:^(CYAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
                                                       if (buttonIndex == 1) {
                                                           [weakSelf deleteImageWithModel:model];
                                                       }
                                                   }
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确认", nil];
        [alert show];
    }
}

#pragma mark - photobrowser代理方法
- (UIImage *)photoBrowser:(HZPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    return [UIImage imageNamed:@"whiteplaceholder"];
}

- (NSURL *)photoBrowser:(HZPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    TTMRealisticModel *model = self.addImageView.photoArray[index];
    return [NSURL URLWithString:model.img_info];
}

#pragma mark - 图片选择
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    if (buttonIndex == 0) { // 拍照
        if (TARGET_IPHONE_SIMULATOR) {
            [MBProgressHUD showToastWithText:@"请使用真机"];
            return;
        }
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    } else if (buttonIndex == 1) { // 从相册选择
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
        [self presentViewController:picker animated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerControllerDelegate
// 选择了图片或者拍照了
- (void)imagePickerController:(UIImagePickerController *)aPicker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [aPicker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    if (image) {
        [self addImage:image];
    }
    return;
}

/**
 *  查询实景图列表
 */
- (void)queryImages {
    __weak __typeof(&*self) weakSelf = self;
    [TTMRealisticModel queryImagesWithComplete:^(id result) {
        if ([result isKindOfClass:[NSString class]]) {
            [MBProgressHUD showToastWithText:result];
        } else {
            weakSelf.addImageView.photoArray = result;
            [weakSelf.addImageView reloadView];
        }
    }];
}

/**
 *  添加图片
 *
 *  @param image 图片
 */
- (void)addImage:(UIImage *)image {
    __weak __typeof(&*self) weakSelf = self;
    TTMRealisticModel *model = [TTMRealisticModel new];
    model.remark = @"诊所实景图";
    model.uploadImage = image;
    MBProgressHUD *loading = [MBProgressHUD showLoading];
    
    [TTMRealisticModel addImageWithModel:model complete:^(id result) {
        [loading hide:YES];
        if ([result isKindOfClass:[NSString class]]) {
            [MBProgressHUD showToastWithText:result];
        } else {
            [weakSelf queryImages];
        }
    }];
}

/**
 *  删除图片model
 *
 *  @param model model description
 */
- (void)deleteImageWithModel:(TTMRealisticModel *)model {
    __weak __typeof(&*self) weakSelf = self;
    MBProgressHUD *loading = [MBProgressHUD showLoading];
    [TTMRealisticModel deleteImageWithModel:model complete:^(id result) {
        [loading hide:YES];
        if ([result isKindOfClass:[NSString class]]) {
            [MBProgressHUD showToastWithText:result];
        } else {
            [weakSelf queryImages];
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
