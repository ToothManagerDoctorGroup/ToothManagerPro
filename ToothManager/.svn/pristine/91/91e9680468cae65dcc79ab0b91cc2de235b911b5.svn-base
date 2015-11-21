//
//  THCUserGuideController.m
//  THCFramework
//

#import "TTMUserGuideController.h"
#import "UIImage+TTMAddtion.h"

// PageControl的默认高度
#define kUserGuideControllerPageControlHeight 20.0f

// pageControl的默认Y值的比例
#define kUserGuideControllerRadio 0.9f
// 两秒轮巡
#define kTime 2

@interface TTMUserGuideController () <UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, weak) UIPageControl *pageControl;

@property (nonatomic, strong) NSTimer *timer; // 定时滚动

@end

@implementation TTMUserGuideController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGBColor(240.0, 240.0, 240.0);
    
    // 隐藏状态栏
    [UIApplication sharedApplication].statusBarHidden = YES;

    [self setupScrollView];
    [self setupPageControl];
}

/**
 *  初始化ScrollView
 */
- (void)setupScrollView {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = [UIScreen mainScreen].bounds;
    scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delaysContentTouches = NO;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
}

/**
 *  初始化PageControl
 */
- (void)setupPageControl {
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.frame = CGRectMake(0,
                                   self.view.bounds.size.height * kUserGuideControllerRadio,
                                   self.view.bounds.size.width,
                                   kUserGuideControllerPageControlHeight);
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    pageControl.tintColor = [UIColor redColor];
    pageControl.currentPage = 0;
    [self.view addSubview:pageControl];
    self.pageControl = pageControl;
    self.pageControl.hidden = !self.showIndicator;
}

- (void)setImages:(NSArray *)images {
    if (images && images.count > 0) {
        _images = images;
        NSInteger count = _images.count;
        
        CGFloat imageViewY = 0;
        CGFloat imageViewWidth = self.view.bounds.size.width;
        CGFloat imageViewHeight = self.view.bounds.size.height;
        for (NSUInteger i = 0; i < count; i++) {
            UIImageView *imageView = [[UIImageView alloc] init];
            CGFloat imageViewX = i * imageViewWidth;
            imageView.frame = CGRectMake(imageViewX, imageViewY, imageViewWidth, imageViewHeight);
            imageView.image = [UIImage imageDeviceVersionWithName:_images[i]];
            
            // 如果是最后一张页面，添加进入主页的按钮
            if (i == (count - 1)) {
                imageView.userInteractionEnabled = YES;
                CGFloat intoButtonW = 200.0f;
                CGFloat intoButtonH = 45.0f;
                CGFloat intoButtonX = (imageViewWidth - intoButtonW) * 0.5;
                CGFloat intoButtonY = imageViewHeight * 0.82;
                UIButton *intoButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [intoButton setBackgroundImage:[UIImage resizedImageWithName:@"guide_button_normal"]
                                      forState:UIControlStateNormal];
                [intoButton setBackgroundImage:[UIImage resizedImageWithName:@"guide_button_pressed"]
                                      forState:UIControlStateSelected];
                [intoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [intoButton setTitleColor:RGBColor(25.0f, 83.0f, 151.0f) forState:UIControlStateSelected];
                [intoButton setTitle:@"立即体验" forState:UIControlStateNormal];
                intoButton.frame = CGRectMake(intoButtonX, intoButtonY, intoButtonW, intoButtonH);
                [intoButton addTarget:self action:@selector(intoButtonAction:)
                     forControlEvents:UIControlEventTouchUpInside];
                [imageView addSubview:intoButton];
            }
            [self.scrollView addSubview:imageView];
        }
        
        self.pageControl.numberOfPages = count;
        self.scrollView.contentSize = CGSizeMake(imageViewWidth * count, imageViewHeight);
        
        [self setupTimer];
    }
}

- (void)setShowIndicator:(BOOL)showIndicator {
    _showIndicator = showIndicator;
    self.pageControl.hidden = !_showIndicator;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offset = scrollView.contentOffset;
    self.pageControl.currentPage = (offset.x + scrollView.frame.size.width * 0.5) / scrollView.frame.size.width;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self removeTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self setupTimer];
}

- (void)intoButtonAction:(UIButton *)button {
    // 显示状态栏
    [UIApplication sharedApplication].statusBarHidden = NO;
    if (self.forwardController) {
        self.view.window.rootViewController = self.forwardController;
    }
}
/**
 *  启动定时器
 */
- (void)setupTimer {
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:kTime target:self
                                                    selector:@selector(scrollToNext)
                                                    userInfo:nil
                                                     repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

- (void)removeTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

/**
 *  滚动到下一张
 */
- (void)scrollToNext {
    CGFloat lastX = self.scrollView.contentOffset.x;
    if (lastX == ((_images.count - 1) * ScreenWidth)) {
        [self.timer invalidate];
        self.timer = nil;
        return;
    }
    [self.scrollView setContentOffset:CGPointMake(lastX + ScreenWidth, 0) animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
