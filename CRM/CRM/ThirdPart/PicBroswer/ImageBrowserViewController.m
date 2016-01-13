//
//  ImageBrowserViewController.m
//  CRM
//
//  Created by TimTiger on 2/1/15.
//  Copyright (c) 2015 TimTiger. All rights reserved.
//

#import "ImageBrowserViewController.h"

@interface ImageBrowserViewController () <PicBrowserViewDelegate>
@property (nonatomic,retain) PicBrowserView *browserView;
@property (nonatomic) NSInteger currentIndex;
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
    [_browserView setLeftImage:[self.imageArray lastObject]];
    [_browserView setCenterImage:[self.imageArray firstObject]];
    if (self.imageArray.count > 1)  {
        [_browserView setRightImage:[self.imageArray objectAtIndex:1]];
    } else {
        _browserView.scrollView.scrollEnabled = NO;
        _browserView.pagedownButton.enabled   = NO;
        _browserView.pageupButton.enabled     = NO;
    }
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
}

- (void)pagedownAction:(id)sender {
    NSInteger center = self.currentIndex+1;
    NSInteger left = self.currentIndex;
    NSInteger right = center+1;
    if (center >= self.imageArray.count) {
        self.currentIndex = 0;
    } else {
        self.currentIndex = center;
    }
    [_browserView setCenterImage:[self.imageArray objectAtIndex:self.currentIndex]];
    if (left >= self.imageArray.count) {
        left = left-self.imageArray.count;
    }
    [_browserView setLeftImage:[self.imageArray objectAtIndex:left]];
    if (right >= self.imageArray.count) {
        right = right-self.imageArray.count;
    }
    [_browserView setRightImage:[self.imageArray objectAtIndex:right]];
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
    }];
    [alertView show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
