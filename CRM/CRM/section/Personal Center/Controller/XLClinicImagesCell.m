//
//  XLClinicImagesCell.m
//  CRM
//
//  Created by Argo Zhang on 16/5/24.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLClinicImagesCell.h"
#import "XLImageScrollView.h"
#import "ClinicImageModel.h"
#import "ClinicDetailModel.h"
#import <Masonry.h>

@interface XLClinicImagesCell ()

@property (nonatomic, strong)XLImageScrollView *imageScrollView;

@end

@implementation XLClinicImagesCell


+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"seat_cell";
    XLClinicImagesCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
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
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.imageScrollView];
    
    [self setUpContrains];
}

- (void)setUpContrains{
    [self.imageScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
}

- (void)setModel:(ClinicDetailModel *)model{
    _model = model;
    
    
    NSArray *clinicImages = model.ClinicInfo;

    if (clinicImages.count == 0) {
        self.imageScrollView.hidden = YES;
        return;
    }
    self.imageScrollView.hidden = NO;
    
    NSMutableArray *mArray = [NSMutableArray array];
    for (ClinicImageModel *imageModel in clinicImages) {
        XLImageScrollViewModel *model = [[XLImageScrollViewModel alloc] init];
        model.imageUrl = imageModel.img_info;
        [mArray addObject:model];
    }
    self.imageScrollView.imageModelsArray = mArray;
}

- (XLImageScrollView *)imageScrollView{
    if (!_imageScrollView) {
        _imageScrollView = [[XLImageScrollView alloc] init];
    }
    return _imageScrollView;
}

@end
