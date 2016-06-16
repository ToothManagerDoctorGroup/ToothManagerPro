//
//  XLMenuGridViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/5/31.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLMenuGridViewController.h"
#import "XLMenuGrideView.h"
#import "XLGridItemModel.h"
#import "XLMenuGirdView.h"

@interface XLMenuGridViewController ()<XLMenuGrideViewDelegate>

//@property (nonatomic, weak)XLMenuGrideView *grideView;
@property (nonatomic, weak)XLMenuGirdView *gridView;

@end

@implementation XLMenuGridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我";
    //初始化
    [self setUpGrideView];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    self.gridView.frame = self.view.bounds;
}


#pragma mark - 设置grideView
- (void)setUpGrideView{
    XLMenuGirdView *grideView = [[XLMenuGirdView alloc] init];
//    grideView.gridViewDelegate = self;
//    grideView.gridModels = [self calculateSourceArray];
    self.gridView = grideView;
    [self.view addSubview:grideView];
//    [self.view addGestureRecognizer:grideView.panGestureRecognizer];
}

- (NSArray *)calculateSourceArray{
    // 模拟数据
    NSArray *itemsArray =  @[@{@"淘宝" : @"i00"}, // title => imageString
                             @{@"生活缴费" : @"i01"},
                             @{@"教育缴费" : @"i02"},
                             @{@"红包" : @"i03"},
                             @{@"物流" : @"i04"},
                             @{@"信用卡" : @"i05"},
                             @{@"转账" : @"i06"},
                             @{@"爱心捐款" : @"i07"},
                             @{@"彩票" : @"i08"},
                             @{@"当面付" : @"i09"},
                             @{@"余额宝" : @"i10"},
                             @{@"AA付款" : @"i11"},
                             @{@"国际汇款" : @"i12"},
                             @{@"淘点点" : @"i13"},
                             @{@"淘宝电影" : @"i14"},
                             @{@"亲密付" : @"i15"},
                             @{@"股市行情" : @"i16"},
                             @{@"汇率换算" : @"i17"}
                             ];
    NSMutableArray *temp = [NSMutableArray array];
    for (NSDictionary *itemDict in itemsArray) {
        XLGridItemModel *model = [[XLGridItemModel alloc] init];
        model.destinationClass = [UIViewController class];
        model.imageUrlStr =[itemDict.allValues firstObject];
        model.title = [itemDict.allKeys firstObject];
        [temp addObject:model];
    }
    return [temp copy];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
