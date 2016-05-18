//
//  TTMScheduleHeaderView.m
//  ToothManager
//

#import "TTMScheduleHeaderView.h"
#import "TTMBeforeButton.h"
#import "TTMAfterButton.h"
#import "TTMChairNoScrollView.h"
#import "TTMChairItemButton.h"
#import "TTMChairModel.h"

#define kMargin 10.f
#define kDateControlViewH 65.f
#define kFontSize 14
#define kLabelHeight 20.f
#define kSemicircleW 110.f //半圆的宽度
#define kButtonY 30.f
#define kButtonW ((ScreenWidth - kSemicircleW - 4 * kMargin) / 2)
#define kButtonH 30.f
#define kScrollViewH 44.f

@interface TTMScheduleHeaderView ()<TTMChairNoScrollViewDelegate>

@property (nonatomic, weak) UILabel *dateLabel; // 日期
@property (nonatomic, weak) UILabel *weekLabel; // 星期
@property (nonatomic, weak) TTMChairNoScrollView *chairNoScrollView; // 滚动椅位

@end

@implementation TTMScheduleHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}
/**
 *  加载视图
 */
- (void)setup {
    // 广告图
//    UIImage *adImage = [UIImage imageNamed:@"schedule_ad"];
//    UIImageView *adImageView = [[UIImageView alloc] initWithImage:adImage];
//    CGFloat imageHeight = (adImage.size.height / adImage.size.width) * ScreenWidth;
//    adImageView.frame = CGRectMake(0, 0, ScreenWidth, imageHeight);
//    [self addSubview:adImageView];
    
    // 日期控制视图
    UIView *dateControlView = [[UIView alloc] init];
    dateControlView.backgroundColor = [UIColor whiteColor];
    dateControlView.frame = CGRectMake(0, 0, ScreenWidth, kDateControlViewH);
    [self addSubview:dateControlView];
    
    // 中间半圆视图
    UIImage *semicircleImage = [UIImage imageNamed:@"schedule_semicircle"];
    UIImageView *semicircleImageView = [[UIImageView alloc] initWithImage:semicircleImage];
    semicircleImageView.size = semicircleImage.size;
    semicircleImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapSemicircle = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSemicircle:)];
    [semicircleImageView addGestureRecognizer:tapSemicircle];
    semicircleImageView.center = CGPointMake(ScreenWidth / 2, kDateControlViewH - (semicircleImage.size.height / 2));
    [dateControlView addSubview:semicircleImageView];
    
    // 日期
    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.font = [UIFont systemFontOfSize:kFontSize];
    dateLabel.textColor = [UIColor whiteColor];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    dateLabel.frame = CGRectMake(semicircleImageView.left, semicircleImageView.top + 2 * kMargin,
                                 semicircleImageView.width, kLabelHeight);
    [dateControlView addSubview:dateLabel];
    self.dateLabel = dateLabel;
    // 星期
    UILabel *weekLabel = [[UILabel alloc] init];
    weekLabel.font = [UIFont systemFontOfSize:kFontSize];
    weekLabel.textColor = [UIColor whiteColor];
    weekLabel.textAlignment = NSTextAlignmentCenter;
    weekLabel.frame = CGRectMake(semicircleImageView.left, dateLabel.bottom,
                                 semicircleImageView.width, kLabelHeight);
    [dateControlView addSubview:weekLabel];
    self.weekLabel = weekLabel;
    
    // 前一天
    TTMBeforeButton *beforeButon = [[TTMBeforeButton alloc] initWithFrame:
                                    CGRectMake(kMargin, kButtonY, kButtonW, kButtonH)];
    beforeButon.tag = 0;
    [beforeButon addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [dateControlView addSubview:beforeButon];
    
    // 后一天
    TTMAfterButton *afterButton = [[TTMAfterButton alloc] initWithFrame:
                                   CGRectMake(semicircleImageView.right + kMargin, kButtonY, kButtonW, kButtonH)];
    afterButton.tag = 1;
    [afterButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [dateControlView addSubview:afterButton];
    
    // 椅号
    TTMChairNoScrollView *chairNoScrollView = [[TTMChairNoScrollView alloc] init];
    chairNoScrollView.frame = CGRectMake(0, dateControlView.bottom + kMargin, ScreenWidth, kScrollViewH);
    chairNoScrollView.delegate = self;
    [self addSubview:chairNoScrollView];
    self.chairNoScrollView = chairNoScrollView;
    
    self.height = chairNoScrollView.bottom;
    self.currentDate = [NSDate date];
    [self queryChairsData];
}

/**
 *  设置日期
 *
 *  @param currentDate 当前日期
 */
- (void)setCurrentDate:(NSDate *)currentDate {
    _currentDate = currentDate;
    self.dateLabel.text = [currentDate fs_stringWithFormat:@"yyyy-MM-dd"];
    self.weekLabel.text = [currentDate fs_stringWithFormat:@"EEEE"];
}

/**
 *  点击日期
 *
 *  @param button 按钮
 */
- (void)buttonAction:(UIButton *)button {
    NSDate *changeToDate = nil;
    if (button.tag == 0) {
        changeToDate = [NSDate dateWithTimeInterval:- 60 * 60 *24 sinceDate:self.currentDate];
    } else {
        changeToDate = [NSDate dateWithTimeInterval:60 * 60 *24 sinceDate:self.currentDate];
    }
    self.currentDate = changeToDate;
    if ([self.delegate respondsToSelector:@selector(headerView:changeToDate:)]) {
        [self.delegate headerView:self changeToDate:changeToDate];
    }
}

/**
 *  查询椅位信息
 */
- (void)queryChairsData {
    __weak __typeof(&*self) weakSelf = self;
    [TTMChairModel queryChairsWithComplete:^(id result) {
        if ([result isKindOfClass:[NSString class]]) {
            [MBProgressHUD showToastWithText:result];
        } else {
            weakSelf.chairNoScrollView.chairNoArray = result;
        }
    }];
}

/**
 *  响应点击椅位按钮事件
 *
 *  @param scrollView 椅位滚动视图
 *  @param item       选中项
 */
- (void)chairNoScrollView:(TTMChairNoScrollView *)scrollView clickedItem:(TTMChairItemButton *)item {
    if ([self.delegate respondsToSelector:@selector(headerView:changeToChair:)]) {
        [self.delegate headerView:self changeToChair:item.chairInfo];
    }
}

/**
 *  点击半圆
 *
 *  @param getsture 手势
 */
- (void)tapSemicircle:(UITapGestureRecognizer *)getsture {
    if ([self.delegate respondsToSelector:@selector(clickSemicircleWithHeaderView:)]) {
        [self.delegate clickSemicircleWithHeaderView:self];
    }
}
@end
