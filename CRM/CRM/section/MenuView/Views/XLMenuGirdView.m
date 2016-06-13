//
//  XLMenuGirdView.m
//  CRM
//
//  Created by Argo Zhang on 16/6/1.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLMenuGirdView.h"
#import "XLMenuGridViewCell.h"
#import "XLGridItemModel.h"

#define kMenuGridViewCellId @"kMenuGridViewCellId"

@interface XLMenuGirdView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, weak)UICollectionView *gridView;
@property (nonatomic, strong)NSMutableArray *dataList;

@end

@implementation XLMenuGirdView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

#pragma mark - 初始化
- (void)setUp{
    self.dataList = [NSMutableArray arrayWithArray:[self calculateSourceArray]];
    self.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 1;
    flowLayout.minimumLineSpacing = 1;
    CGFloat itemW = (kScreenWidth - 2) / 3;
    flowLayout.itemSize = CGSizeMake(itemW, itemW);
    UICollectionView *gridView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    gridView.delegate = self;
    gridView.dataSource = self;
    gridView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.7];
    [gridView registerClass:[XLMenuGridViewCell class] forCellWithReuseIdentifier:kMenuGridViewCellId];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    longPress.minimumPressDuration = 1;
    [gridView addGestureRecognizer:longPress];
    self.gridView = gridView;
    [self addSubview:gridView];
}

- (void)longPressAction:(UILongPressGestureRecognizer *)longPress{
    switch(longPress.state) {
        case UIGestureRecognizerStateBegan:
        {
            NSIndexPath *selectedIndexPath = [self.gridView indexPathForItemAtPoint:[longPress locationInView:self.gridView]];
            if (!selectedIndexPath) {
                break;
            }
            [self.gridView beginInteractiveMovementForItemAtIndexPath:selectedIndexPath];
        }
            
        case UIGestureRecognizerStateChanged:
            
            [self.gridView updateInteractiveMovementTargetPosition:[longPress locationInView:longPress.view]];
            
        case UIGestureRecognizerStateEnded:
            [self.gridView endInteractiveMovement];
            
        default:
            [self.gridView cancelInteractiveMovement];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.gridView.frame = self.bounds;
}

#pragma mark - UICollectionViewDelegate/DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    XLMenuGridViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMenuGridViewCellId forIndexPath:indexPath];
    XLGridItemModel *model = self.dataList[indexPath.item];
    cell.itemModel = model;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    XLGridItemModel *temp = self.dataList[sourceIndexPath.item];
    [self.dataList removeObjectAtIndex:sourceIndexPath.item];
    [self.dataList insertObject:temp atIndex:destinationIndexPath.item];
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

@end
