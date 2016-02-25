//
//  XLAnalyseButton.m
//  CRM
//
//  Created by Argo Zhang on 16/1/21.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLAnalyseButton.h"
#import "UIColor+Extension.h"
#import "XLPieChartParam.h"

@interface XLAnalyseButton ()

@property (nonatomic, weak)UIView *dotView;
@property (nonatomic, weak)UILabel *nameLabel;
@property (nonatomic, weak)UILabel *countLabel;
@property (nonatomic, weak)UIImageView *arrowView;
@property (nonatomic, weak)UIView *dividerView;
@end

@implementation XLAnalyseButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化
        [self setUp];
    }
    return self;
}

#pragma mark - 初始化
- (void)setUp{
    UIView *dotView = [[UIView alloc] init];
    dotView.backgroundColor = [UIColor grayColor];
    dotView.layer.cornerRadius = 5;
    dotView.layer.masksToBounds = YES;
    self.dotView = dotView;
    [self addSubview:dotView];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = [UIColor colorWithHex:0x888888];
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.textAlignment = NSTextAlignmentRight;
    self.nameLabel = nameLabel;
    [self addSubview:nameLabel];
    
    UILabel *countLabel = [[UILabel alloc] init];
    countLabel.textColor = [UIColor colorWithHex:0x333333];
    countLabel.font = [UIFont systemFontOfSize:15];
    countLabel.textAlignment = NSTextAlignmentRight;
    self.countLabel = countLabel;
    [self addSubview:countLabel];
    
    UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_crm"]];
    self.arrowView = arrowView;
    [self addSubview:arrowView];
    
    UIView *dividerView = [[UIView alloc] init];
    dividerView.backgroundColor = [UIColor colorWithHex:0xcccccc];
    self.dividerView = dividerView;
    [self addSubview:dividerView];
    
}

- (void)setParam:(XLPieChartParam *)param{
    _param = param;
    
    self.dotView.backgroundColor = param.color;
    self.nameLabel.text = param.status;
    self.countLabel.text = [NSString stringWithFormat:@"%d",(int)param.count];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat margin = 10;
    
    CGFloat dotW = 10;
    CGFloat dotH = dotW;
    CGFloat dotX = margin;
    CGFloat dotY = (self.height - dotH) / 2;
    self.dotView.frame = CGRectMake(dotX, dotY, dotW, dotH);
    
    CGFloat arrowW = 13;
    CGFloat arrowH = 18;
    CGFloat arrowX = self.width - 13 - margin;
    CGFloat arrowY = (self.height - arrowH) / 2;
    self.arrowView.frame = CGRectMake(arrowX, arrowY, arrowW, arrowH);
    
    CGFloat countW = 40;
    CGFloat countH = self.height;
    CGFloat countX = self.arrowView.left - margin * 2 - countW;
    CGFloat countY = 0;
    self.countLabel.frame = CGRectMake(countX, countY, countW, countH);
    
    CGFloat nameW = 100;
    CGFloat nameH = 40;
    CGFloat nameX = self.countLabel.left - margin - nameW;
    CGFloat nameY = 0;
    self.nameLabel.frame = CGRectMake(nameX, nameY, nameW, nameH);
    
    CGFloat dividerW = self.width;
    CGFloat dividerH = .5;
    CGFloat dividerX = 0;
    CGFloat dividerY = self.height - dividerH;
    self.dividerView.frame = CGRectMake(dividerX, dividerY, dividerW, dividerH);

}

@end
