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
    //获取当前需要显示的图片的位置
    [_browserView setCenterImage:[self.imageArray objectAtIndex:self.currentPage]];
    if (self.imageArray.count > 1) {
        //判断当前图片数组的个数
        if (self.currentPage == self.imageArray.count - 1) {
            [_browserView setLeftImage:[self.imageArray objectAtIndex:self.currentPage - 1]];
            [_browserView setRightImage:[self.imageArray firstObject]];
        }else if (self.currentPage == 0){
            [_browserView setLeftImage:[self.imageArray lastObject]];
            [_browserView setRightImage:[self.imageArray objectAtIndex:self.currentPage + 1]];
        }else{
            [_browserView setLeftImage:[self.imageArray objectAtIndex:self.currentPage - 1]];
            [_browserView setRightImage:[self.imageArray objectAtIndex:self.currentPage + 1]];
        }
    }else{
        _browserView.scrollView.scrollEnabled = NO;
        _browserView.pagedownButton.enabled   = NO;
        _browserView.pageupButton.enabled     = NO;
    }
    
    //设置当前的索引位置
    _browserView.indexLabel.text = [NSString stringWithFormat:@"%ld/%lu",(long)self.currentIndex  + 1,(unsigned long)self.imageArray.count];
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
            [_browserView pagedownAction:nil];
        }
        _browserView.indexLabel.text = [NSString stringWithFormat:@"%ld/%lu",(long)self.currentIndex  + 1,(unsigned long)self.imageArray.count];
    }];
    [alertView show];
}

- (void)mainImgAction:(id)sender{
    __weak typeof(self) weakSelf = self;
    TimAlertView *alertView = [[TimAlertView alloc] initWithTitle:@"是否将此CT片设置为来电提醒图片?" message:nil cancelHandler:^{
    } comfirmButtonHandlder:^{
        //获取当前显示的CTLib
        BrowserPicture *currentPic = [weakSelf.imageArray objectAtIndex:weakSelf.currentIndex];
        CTLib *ct = [currentPic ctLib];
        //将当前照片设置为主照片
        ct.is_main = @"1";
        if([[DBManager shareInstance] setUpMainCT:ct]){
            //将数组中的照片都设置为0
            for (BrowserPicture *bPic in weakSelf.imageArray) {
                if (![bPic.keyidStr isEqualToString:currentPic.keyidStr]) {
                    bPic.ctLib.is_main = @"0";
                }
            }
        }
        //更新当前的视图
        [_browserView setCenterImage:[self.imageArray objectAtIndex:self.currentIndex]];
        
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(picBrowserViewController:didSetMainImage:)]) {
            [weakSelf.delegate picBrowserViewController:weakSelf didSetMainImage:currentPic];
        }
    }];
    [alertView show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
