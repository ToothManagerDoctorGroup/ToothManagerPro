
#import "TTMClinicInfoCell.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+TTMAddtion.h"

#define kFontSize 15

@interface TTMClinicInfoCell ()

@property (nonatomic, weak)   UILabel *titleLabel; // 标题
@property (nonatomic, weak)   UIImageView *headImageView; // 头像,二维码
@property (nonatomic, weak)   UITextField *textField; // 输入框
@property (nonatomic, weak)   UIView *separatorView;

@end

@implementation TTMClinicInfoCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"cellID";
    TTMClinicInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[TTMClinicInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.font = [UIFont systemFontOfSize:kFontSize];
    titleLabel.textColor = [UIColor darkGrayColor];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UILabel *contentLabel = [UILabel new];
    contentLabel.font = [UIFont systemFontOfSize:kFontSize];
    contentLabel.textColor = [UIColor blackColor];
    contentLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:contentLabel];
    self.contentLabel = contentLabel;
    
    UIImageView *headImageView = [UIImageView new];
    [self.contentView addSubview:headImageView];
    self.headImageView = headImageView;
    
    UITextField *textField = [UITextField new];
    textField.font = [UIFont systemFontOfSize:kFontSize];
    [self.contentView addSubview:textField];
    self.textField = textField;
    
    UIView *separatorView = [[UIView alloc] init];
    separatorView.backgroundColor = TableViewCellSeparatorColor;
    separatorView.alpha = TableViewCellSeparatorAlpha;
    [self.contentView addSubview:separatorView];
    self.separatorView = separatorView;
    
}


- (void)setModel:(TTMClinicInfoCellModel *)model {
    _model = model;
    self.titleLabel.text = model.title;
    self.contentLabel.text = model.content;
    self.textField.text = model.textFieldString;
    
    switch (model.type) {
        case TTMClinicCellModelTypeNormal: {
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            self.contentLabel.hidden = NO;
            self.headImageView.hidden = YES;
            self.textField.hidden = YES;
            break;
        }
        case TTMClinicCellModelTypeHead: {
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            self.contentLabel.hidden = YES;
            self.headImageView.hidden = NO;
            self.textField.hidden = YES;
            [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.imageURL]
                                  placeholderImage:[UIImage imageNamed:@"clinic_head_placeholder"]];
            CGFloat margin = 10.f;
            CGFloat headImageWH = 44.f;
            CGFloat headImageX = (ScreenWidth - headImageWH - 3 * margin);
            CGFloat headImageY = (60 - headImageWH) / 2;
            
            self.headImageView.frame = CGRectMake(headImageX, headImageY, headImageWH, headImageWH);
            [self.headImageView circleImageViewWithCornRaduis:(headImageWH / 2)];
            break;
        }
        case TTMClinicCellModelTypeQRCode: {
            self.accessoryType = UITableViewCellAccessoryNone;
            self.contentLabel.hidden = YES;
            self.headImageView.hidden = NO;
            self.textField.hidden = YES;
            [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.imageURL]
                                  placeholderImage:[UIImage imageNamed:@"clinic_qrcode_placeholder"]];
            CGFloat margin = 10.f;
            CGFloat headImageWH = 30.f;
            CGFloat headImageX = (ScreenWidth - headImageWH - 3 * margin);
            CGFloat headImageY = (44 - headImageWH) / 2;
            
            self.headImageView.frame = CGRectMake(headImageX, headImageY, headImageWH, headImageWH);
            [self.headImageView circleImageViewWithCornRaduis:0];
            break;
        }
        case TTMClinicCellModelTypeTextField: {
            self.accessoryType = UITableViewCellAccessoryNone;
            self.contentLabel.hidden = YES;
            self.headImageView.hidden = YES;
            self.textField.hidden = NO;
            break;
        }
    }
    
}

- (void)textChanged:(NSNotification *)notification {
    self.model.textFieldString = self.textField.text;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat margin = 10.f;
    CGFloat labelH = 20.f;
    CGFloat titleLabelW = 100.f;
    CGFloat labelY = (self.height - labelH) / 2;
    CGFloat contentLabelW = (ScreenWidth - 4 * margin - titleLabelW);
    CGFloat contentLabelX = (margin + titleLabelW);
    CGFloat textFieldH = self.height;
    
    self.titleLabel.frame = CGRectMake(margin, labelY, titleLabelW, labelH);
    self.contentLabel.frame = CGRectMake(contentLabelX, labelY, contentLabelW, labelH);
    self.textField.frame = CGRectMake(contentLabelX, 0, contentLabelW, textFieldH);
    self.separatorView.frame = CGRectMake(0, self.height - TableViewCellSeparatorHeight, ScreenWidth, TableViewCellSeparatorHeight);
}

@end
