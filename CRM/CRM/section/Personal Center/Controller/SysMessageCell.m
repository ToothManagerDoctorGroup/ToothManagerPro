//
//  SysMessageCell.m
//  CRM
//
//  Created by Argo Zhang on 15/12/16.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "SysMessageCell.h"
#import "SysMessageModel.h"
#import "UIColor+Extension.h"

#define TitleFont [UIFont systemFontOfSize:15]
#define TitleColor [UIColor blackColor]
#define CommenFont [UIFont systemFontOfSize:13]
#define CommenColor MyColor(100, 100, 100)

@interface SysMessageCell ()

@property (nonatomic, weak)UILabel *titleLabel;
@property (nonatomic, weak)UILabel *timeLabel;
@property (nonatomic, weak)UILabel *contentLabel;
@property (nonatomic, weak)UIView *divider;

@end

@implementation SysMessageCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"sys_message";
    SysMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //初始化
        [self setUp];
    }
    return self;
}
#pragma mark - 初始化
- (void)setUp{
    //标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = TitleFont;
    titleLabel.textColor = TitleColor;

    self.titleLabel = titleLabel;
    [self.contentView addSubview:titleLabel];
    
    //时间
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = CommenFont;
    timeLabel.textColor = CommenColor;

    self.timeLabel = timeLabel;
    [self.contentView addSubview:timeLabel];
    
    //内容
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = CommenFont;
    contentLabel.textColor = CommenColor;
    contentLabel.numberOfLines = 0;
    self.contentLabel = contentLabel;
    [self.contentView addSubview:contentLabel];
    
    //分割线
    UIView *divider = [[UIView alloc] init];
    divider.backgroundColor = [UIColor colorWithHex:0xCCCCCC];
    self.divider = divider;
    [self.contentView addSubview:divider];
}

- (void)setModel:(SysMessageModel *)model{
    _model = model;
    
    if ([model.message_type isEqualToString:AttainNewFriend]) {
        self.titleLabel.text = @"新增好友";
    }else if([model.message_type isEqualToString:AttainNewPatient]){
        self.titleLabel.text = @"新增患者";
    }else if ([model.message_type isEqualToString:InsertReserveRecord]){
        self.titleLabel.text = @"添加预约";
    }else if ([model.message_type isEqualToString:CancelReserveRecord]){
        self.titleLabel.text = @"取消预约";
    }else{
        self.titleLabel.text = @"修改预约";
    }
    
    self.timeLabel.text = self.model.create_time;
    
    self.contentLabel.text = self.model.message_content;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat margin = 10;
    CGSize titleSize = [self.titleLabel.text sizeWithFont:TitleFont];
    self.titleLabel.frame = CGRectMake(margin, margin / 2, titleSize.width, 20);
    
    
    CGSize timeSize = [self.model.create_time sizeWithFont:CommenFont];
    self.timeLabel.frame = CGRectMake(kScreenWidth - timeSize.width - margin, margin / 2, timeSize.width, 20);
    
    //计算内容的宽度和高度
    CGSize contentSize = [self.model.message_content sizeWithFont:CommenFont constrainedToSize:CGSizeMake(kScreenWidth - margin * 2, MAXFLOAT)];
    self.contentLabel.frame = CGRectMake(margin, self.titleLabel.bottom + margin, kScreenWidth - margin * 2, contentSize.height);
    
    self.divider.frame = CGRectMake(0, self.height - 0.5, kScreenWidth, 0.5);
}

////tableView的侧滑是从右往左滑。而抽屉是从左往右滑。 解决方法刚刚找到了，判断滑动的视图。
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    // 输出点击的view的类名
//    NSLog(@"你那是屌丝都调试%@", NSStringFromClass([touch.view class]));
//    
//    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
//    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
//        return YES;
//    }
//    return  NO;
//}

@end
