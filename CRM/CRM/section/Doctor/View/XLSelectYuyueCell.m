//
//  XLSelectYuyueCell.m
//  CRM
//
//  Created by Argo Zhang on 15/12/21.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "XLSelectYuyueCell.h"
#import "LocalNotificationCenter.h"

@interface XLSelectYuyueCell (){
    UILabel *_timeLabel;
    UIView *_contentView;
}

@end

@implementation XLSelectYuyueCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"selectyuyue_cell";
    XLSelectYuyueCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
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

- (void)setUp{
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = [UIColor blackColor];
    _timeLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_timeLabel];
    
    _contentView = [[UIView alloc] init];
    _contentView.hidden = YES;
    _contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_contentView];
}



- (void)setModels:(NSArray *)models{
    _models = models;
    
    CGFloat margin = 10;
    
    CGSize timeSize = [self.time sizeWithFont:[UIFont systemFontOfSize:15]];
    _timeLabel.frame = CGRectMake(margin, 0, timeSize.width, self.height);
    _timeLabel.text = self.time;
    
    _contentView.frame = CGRectMake(_timeLabel.right + margin, 0, kScreenWidth - margin * 2 - _timeLabel.width, 40);
    
    if (models.count > 0) {
        _contentView.hidden = NO;
        [self.contentView addSubview:_contentView];
        CGFloat contentW = (self.width - _timeLabel.width - 20) / models.count;
        for (int i = 0; i < models.count; i++) {
            LocalNotification *model = models[i];
            UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(i * contentW + 2, 0, contentW, 40)];
            contentLabel.textColor = [UIColor blackColor];
            contentLabel.backgroundColor = MyColor(186, 232, 255);
            contentLabel.font = [UIFont systemFontOfSize:15];
            contentLabel.text = model.reserve_type;
            [_contentView addSubview:contentLabel];
            
            UIView *dividerView = [[UIView alloc] init];
            dividerView.backgroundColor = MyColor(0, 160, 234);
            dividerView.frame = CGRectMake(i * contentW, 0, 2, 40);
            [_contentView addSubview:dividerView];
        }
    }else{
        _contentView.hidden = YES;
        [_contentView removeFromSuperview];
    }
}

@end
