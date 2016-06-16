//
//  XLDiseaseRecordDetailController.m
//  CRM
//
//  Created by Argo Zhang on 16/3/3.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLDiseaseRecordDetailController.h"
#import "NSString+TTMAddtion.h"

@interface XLDiseaseRecordDetailController ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *toothLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *doctorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *ctTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *imageSuperView;

@property (nonatomic, strong)NSArray *images;

@end

@implementation XLDiseaseRecordDetailController

- (NSArray *)images{
    if (!_images) {
        _images = @[@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",];
    }
    return _images;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"病程详情";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    [self setRightBarButtonWithImage:[UIImage imageNamed:@"team_bianji_white"]];
    NSString *content = @"这只是一段测试的话这只是一段测试的话这只是一段测试的话这只是一段测试的话";
    self.remarkLabel.text = content;
    
    //设置图片
    [self setUpImageView];
}

- (void)setUpImageView{
    //计算一行显示几张图片
    NSInteger count = self.imageSuperView.width / 70;
    //计算总共有几行
    NSInteger rows = self.images.count % count == 0 ? self.images.count / count : self.images.count / count + 1;
    
    for (int i = 0; i < self.images.count; i++) {
        int index_x = i / count;
        int index_y = i % count;
        
        CGFloat imageX = 10 + (10 + 60) * index_y;
        CGFloat imageY = 10 + (10 + 60) * index_x;
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"user"]];
        imageView.frame = CGRectMake(imageX, imageY, 60, 60);
        [self.imageSuperView addSubview:imageView];
    }
}

#pragma mark - 
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *content = @"这只是一段测试的话这只是一段测试的话这只是一段测试的话这只是一段测试的话";
    CGSize contentSize = [content measureFrameWithFont:[UIFont systemFontOfSize:15] size:CGSizeMake(kScreenWidth - 15 - 10 - 15 - 68 - 40, MAXFLOAT)].size;
    if (indexPath.section == 1) {
        if (contentSize.height > 50) {
            return contentSize.height;
        }else{
            return 50;
        }
    }else if (indexPath.section == 2){
        //计算一行显示几张图片
        NSInteger count = self.imageSuperView.width / 70;
        //计算总共有几行
        NSInteger rows = self.images.count % count == 0 ? self.images.count / count : self.images.count / count + 1;
        
        //计算总高度
        CGFloat totalH = rows * 70 + 10;
        
        return self.ctTimeLabel.bottom + 10 + totalH;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
