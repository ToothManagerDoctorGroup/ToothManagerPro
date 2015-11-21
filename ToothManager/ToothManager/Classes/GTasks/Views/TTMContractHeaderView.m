//
//  TTMContractHeaderView.m
//  ToothManager
//

#import "TTMContractHeaderView.h"
#import "TTMGTaskCellModel.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+TTMAddtion.h"

#define kGreenViewH 40.f
#define kMargin 10.f
#define kStarMargin 3.f
#define kNameFontSize 18
#define kFontSize 14
#define kImageViewW 60.f
#define kImageViewH kImageViewW
#define kNameLabelW 70.f
#define kPositionLabelW 100.f
#define kHospitalLabelW 100.f
#define kLabelH 30.f
#define kInfoViewH 40.f
#define kInfoSubViewW (ScreenWidth / 3)
#define kSeparatorY 5.f
#define kSeparatorH 30.f
#define kStartW 13.f

@interface TTMContractHeaderView ()

@property (nonatomic, weak) UIView *greenView; // 蓝色抬头
@property (nonatomic, weak) UIImageView *headImageView; // 头像
@property (nonatomic, weak) UILabel *nameLabel; // 医生名
@property (nonatomic, weak) UILabel *positionLabel; // 职位
@property (nonatomic, weak) UILabel *hospitalLabel; // 医院

@property (nonatomic, weak) UIView *infoView; // 星星，科目，种植数量

@property (nonatomic, weak) UIView *starView; // 星星视图
@property (nonatomic, weak) UIView *v1SeparatorView; // 垂直线1
@property (nonatomic, weak) UILabel *departmentLabel; // 科室
@property (nonatomic, weak) UIView *v2SeparatorView; // 垂直线2
@property (nonatomic, weak) UILabel *numLabel; // 种植数量

@end

@implementation TTMContractHeaderView

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
    self.backgroundColor = [UIColor clearColor];
    self.showInfoView = YES;
    
    UIView *greenView = [[UIView alloc] init];
    greenView.backgroundColor = MainColor;
    [self addSubview:greenView];
    self.greenView = greenView;
    
    UIImageView *headImageView = [[UIImageView alloc] init];
    [self addSubview:headImageView];
    self.headImageView = headImageView;
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont systemFontOfSize:kNameFontSize];
    [self addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    UILabel *positionLabel = [[UILabel alloc] init];
    positionLabel.font = [UIFont systemFontOfSize:kFontSize];
    positionLabel.textColor = MainColor;
    [self addSubview:positionLabel];
    self.positionLabel = positionLabel;
    
    UILabel *hospitalLabel = [[UILabel alloc] init];
    hospitalLabel.font = [UIFont systemFontOfSize:kFontSize];
    hospitalLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:hospitalLabel];
    self.hospitalLabel = hospitalLabel;
    
    UIView *infoView = [[UIView alloc] init];
    infoView.layer.borderColor = TableViewCellSeparatorColor.CGColor;
    infoView.layer.borderWidth = TableViewCellSeparatorHeight;
    [self addSubview:infoView];
    self.infoView = infoView;
    
    UIView *starView = [[UIView alloc] init];
    [infoView addSubview:starView];
    self.starView = starView;
    
    UIView *v1SeparatorView = [[UIView alloc] init];
    v1SeparatorView.backgroundColor = TableViewCellSeparatorColor;
    [infoView addSubview:v1SeparatorView];
    self.v1SeparatorView = v1SeparatorView;
    
    UILabel *departmentLabel = [[UILabel alloc] init];
    departmentLabel.font = [UIFont systemFontOfSize:kFontSize];
    departmentLabel.textAlignment = NSTextAlignmentCenter;
    [infoView addSubview:departmentLabel];
    self.departmentLabel = departmentLabel;
    
    UIView *v2SeparatorView = [[UIView alloc] init];
    v2SeparatorView.backgroundColor = TableViewCellSeparatorColor;
    [infoView addSubview:v2SeparatorView];
    self.v2SeparatorView = v2SeparatorView;
    
    UILabel *numLabel = [[UILabel alloc] init];
    numLabel.font = [UIFont systemFontOfSize:kFontSize];
    numLabel.textAlignment = NSTextAlignmentCenter;
    [infoView addSubview:numLabel];
    self.numLabel = numLabel;
    
    [self setupLayout];
}
/**
 *  设置布局
 */
- (void)setupLayout {
    self.greenView.frame = CGRectMake(0, 0, ScreenWidth, kGreenViewH);
    self.headImageView.center = CGPointMake(ScreenWidth / 2, self.greenView.bottom);
    self.headImageView.size = CGSizeMake(kImageViewW, kImageViewH);
    
    CGFloat nameLabelX = self.headImageView.center.x - kNameLabelW;
    CGFloat nameLabelY = self.headImageView.bottom + kMargin;
    self.nameLabel.frame = CGRectMake(nameLabelX, nameLabelY, kNameLabelW, kLabelH);
    
    CGFloat positionLabelX = self.headImageView.center.x;
    self.positionLabel.frame = CGRectMake(positionLabelX, nameLabelY, kPositionLabelW, kLabelH);
    
    self.hospitalLabel.center = CGPointMake(self.headImageView.center.x, 0);
    self.hospitalLabel.top = self.nameLabel.bottom;
    self.hospitalLabel.size = CGSizeMake(kNameLabelW + kPositionLabelW, kLabelH);
    
    self.infoView.frame = CGRectMake(0, self.hospitalLabel.bottom + kMargin, ScreenWidth, kInfoViewH);
    
    self.departmentLabel.frame = CGRectMake(kInfoSubViewW, 0, kInfoSubViewW, kInfoViewH);
    self.numLabel.frame = CGRectMake(2 * kInfoSubViewW, 0, kInfoSubViewW, kInfoViewH);
    
    CGFloat v1X = kInfoSubViewW - 1;
    CGFloat v2X = 2 * kInfoSubViewW - TableViewCellSeparatorHeight;
    
    self.v1SeparatorView.frame = CGRectMake(v1X, kSeparatorY, TableViewCellSeparatorHeight, kSeparatorH);
    self.v2SeparatorView.frame = CGRectMake(v2X, kSeparatorY, TableViewCellSeparatorHeight, kSeparatorH);
    
    // 设置尺寸
    if (self.showInfoView) {
        self.size = CGSizeMake(ScreenWidth, self.infoView.bottom);
    } else {
        self.size = CGSizeMake(ScreenWidth, self.hospitalLabel.bottom + kMargin);
    }
}

/**
 *  设置内容
 *
 *  @param value value description
 */
- (void)setValue:(TTMGTaskCellModel *)value {
    [self.headImageView circleImageViewWithCornRaduis:kImageViewW / 2];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:value.doctor_image]
                          placeholderImage:[UIImage imageNamed:@"placeholder_head"]];
    
    self.nameLabel.text = value.doctor_name;
    self.positionLabel.text = [NSString stringWithFormat:@"(%@)", value.doctor_position];
    self.hospitalLabel.text = value.doctor_hospital;
    [self setupStarViewWithNum:value.star_level];
    self.departmentLabel.text = value.doctor_dept;
    self.numLabel.text = [NSString stringWithFormat:@"种植数量：%@", @(value.planting_quantity)];
}
/**
 *  加载星级数
 *
 *  @param num 数量
 */
- (void)setupStarViewWithNum:(NSUInteger)num {
    for (NSUInteger i = 0; i < num; i ++) {
        UIImageView *starImageView = [[UIImageView alloc] init];
        starImageView.image = [UIImage imageNamed:@"gtask_star"];
        starImageView.size = CGSizeMake(kStartW, kStartW);
        starImageView.origin = CGPointMake(i * (kStartW + kStarMargin), (kInfoViewH - kStartW) / 2);
        [self.starView addSubview:starImageView];
    }
    CGFloat starViewW = num * (kStartW + kStarMargin);
    self.starView.width = starViewW;
    self.starView.left = (kInfoSubViewW - starViewW) / 2;
}

- (void)setShowInfoView:(BOOL)showInfoView {
    _showInfoView = showInfoView;
    if (showInfoView) {
        self.infoView.hidden = NO;
    } else {
        self.infoView.hidden = YES;
    }
    [self setupLayout];
}
@end
