//
//  TTMMemberCell.m
//  ToothManager
//

#import "TTMMemberCell.h"

#define kFontSize 14
#define kTitleColor [UIColor darkGrayColor]
#define kRowHeight 44.f
#define kMessageW 15.f
#define kMargin 10.f
#define kMaxTitleW 200.f
#define kButtonW 50.f
#define kButtonH 30.f
#define kButtonFontSize 14

@interface TTMMemberCell ()

@property (nonatomic, weak)   UILabel *titleLabel;
@property (nonatomic, weak)   UILabel *contentLabel;
@property (nonatomic, weak)   UIButton *button;
@property (nonatomic, weak)   UILabel *messageNumLabel;
@property (nonatomic, weak)   UIView *separatorView;
@end

@implementation TTMMemberCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"CellID";
    TTMMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[TTMMemberCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:kFontSize];
    titleLabel.textColor = kTitleColor;
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = [UIFont systemFontOfSize:kFontSize];
    [self.contentView addSubview:contentLabel];
    self.contentLabel = contentLabel;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"gtask_hand_button_bg"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:MainColor forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:kButtonFontSize];
    button.hidden = YES;
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:button];
    self.button = button;
    
    UILabel *messageNumLabel = [[UILabel alloc] init];
    messageNumLabel.font = [UIFont systemFontOfSize:10.f];
    messageNumLabel.backgroundColor = [UIColor redColor];
    messageNumLabel.textColor = [UIColor whiteColor];
    messageNumLabel.textAlignment = NSTextAlignmentCenter;
    messageNumLabel.layer.cornerRadius = kMessageW / 2;
    messageNumLabel.clipsToBounds = YES;
    messageNumLabel.hidden = YES;
    [self.contentView addSubview:messageNumLabel];
    self.messageNumLabel = messageNumLabel;
    
    UIView *separatorView = [[UIView alloc] init];
    separatorView.backgroundColor = TableViewCellSeparatorColor;
    separatorView.alpha = TableViewCellSeparatorAlpha;
    [self.contentView addSubview:separatorView];
    self.separatorView = separatorView;
}

- (void)setModel:(TTMMemberCellModel *)model {
    _model = model;
    
    self.titleLabel.text = model.title;
    self.contentLabel.text = model.content;
    
    // 访问类型
    if (model.accessType == TTMMemberCellModelAccessTypeButton) {
        self.button.hidden = NO;
        self.accessoryType = UITableViewCellAccessoryNone;
        [self.button setTitle:model.buttonTitle forState:UIControlStateNormal];
    } else if (model.accessType == TTMMemberCellModelAccessTypeArrow) {
        self.button.hidden = YES;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (model.accessType == TTMMemberCellModelAccessTypeNone) {
        self.button.hidden = YES;
        self.accessoryType = UITableViewCellAccessoryNone;
    }
    
    // 内容颜色
    if (model.contenColor) {
        self.contentLabel.textColor = model.contenColor;
    } else {
        self.contentLabel.textColor = [UIColor blackColor];
    }
    
    if (model.messageNum) {
        self.messageNumLabel.hidden = NO;
        if (model.messageNum > 99) {
            self.messageNumLabel.text = @"N+";
        } else {
            self.messageNumLabel.text = [NSString stringWithFormat:@"%@", @(model.messageNum)];
        }
    } else {
        self.messageNumLabel.hidden = YES;
    }
    
    [self updateFrame];
}

// 刷新frame
- (void)updateFrame {
    CGFloat titleW = [self.titleLabel.text measureFrameWithFont:[UIFont systemFontOfSize:kFontSize]
                                                           size:CGSizeMake(kMaxTitleW, kRowHeight)].size.width;
    self.titleLabel.frame = CGRectMake(kMargin, 0, titleW, kRowHeight);
    
    CGFloat contenW = 0;
    if (!self.button.hidden) {
        contenW = ScreenWidth - 2 * kMargin - titleW - kButtonW;
    } else {
        contenW = ScreenWidth - 3 * kMargin - titleW;
    }
    self.contentLabel.frame = CGRectMake(self.titleLabel.right, 0, contenW, kRowHeight);
    
    self.button.frame = CGRectMake(ScreenWidth - kMargin - kButtonW, (kRowHeight - kButtonH) / 2,
                                   kButtonW, kButtonH);
    
    self.messageNumLabel.frame = CGRectMake(self.titleLabel.right, kMargin, kMessageW, kMessageW);
    
    self.separatorView.frame = CGRectMake(0, kRowHeight - TableViewCellSeparatorHeight,
                                          ScreenWidth, TableViewCellSeparatorHeight);
}

- (void)buttonAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(memberCell:clickedModel:)]) {
        [self.delegate memberCell:self clickedModel:self.model];
    }
}
@end
