//
//  XLSelectYuyueCell.m
//  CRM
//
//  Created by Argo Zhang on 15/12/21.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "XLSelectYuyueCell.h"
#import "LocalNotificationCenter.h"
#import <Masonry.h>

@interface XLSelectYuyueCell (){
    UILabel *_timeLabel;
    UIView *_containView;
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
    
    _containView = [[UIView alloc] init];
    _containView.hidden = YES;
    _containView.backgroundColor = [UIColor whiteColor];
}



- (void)setModels:(NSArray *)models{
    _models = models;
    
    CGFloat margin = 10;
    CGFloat rowHeight = 40;
    
    NSString *commonTime = @"00:00";
    CGSize timeSize = [commonTime sizeWithFont:[UIFont systemFontOfSize:15]];
    _timeLabel.text = self.time;
    
    WS(weakSelf);
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top);
        make.left.equalTo(weakSelf.mas_left).with.offset(margin);
        make.size.mas_equalTo(CGSizeMake(timeSize.width, rowHeight));
    }];
    
    if (models.count > 0) {
        //移除所有子视图
        [_containView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        _containView.hidden = NO;
        [self.contentView addSubview:_containView];
        //设置约束
        [_containView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.right.and.bottom.mas_equalTo(weakSelf);
            make.left.equalTo(_timeLabel.mas_right).with.offset(margin);
        }];
        
        CGFloat contentW = (kScreenWidth - _timeLabel.width - 20) / models.count;
        for (int i = 0; i < models.count; i++) {
            LocalNotification *model = models[i];
            UILabel *contentLabel = [[UILabel alloc] init];
            contentLabel.textColor = [UIColor blackColor];
            contentLabel.backgroundColor = MyColor(186, 232, 255);
            contentLabel.font = [UIFont systemFontOfSize:15];
            contentLabel.text = model.reserve_type;
            [_containView addSubview:contentLabel];
            
            [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(i * contentW + 2);
                make.size.mas_equalTo(CGSizeMake(contentW, 40));
                make.centerY.equalTo(_containView);
            }];
            
            UIView *dividerView = [[UIView alloc] init];
            dividerView.backgroundColor = MyColor(0, 160, 234);
            [_containView addSubview:dividerView];
            
            [dividerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(i * contentW);
                make.size.mas_equalTo(CGSizeMake(2, 40));
                make.centerY.equalTo(_containView);
            }];
        }
    }else{
        _containView.hidden = YES;
        [_containView removeFromSuperview];
    }
}

@end
