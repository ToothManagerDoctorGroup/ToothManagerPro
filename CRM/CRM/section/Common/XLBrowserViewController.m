//
//  XLBrowserViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/5/27.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLBrowserViewController.h"

@interface XLBrowserViewController () <XLImageBrowserViewDelegate>
@property (nonatomic,retain) XLImageBrowserView *browserView;
@property (nonatomic,assign) NSInteger currentIndex;
@end

@implementation XLBrowserViewController

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
        _browserView = [[[NSBundle mainBundle] loadNibNamed:@"XLImageBrowserView" owner:nil options:nil] objectAtIndex:0];
        _browserView.frame = self.view.bounds;
        _browserView.delegate = self;
        self.currentIndex = 0;
        [self.view addSubview:_browserView];
    }
}

- (void)refreshView {
    [_browserView setCenterImage:[self.imageArray firstObject]];
    _browserView.scrollView.scrollEnabled = NO;
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(picBrowserViewController:didDeleteBrowserPicture:)]) {
        [self.delegate picBrowserViewController:self didDeleteBrowserPicture:[self.imageArray objectAtIndex:self.currentIndex]];
    }
    [self.imageArray removeObjectAtIndex:self.currentIndex];
    if (self.imageArray.count < 1) {
        [self dismissAction:nil];
    } else if (self.imageArray.count == 1) {
        [self refreshView];
    } else {
        if (self.currentIndex == self.imageArray.count) {
            self.currentIndex = 0;
            [self setUpDataWithCurrentIndex:self.currentIndex];
        }else{
            [self pagedownAction:nil];
        }
    }
    _browserView.indexLabel.text = [NSString stringWithFormat:@"%ld/%lu",(long)self.currentIndex  + 1,(unsigned long)self.imageArray.count];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
