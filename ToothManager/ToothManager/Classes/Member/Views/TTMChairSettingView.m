

#import "TTMChairSettingView.h"

#define kFont 14

@interface TTMChairSettingView ()

@property (nonatomic, weak)   UILabel *priceTitleLabel; // 收费标准

@property (nonatomic, weak)   UILabel *photoTitleLabel; // 牙椅照片


@end

@implementation TTMChairSettingView

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

- (void)setup {
    
    TTMChairSettingNormalTextField *brandTextField = [[TTMChairSettingNormalTextField alloc] initWithTitle:@"品牌:"];
    [self addSubview:brandTextField];
    self.brandTextField = brandTextField;
    
    TTMChairSettingNormalTextField *modelTextField = [[TTMChairSettingNormalTextField alloc] initWithTitle:@"型号:"];
    [self addSubview:modelTextField];
    self.modelTextField = modelTextField;
    
    TTMChairSettingSelectView *waterSelectView = [[TTMChairSettingSelectView alloc] initWithTitle:@"用水:"];
    waterSelectView.options = @[@"蒸馏水", @"自来水", @"蒸馏水/自来水可切换"];
    [self addSubview:waterSelectView];
    self.waterSelectView = waterSelectView;
    
    TTMChairSettingSelectView *voiceSelectView = [[TTMChairSettingSelectView alloc] initWithTitle:@"超声功率:"];
    voiceSelectView.options = @[@"可洗牙", @"可切割牙体组织"];
    [self addSubview:voiceSelectView];
    self.voiceSelectView = voiceSelectView;
    
    TTMChairSettingSelectView *configSelectView = [[TTMChairSettingSelectView alloc] initWithTitle:@"光固灯:"];
    configSelectView.options = @[@"牙椅自带", @"可移动灯"];
    [self addSubview:configSelectView];
    self.configSelectView = configSelectView;
    
    UILabel *priceTitleLabel = [UILabel new];
    priceTitleLabel.font = [UIFont systemFontOfSize:kFont];
    priceTitleLabel.text = @"收费标准";
    [self addSubview:priceTitleLabel];
    self.priceTitleLabel = priceTitleLabel;
    
    TTMChairSettingUnitTextField *chairTextField = [[TTMChairSettingUnitTextField alloc] initWithTitle:@"椅位:"];
    chairTextField.unitText = @"元/小时";
    [self addSubview:chairTextField];
    self.chairTextField = chairTextField;
    
    TTMChairSettingUnitTextField *assistTextField = [[TTMChairSettingUnitTextField alloc] initWithTitle:@"助理:"];
    assistTextField.unitText = @"元/小时";
    [self addSubview:assistTextField];
    self.assistTextField = assistTextField;
    
    UILabel *photoTitleLabel = [UILabel new];
    photoTitleLabel.font = [UIFont systemFontOfSize:kFont];
    photoTitleLabel.text = @"牙椅照片";
    [self addSubview:photoTitleLabel];
    self.photoTitleLabel = photoTitleLabel;
    
    TTMAddImageView *addImageView = [TTMAddImageView new];
    [self addSubview:addImageView];
    self.addImageView = addImageView;
    
    
    self.brandTextField.top = 0;
    self.modelTextField.top = self.brandTextField.bottom;
    self.waterSelectView.top = self.modelTextField.bottom;
    self.voiceSelectView.top = self.waterSelectView.bottom;
    self.configSelectView.top = self.voiceSelectView.bottom;
    
    CGFloat labelH = 40.f;
    CGFloat marign = 10.f;
    self.priceTitleLabel.frame = CGRectMake(marign, self.configSelectView.bottom, ScreenWidth - marign, labelH);
    
    self.chairTextField.top = self.priceTitleLabel.bottom;
    self.assistTextField.top = self.chairTextField.bottom;
    
    self.photoTitleLabel.frame = CGRectMake(marign, self.assistTextField.bottom, ScreenWidth - marign, labelH);
    self.addImageView.frame = CGRectMake(0, self.photoTitleLabel.bottom, ScreenWidth, 300);
    
    if (self.addImageView.bottom > self.height) {
        self.contentSize = CGSizeMake(ScreenWidth, self.addImageView.bottom);
    } else {
        self.contentSize = CGSizeMake(ScreenWidth, self.height + 1);
    }
}

- (void)setModel:(TTMChairSettingModel *)model {
    _model = model;
    
    self.brandTextField.text = model.seat_brand;
    self.modelTextField.text = model.seat_desc;
    self.chairTextField.text = [NSString stringWithFormat:@"%@", @(model.seat_price)];
    self.assistTextField.text = [NSString stringWithFormat:@"%@", @(model.assistant_price)];
    
    if (model.seat_distillwater && model.seat_tapwater) { // 两个都选中
        [self.waterSelectView buttonSelectedWithIndex:2 isSelected:YES];
    } else {
        [self.waterSelectView buttonSelectedWithIndex:0 isSelected:model.seat_distillwater]; // 蒸馏水是否选中
        [self.waterSelectView buttonSelectedWithIndex:1 isSelected:model.seat_tapwater]; // 自来水是否选中
    }
    
    if (model.seat_ultrasound) { // 超声波1可切割
        [self.voiceSelectView buttonSelectedWithIndex:1 isSelected:YES];
    } else { // 0 可洗牙
        [self.voiceSelectView buttonSelectedWithIndex:0 isSelected:YES];
    }
    
    if (model.seat_light) { // 光固灯1可移灯
        [self.configSelectView buttonSelectedWithIndex:1 isSelected:YES];
    } else { // 0牙椅自带
        [self.configSelectView buttonSelectedWithIndex:0 isSelected:YES];
    }
}

@end
