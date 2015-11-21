
#import "TTMChairSettingContentController.h"
#import "TTMChairSettingView.h"
#import "CYAlertView.h"
#import "HZPhotoBrowser.h"

#define kSegmentH 40.f

NSString *const TTMChairSettingContentControllerSave = @"TTMChairSettingContentControllerSave";

@interface TTMChairSettingContentController ()<
    TTMAddImageViewDelegate,
    UINavigationControllerDelegate,
    UIImagePickerControllerDelegate,
    UIActionSheetDelegate,
    UIAlertViewDelegate,
    HZPhotoBrowserDelegate>

@property (nonatomic, weak)   TTMChairSettingView *chairSettingView;

@end

@implementation TTMChairSettingContentController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupChairSettingView];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(saveCharSetting)
                                                 name:TTMChairSettingContentControllerSave
                                               object:nil];
}

- (void)setupChairSettingView {
    CGFloat height = ScreenHeight - kSegmentH - NavigationHeight;
    CGRect frame = CGRectMake(0, 0, ScreenWidth, height);
    TTMChairSettingView *chairSettingView = [[TTMChairSettingView alloc] initWithFrame:frame];
    chairSettingView.addImageView.delegate = self;
    [self.view addSubview:chairSettingView];
    self.chairSettingView = chairSettingView;
    [self queryChairSetting];
}

- (void)setSettingModel:(TTMChairSettingModel *)settingModel {
    _settingModel = settingModel;
    self.chairSettingView.model = settingModel;
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
    TTMRealisticModel *model = self.chairSettingView.addImageView.photoArray[index];
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
 *  查询椅位图列表
 */
- (void)queryImages {
    __weak __typeof(&*self) weakSelf = self;
    [TTMRealisticModel queryImagesWithSeatId:self.chairModel.seat_id complete:^(id result) {
        if ([result isKindOfClass:[NSString class]]) {
            [MBProgressHUD showToastWithText:result];
        } else {
            weakSelf.chairSettingView.addImageView.photoArray = result;
            [weakSelf.chairSettingView.addImageView reloadView];
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
    model.remark = @"椅位图";
    model.uploadImage = image;
    model.seat_id = self.chairModel.seat_id;
    MBProgressHUD *loading = [MBProgressHUD showLoading];

    [TTMRealisticModel addChairImageWithModel:model complete:^(id result) {
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
    [TTMRealisticModel deleteChairImageWithModel:model complete:^(id result) {
        [loading hide:YES];
        if ([result isKindOfClass:[NSString class]]) {
            [MBProgressHUD showToastWithText:result];
        } else {
            [weakSelf queryImages];
        }
    }];
}


/**
 *  查询椅位信息
 */
- (void)queryChairSetting {
    __weak __typeof(&*self) weakSelf = self;
    [TTMChairSettingModel queryDetailWithID:self.chairModel.seat_id complete:^(id result) {
        if ([result isKindOfClass:[NSString class]]) {
            [MBProgressHUD showToastWithText:result];
        } else {
            weakSelf.settingModel = result;
            [weakSelf queryImages];
        }
    }];
}

/**
 *  保存椅位配置信息
 */
- (void)saveCharSetting {
    TTMChairSettingModel *model = [TTMChairSettingModel new];
    model.seat_id = self.chairModel.seat_id;
    model.seat_brand = [self.chairSettingView.brandTextField.text trim];
    model.seat_desc = [self.chairSettingView.modelTextField.text trim];
    
    // 用水
    UIButton *water1 = self.chairSettingView.waterSelectView.buttonArray[0]; // 蒸馏水
    UIButton *water2 = self.chairSettingView.waterSelectView.buttonArray[1]; // 自来水
    UIButton *water3 = self.chairSettingView.waterSelectView.buttonArray[2]; // 可切换
    if (water3.isSelected) {
        model.seat_tapwater = YES;
        model.seat_distillwater = YES;
    } else {
        model.seat_tapwater = water2.isSelected;
        model.seat_distillwater = water1.isSelected;
    }
    
    // 超声功率
    UIButton *voice = self.chairSettingView.voiceSelectView.buttonArray[0]; // 可洗牙
    model.seat_ultrasound = !voice.isSelected;
    
    // 光固灯
    UIButton *light = self.chairSettingView.configSelectView.buttonArray[0]; // 牙椅自带
    model.seat_light = !light.isSelected;
    
    // 收费
    model.seat_price = [self.chairSettingView.chairTextField.text floatValue];
    model.assistant_price = [self.chairSettingView.assistTextField.text floatValue];
    
    
    MBProgressHUD *loading = [MBProgressHUD showLoading];
    [TTMChairSettingModel updateWithModel:model complete:^(id result) {
        [loading hide:YES];
        if ([result isKindOfClass:[NSString class]]) {
            [MBProgressHUD showToastWithText:result];
        } else {
            [MBProgressHUD showToastWithText:@"保存成功"];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
