//
//  TTMGTaskCell.m
//  ToothManager
//

#import "TTMGTaskCell.h"
#import "UIImageView+WebCache.h"
#import "TTMGTaskCellModel.h"
#import "UIImageView+TTMAddtion.h"

#define kMargin 10.f
#define kNameFontSize 18
#define kFontSize 14
#define kImageViewW 60.f
#define kImageViewH kImageViewW
#define kNameLabelW 70.f
#define kPositionLabelW 100.f
#define kHospitalLabelW 100.f
#define kLabelH 30.f
#define kCheckButtonW 70.f
#define kCheckButtonH 30.f
#define kBgViewH 80.f

@interface TTMGTaskCell ()

@property (nonatomic, weak) UIImageView *headImageView; // 头像
@property (nonatomic, weak) UILabel *nameLabel; // 医生名
@property (nonatomic, weak) UILabel *positionLabel; // 职位
@property (nonatomic, weak) UILabel *hospitalLabel; // 医院
@property (nonatomic, weak) UIButton *checkButton; // 处理签约按钮
@property (nonatomic, weak) UIView *bgView; // 背景视图
@end

@implementation TTMGTaskCell

+ (instancetype)taskCellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"CellID";
    TTMGTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[TTMGTaskCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}
/**
 *  加载视图
 */
- (void)setup {
    self.backgroundColor = [UIColor clearColor];
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bgView];
    self.bgView = bgView;
    
    UIImageView *headImageView = [[UIImageView alloc] init];
    [bgView addSubview:headImageView];
    self.headImageView = headImageView;
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont systemFontOfSize:kNameFontSize];
    [bgView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    UILabel *positionLabel = [[UILabel alloc] init];
    positionLabel.font = [UIFont systemFontOfSize:kFontSize];
    positionLabel.textColor = MainColor;
    [bgView addSubview:positionLabel];
    self.positionLabel = positionLabel;
    
    UILabel *hospitalLabel = [[UILabel alloc] init];
    hospitalLabel.font = [UIFont systemFontOfSize:kFontSize];
    [bgView addSubview:hospitalLabel];
    self.hospitalLabel = hospitalLabel;
    
    UIButton *checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [checkButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [checkButton setTitle:@"处理签约" forState:UIControlStateNormal];
    checkButton.titleLabel.font = [UIFont systemFontOfSize:kFontSize];
    [checkButton setBackgroundImage:[UIImage imageNamed:@"gtask_hand_button_bg"] forState:UIControlStateNormal];
    [checkButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:checkButton];
    self.checkButton = checkButton;
}
/**
 *  设置model
 *
 *  @param model model description
 */
- (void)setModel:(TTMGTaskCellModel *)model {
    _model = model;
    self.nameLabel.text = model.doctor_name;
    self.positionLabel.text = model.doctor_position;
    self.hospitalLabel.text = model.doctor_hospital;
    
    [self.headImageView circleImageViewWithCornRaduis:kImageViewW / 2];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.doctor_image]
                          placeholderImage:[UIImage imageNamed:@"placeholder_head"]];
    
    if (model.type == TTMGTaskCellModelTypeGTask) {
        if (model.currentStatus == 0) { // 待处理
            [self.checkButton setTitle:@"处理签约" forState:UIControlStateNormal];
            [self.checkButton setBackgroundImage:[UIImage imageNamed:@"gtask_hand_button_bg"]
                                        forState:UIControlStateNormal];
        } else {
            if (model.is_sign == 1) {
                [self.checkButton setTitle:@"已签约" forState:UIControlStateNormal];
                [self.checkButton setBackgroundImage:[UIImage imageNamed:@"gtask_hand_button_receive"]
                                            forState:UIControlStateNormal];
            } else if (model.is_sign == 2) {
                [self.checkButton setTitle:@"已拒绝" forState:UIControlStateNormal];
                [self.checkButton setBackgroundImage:[UIImage imageNamed:@"gtask_hand_button_refuse"]
                                            forState:UIControlStateNormal];
            }
        }
    } else if(model.type == TTMGTaskCellModelTypeDoctors) {
        [self.checkButton setTitle:@"拨打电话" forState:UIControlStateNormal];
    }
}
/**
 *  布局
 */
- (void)layoutSubviews {
    self.bgView.frame = CGRectMake(0, 0, ScreenWidth, kBgViewH);
    self.headImageView.frame = CGRectMake(kMargin, kMargin, kImageViewW, kImageViewH);
    self.nameLabel.frame = CGRectMake(self.headImageView.right + kMargin, kMargin, kNameLabelW, kLabelH);
    self.positionLabel.frame = CGRectMake(self.nameLabel.right + kMargin, kMargin, kPositionLabelW, kLabelH);
    self.hospitalLabel.frame = CGRectMake(self.headImageView.right + kMargin, self.nameLabel.bottom,
                                          kHospitalLabelW, kLabelH);
    self.checkButton.frame = CGRectMake(ScreenWidth - kMargin - kCheckButtonW, 2 * kMargin,
                                        kCheckButtonW, kCheckButtonH);
}
/**
 *  点击按钮事件
 *
 *  @param button button description
 */
- (void)buttonAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(gtaskCell:model:)]) {
        [self.delegate gtaskCell:self model:self.model];
    }
}
@end
