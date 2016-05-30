//
//  XLClinicChooseCTImageController.m
//  CRM
//
//  Created by Argo Zhang on 16/5/23.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLClinicChooseCTImageController.h"
#import "XLClinicCTImageCell.h"
#import "DBManager+Patients.h"
#import "DBTableMode.h"

#define kClinicCTImageCellID @"clinic_ctImage_cell"

@interface XLClinicChooseCTImageController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong)UICollectionView *collectionView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)NSArray *CTLibs;

@end

@implementation XLClinicChooseCTImageController

#pragma mark - ********************* Life Method ***********************
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //加载子视图
    [self setUpSubViews];
    
    //加载数据
    [self requestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - ********************* Private Method ***********************
- (void)setUpSubViews{
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    [self setRightBarButtonWithTitle:@"保存"];
    
    [self.view addSubview:self.collectionView];
}
#pragma mark 加载数据
- (void)requestData{
    NSArray *mCases = [[DBManager shareInstance] getMedicalCaseArrayWithPatientId:self.patientId];
    for (MedicalCase *mCase in mCases) {
        NSArray *ctLibs = [[DBManager shareInstance] getCTLibArrayWithCaseId:mCase.ckeyid isAsc:YES];
        for (CTLib *ctLib in ctLibs) {
             XLClinicCTImageCellModel *model = [[XLClinicCTImageCellModel alloc] init];
            model.urlStr = ctLib.ct_image;
            if (self.selectImages.count > 0) {
                if ([self.selectImages containsObject:ctLib.ct_image]) {
                    model.select = YES;
                }
            }
            [self.dataList addObject:model];
        }
    }
    [self.collectionView reloadData];
}

#pragma mark 保存按钮点击
- (void)onRightButtonAction:(id)sender{
    //判断当前选中了哪些图片
    NSMutableArray *mArray = [NSMutableArray array];
    for (XLClinicCTImageCellModel *model in self.dataList) {
        if (model.isSelect) {
            [mArray addObject:model.urlStr];
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(clinicChooseCTImageController:didSelectImages:)]) {
        [self.delegate clinicChooseCTImageController:self didSelectImages:mArray];
    }
    [self popViewControllerAnimated:YES];
}

#pragma mark - ****************** Delegate / DataSource *****************
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    XLClinicCTImageCellModel *model = self.dataList[indexPath.item];
    XLClinicCTImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kClinicCTImageCellID forIndexPath:indexPath];
    cell.model = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    XLClinicCTImageCellModel *model = self.dataList[indexPath.item];
    model.select = !model.isSelect;
    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
}

#pragma mark - ********************* Lazy Method ***********************
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat itemW = (kScreenWidth - 10 * 3) / 2;
        flowLayout.itemSize = CGSizeMake(itemW, itemW);
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.minimumLineSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[XLClinicCTImageCell class] forCellWithReuseIdentifier:kClinicCTImageCellID];
    }
    return _collectionView;
}

- (NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}
@end
