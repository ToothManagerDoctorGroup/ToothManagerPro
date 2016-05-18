//
//  XLStarSelectCell.m
//  CRM
//
//  Created by Argo Zhang on 16/2/19.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLStarSelectCell.h"
#import "TimStarView.h"

@interface XLStarSelectCell ()

@property (nonatomic, weak)TimStarView *starView;

@end

@implementation XLStarSelectCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"star_cell";
    XLStarSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUp];
    }
    return self;
}
#pragma mark - 初始化
- (void)setUp{
    TimStarView *starView = [[TimStarView alloc] init];
    starView.userInteractionEnabled = NO;
    self.starView = starView;
    [self.contentView addSubview:starView];
}

- (void)setLevel:(NSInteger)level{
    _level = level;
    
    self.starView.frame = CGRectMake((kScreenWidth - 75) / 2, (self.height - 15) / 2, 75, 15);
    self.starView.scale = level;
}

@end
