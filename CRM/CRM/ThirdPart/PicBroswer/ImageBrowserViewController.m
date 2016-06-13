//
//  ImageBrowserViewController.m
//  CRM
//
//  Created by TimTiger on 2/1/15.
//  Copyright (c) 2015 TimTiger. All rights reserved.
//

#import "ImageBrowserViewController.h"
#import "DBManager+Patients.h"
#import "DBManager+AutoSync.h"
#import "JSONKit.h"
#import "MJExtension.h"

@interface ImageBrowserViewController () <PicBrowserViewDelegate>
@property (nonatomic,retain) PicBrowserView *browserView;
@property (nonatomic,assign) NSInteger currentIndex;
@end

@implementation ImageBrowserViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil  {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _imageArray = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    if (_browserView == nil) {
        _browserView = [[[NSBundle mainBundle] loadNibNamed:@"PicBrowserView" owner:nil options:nil] objectAtIndex:0];
        if (self.isEditMedicalCase) {
            NSMutableArray *mArray = [_browserView.bottomBar.items mutableCopy];
            [mArray removeObject:_browserView.leftBar];
            [mArray removeObject:_browserView.mainCTButton];
            [_browserView.bottomBar setItems:mArray animated:NO];
        }
        
        _browserView.frame = self.view.bounds;
        _browserView.delegate = self;
        self.currentIndex = 0;
        [self.view addSubview:_browserView];
    }
}

- (void)refreshView {
    [_browserView setCenterImage:[self.imageArray firstObject]];
    _browserView.scrollView.scrollEnabled = NO;
    _browserView.pagedownButton.enabled   = NO;
    _browserView.pageupButton.enabled     = NO;
    self.currentIndex = 0;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_browserView setupImageViews:self.imageArray.count];
    
    self.currentIndex = self.currentPage;
    [self setUpDataWithCurrentIndex:self.currentIndex];
    
}

#pragma mark - 加载数据
- (void)setUpDataWithCurrentIndex:(NSInteger)index{
    //获取当前需要显示的图片的位置
    [_browserView setCenterImage:[self.imageArray objectAtIndex:index]];
    if (self.imageArray.count > 1) {
        //判断当前图片数组的个数
        if (index == self.imageArray.count - 1) {
            [_browserView setLeftImage:[self.imageArray objectAtIndex:index - 1]];
            [_browserView setRightImage:[self.imageArray firstObject]];
        }else if (index == 0){
            [_browserView setLeftImage:[self.imageArray lastObject]];
            [_browserView setRightImage:[self.imageArray objectAtIndex:index + 1]];
        }else{
            [_browserView setLeftImage:[self.imageArray objectAtIndex:index - 1]];
            [_browserView setRightImage:[self.imageArray objectAtIndex:index + 1]];
        }
    }else{
        _browserView.scrollView.scrollEnabled = NO;
        _browserView.pagedownButton.enabled   = NO;
        _browserView.pageupButton.enabled     = NO;
    }
    
    //设置当前的索引位置
    _browserView.indexLabel.text = [NSString stringWithFormat:@"%ld/%lu",(long)index  + 1,(unsigned long)self.imageArray.count];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

#pragma mark - PicBrowserView Delegate
- (void)dismissAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(picBrowserViewController:didFinishBrowseImages:)]) {
        [self.delegate picBrowserViewController:self didFinishBrowseImages:self.imageArray];
    }
}

- (void)saveImageAction:(id)sender{
    
    //保存到相册
    BrowserPicture *pic = [self.imageArray objectAtIndex:self.currentIndex];
    UIImage *resultImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:pic.url];
    if (resultImage != nil) {
        UIImageWriteToSavedPhotosAlbum(resultImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }else{
        [SVProgressHUD showImage:nil status:@"当前图片不存在"];
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error != NULL) {
        [SVProgressHUD showImage:nil status:@"保存失败"];
    }else{
        [SVProgressHUD showImage:nil status:@"已保存到手机相册"];
    }
}

- (void)pageupAction:(id)sender {
    NSInteger center = self.currentIndex-1;
    NSInteger left = center-1;
    NSInteger right = self.currentIndex;
    if (center < 0) {
        self.currentIndex = self.imageArray.count-1;
    } else {
        self.currentIndex = center;
    }
    [_browserView setCenterImage:[self.imageArray objectAtIndex:self.currentIndex]];
    if (left < 0) {
        left = self.imageArray.count+left;
    }
    [_browserView setLeftImage:[self.imageArray objectAtIndex:left]];
    if (right < 0) {
        right = self.imageArray.count+right;
    }
    [_browserView setRightImage:[self.imageArray objectAtIndex:right]];
    
    _browserView.indexLabel.text = [NSString stringWithFormat:@"%ld/%lu",(long)self.currentIndex + 1,(unsigned long)self.imageArray.count];
}

- (void)pagedownAction:(id)sender {
    NSInteger center = self.currentIndex + 1;
    NSInteger left = self.currentIndex;
    NSInteger right = center+1;
    if (center >= self.imageArray.count) {
        self.currentIndex = 0;
        
    } else {
        self.currentIndex = center;
    }
    [_browserView setCenterImage:[self.imageArray objectAtIndex:self.currentIndex]];
    if (left >= self.imageArray.count) {
        left = left - self.imageArray.count;
    }
    [_browserView setLeftImage:[self.imageArray objectAtIndex:left]];
    if (right >= self.imageArray.count) {
        right = right-self.imageArray.count;
    }
    [_browserView setRightImage:[self.imageArray objectAtIndex:right]];
    
    _browserView.indexLabel.text = [NSString stringWithFormat:@"%ld/%lu",(long)self.currentIndex + 1,(unsigned long)self.imageArray.count];
}

- (void)deleteAction:(id)sender {
    __weak typeof(self) weakSelf = self;
    TimAlertView *alertView = [[TimAlertView alloc] initWithTitle:@"确认删除此CT片？" message:nil cancelHandler:^{
    } comfirmButtonHandlder:^{
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(picBrowserViewController:didDeleteBrowserPicture:)]) {
            [weakSelf.delegate picBrowserViewController:weakSelf didDeleteBrowserPicture:[weakSelf.imageArray objectAtIndex:weakSelf.currentIndex]];
        }
        [weakSelf.imageArray removeObjectAtIndex:weakSelf.currentIndex];
        if (weakSelf.imageArray.count < 1) {
            [weakSelf dismissAction:nil];
        } else if (weakSelf.imageArray.count == 1) {
            [weakSelf refreshView];
        } else {
            if (self.currentIndex == self.imageArray.count) {
                self.currentIndex = 0;
                [self setUpDataWithCurrentIndex:self.currentIndex];
            }else{
                [self pagedownAction:nil];
            }
        }
        _browserView.indexLabel.text = [NSString stringWithFormat:@"%ld/%lu",(long)self.currentIndex  + 1,(unsigned long)self.imageArray.count];
    }];
    [alertView show];
}

- (void)mainImgAction:(id)sender{
    //获取当前显示的CTLib
    BrowserPicture *currentPic = [self.imageArray objectAtIndex:self.currentIndex];
    CTLib *ct = [currentPic ctLib];
    //将当前照片设置为主照片
    ct.is_main = @"1";
    //获取patient_id
    MedicalCase *mCase = [[DBManager shareInstance] getMedicalCaseWithCaseId:ct.case_id];
    if([[DBManager shareInstance] setUpMainCT:ct patientId:mCase.patient_id]){
        //将数组中的照片都设置为0
        for (BrowserPicture *bPic in self.imageArray) {
            if (![bPic.keyidStr isEqualToString:currentPic.keyidStr]) {
                bPic.ctLib.is_main = @"0";
            }
        }
    }
    [SVProgressHUD showSuccessWithStatus:@"来电提醒图片设置成功"];
    //更新当前的视图
    [_browserView setCenterImage:[self.imageArray objectAtIndex:self.currentIndex]];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(picBrowserViewController:didSetMainImage:)]) {
        [self.delegate picBrowserViewController:self didSetMainImage:currentPic];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
