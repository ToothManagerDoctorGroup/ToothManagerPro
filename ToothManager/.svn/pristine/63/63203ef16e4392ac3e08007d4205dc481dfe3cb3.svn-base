
#import "TTMAddOtherLineView.h"
#import "TTMSelectButton.h"

#define kFontSize 14

#define kLineH 44.f

@interface TTMAddOtherLineView ()

@property (nonatomic, weak) UILabel *titleLabel; // 项目

@property (nonatomic, weak) UILabel *priceTitleLabel; // 费用

@property (nonatomic, weak) UILabel *unitLabel; // 单位

@property (nonatomic, weak) UIView *separatorView; // 分隔线

@end

@implementation TTMAddOtherLineView

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
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"项目：";
    titleLabel.font = [UIFont systemFontOfSize:kFontSize];
    titleLabel.textAlignment = NSTextAlignmentRight;
    titleLabel.textColor = [UIColor darkGrayColor];
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    TTMSelectButton *valueButton = [TTMSelectButton buttonWithType:UIButtonTypeCustom];
    [valueButton setImage:[UIImage imageNamed:@"member_down_arrow_icon"] forState:UIControlStateNormal];
    [valueButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    valueButton.titleLabel.font = [UIFont systemFontOfSize:kFontSize];
    [self addSubview:valueButton];
    self.valueButton = valueButton;
    
    UILabel *priceTitleLabel = [UILabel new];
    priceTitleLabel.text = @"费用：";
    priceTitleLabel.font = [UIFont systemFontOfSize:kFontSize];
    priceTitleLabel.textAlignment = NSTextAlignmentRight;
    priceTitleLabel.textColor = [UIColor darkGrayColor];
    [self addSubview:priceTitleLabel];
    self.priceTitleLabel = priceTitleLabel;
    
    UITextField *priceTextField = [UITextField new];
    priceTextField.font = [UIFont systemFontOfSize:kFontSize];
    priceTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    priceTextField.layer.cornerRadius = 2.f;
    priceTextField.layer.borderWidth = TableViewCellSeparatorHeight;
    priceTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:priceTextField];
    self.priceTextField = priceTextField;
    
    UILabel *unitLabel = [UILabel new];
    unitLabel.text = @"  元";
    unitLabel.font = [UIFont systemFontOfSize:kFontSize];
    unitLabel.textColor = [UIColor darkGrayColor];
    [self addSubview:unitLabel];
    self.unitLabel = unitLabel;
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *deleteImage = [UIImage imageNamed:@"delete"];
    [deleteButton setBackgroundImage:deleteImage forState:UIControlStateNormal];
    deleteButton.size = deleteImage.size;
    [self addSubview:deleteButton];
    self.deleteButton = deleteButton;
    
    UIView *separatorView = [UIView createLineView];
    [self addSubview:separatorView];
    self.separatorView = separatorView;
}

- (void)setModel:(TTMMaterialModel *)model {
    _model = model;
    [self.valueButton setTitle:model.mat_name forState:UIControlStateNormal];
    self.priceTextField.text = model.mat_price;
    CGFloat width = [model.mat_name measureFrameWithFont:[UIFont systemFontOfSize:kFontSize]
                                                    size:CGSizeMake(MAXFLOAT, self.valueButton.height)].size.width;
    self.valueButton.width = width + 30.f;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat labelH = 20.f;
    CGFloat labelY = (kLineH - labelH) / 2;
    CGFloat titleW = 50.f;
    CGFloat buttonW = 60.f;
    CGFloat buttonH = 30.f;
    CGFloat buttonY = (kLineH - buttonH) / 2;
    
    CGFloat deleteWH = self.deleteButton.width;
    CGFloat deleteX = ScreenWidth - deleteWH - 20.f;
    CGFloat deleteY = (kLineH - deleteWH) / 2;
    
    CGFloat unitLabelW = 30.f;
    CGFloat unitLabelX = deleteX - unitLabelW;
    
    CGFloat textFieldW = 60.f;
    CGFloat textFieldH = 30.f;
    CGFloat textFieldY = (kLineH - textFieldH) / 2;

    
    self.titleLabel.frame = CGRectMake(0, labelY, titleW, labelH);
    self.valueButton.frame = CGRectMake(self.titleLabel.right, buttonY, buttonW, buttonH);
    
    self.deleteButton.origin = CGPointMake(deleteX, deleteY);
    self.unitLabel.frame = CGRectMake(unitLabelX, labelY, unitLabelW, labelH);
    self.priceTextField.frame = CGRectMake(self.unitLabel.left - textFieldW, textFieldY, textFieldW, textFieldH);
    self.priceTitleLabel.frame = CGRectMake(self.priceTextField.left - titleW, labelY, titleW, labelH);
    
    self.separatorView.frame = CGRectMake(0, kLineH - TableViewCellSeparatorHeight, ScreenWidth, TableViewCellSeparatorHeight);
}

@end
