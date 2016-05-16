//
//  XLCollectionViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/5/14.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLCollectionViewController.h"
#import "CustomCollectionViewLayout.h"
#import "XLDateCell.h"
#import "XLContentCell.h"

#define CollectionViewDateCellIdentifier @"CollectionViewDateCellIdentifier"
#define CollectionViewContentCellIdentifier @"CollectionViewContentCellIdentifier"

@interface XLCollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong)UICollectionView *collectionView;

@end

@implementation XLCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //初始化视图
    [self setUpViews];
    
}

- (void)setUpViews{
    CustomCollectionViewLayout *flowLayout = [[CustomCollectionViewLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.bounces = NO;
    [_collectionView registerClass:[XLDateCell class] forCellWithReuseIdentifier:CollectionViewDateCellIdentifier];
    [_collectionView registerClass:[XLContentCell class] forCellWithReuseIdentifier:CollectionViewContentCellIdentifier];
    [self.view addSubview:_collectionView];
}

#pragma mark - UICollectionDelegate/DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 50;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //交叉视图
            XLDateCell *dateCell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewDateCellIdentifier forIndexPath:indexPath];
            dateCell.backgroundColor = [UIColor whiteColor];
            dateCell.dateLabel.text = @"Date";
            
            return dateCell;
        }else{
            XLContentCell *contentCell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewContentCellIdentifier forIndexPath:indexPath];
            contentCell.backgroundColor = [UIColor whiteColor];
            contentCell.contentLabel.text = @"Section";
            
            return contentCell;
        }
    }else{
        if (indexPath.row == 0) {
            //交叉视图
            XLDateCell *dateCell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewDateCellIdentifier forIndexPath:indexPath];
            dateCell.backgroundColor = [UIColor whiteColor];
            dateCell.dateLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
            
            return dateCell;
        }else{
            XLContentCell *contentCell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewContentCellIdentifier forIndexPath:indexPath];
            contentCell.backgroundColor = [UIColor whiteColor];
            contentCell.contentLabel.text = @"content";
            
            return contentCell;
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了:%ld----%ld",indexPath.section,indexPath.row);
}


- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
