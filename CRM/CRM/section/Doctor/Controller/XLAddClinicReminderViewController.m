//
//  XLAddClinicReminderViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/5/17.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLAddClinicReminderViewController.h"
#import "XLPatientSelectViewController.h"
#import "XLHengYaViewController.h"
#import "XLRuYaViewController.h"
#import "XLReserveTypesViewController.h"
#import "EditAllergyViewController.h"
#import "ChooseAssistViewController.h"
#import "ChooseMaterialViewController.h"
#import "ZYQAssetPickerController.h"
#import "UIImage+TTMAddtion.h"
#import "LocalNotificationCenter.h"
#import "MaterialCountModel.h"
#import "AssistCountModel.h"

#define Margin 10
#define ImageWidth 60

@interface XLAddClinicReminderViewController ()<XLHengYaDeleate,XLRuYaDelegate,XLReserveTypesViewControllerDelegate,EditAllergyViewControllerDelegate,ChooseAssistViewControllerDelegate,ChooseMaterialViewControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,ZYQAssetPickerControllerDelegate>{
    CGFloat _billImageHeight;
    CGFloat _ctImageHeight;
}
@property (weak, nonatomic) IBOutlet UILabel *patientNameLabel; //患者姓名
@property (weak, nonatomic) IBOutlet UILabel *toothPositionLabel;//牙位
@property (weak, nonatomic) IBOutlet UILabel *reserveTypeLabel;//预约事项
@property (weak, nonatomic) IBOutlet UILabel *materialLabel;   //耗材
@property (weak, nonatomic) IBOutlet UILabel *assistentLabel;  //助手
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;     //备注
@property (weak, nonatomic) IBOutlet UIView *checkBillImagesSupView; //术前检查单
@property (weak, nonatomic) IBOutlet UIView *ctImagesSupView;//ct图片

@property (nonatomic,strong) XLHengYaViewController *hengYaVC;//恒牙
@property (nonatomic,strong) XLRuYaViewController *ruYaVC;//乳牙


@property (nonatomic, strong)NSMutableArray *billImages;//术前检查单图片
@property (nonatomic, strong)NSMutableArray *ctImages;//ct图片

@property (nonatomic, strong)NSArray *chooseMaterials;//选中的耗材
@property (nonatomic, strong)NSArray *chooseAssists;//选中的助手

@property (nonatomic, assign)BOOL isCtImage;//是否是选择CT图片

@end

@implementation XLAddClinicReminderViewController
#pragma mark - ********************* Life Method ***********************
- (void)viewDidLoad{
    [super viewDidLoad];
    
    //设置子视图
    [self setUpViews];
    
    //计算图片视图的高度
    [self calculateImageViewsHeightAll:YES];
}

- (void)dealloc{
    [LocalNotificationCenter shareInstance].selectPatient = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //导航栏透明
    self.navigationController.navigationBar.translucent = YES;
    [self setUpData];
}

#pragma mark - ********************* Private Method ***********************
- (void)setUpViews{
    self.title = @"添加预约";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    [self setRightBarButtonWithTitle:@"保存"];
}
#pragma mark 加载数据
- (void)setUpData{
    if (self.patient) {
        self.patientNameLabel.text = self.patient.patient_name;
    }else{
        self.patientNameLabel.text = [LocalNotificationCenter shareInstance].selectPatient.patient_name;
    }
}
#pragma mark  保存按钮点击
- (void)onRightButtonAction:(id)sender{
    
}

#pragma mark 计算图片视图的高度
- (void)calculateImageViewsHeightAll:(BOOL)all{
    if (all) {
        _ctImageHeight = [self imagesViewHeightWithImagesArray:self.ctImages superView:self.ctImagesSupView];
        _billImageHeight = [self imagesViewHeightWithImagesArray:self.billImages superView:self.checkBillImagesSupView];
    }else{
        if (self.isCtImage) {
            _ctImageHeight = [self imagesViewHeightWithImagesArray:self.ctImages superView:self.ctImagesSupView];
        }else{
            _billImageHeight = [self imagesViewHeightWithImagesArray:self.billImages superView:self.checkBillImagesSupView];
        }
    }
    
}

#pragma mark -计算当前一行能显示多少张图片
- (CGFloat)imagesViewHeightWithImagesArray:(NSArray *)images superView:(UIView *)superView{
    
    if (images.count == 0) {
        superView.hidden = YES;
        return 44;
    }
    superView.hidden = NO;
    //计算一行显示几张图片
    NSInteger count = (kScreenWidth - Margin) / (ImageWidth + Margin);
    //计算总共有几行
    NSInteger rows = 0;
    if (images.count > count) {
        rows = images.count % count == 0 ? images.count / count : images.count / count + 1;
    }else{
        rows = 1;
    }
    
    //移除所有子视图
    NSLog(@"subViews:%@",superView.subviews);
    for (UIView *view in superView.subviews) {
        if([view isKindOfClass:[UIImageView class]]){
            [view removeFromSuperview];
        }
    }
    
    for (int i = 0; i < images.count; i++) {
        int index_x = i / count;
        int index_y = i % count;
        
        CGFloat imageX = Margin + (Margin + ImageWidth) * index_y;
        CGFloat imageY = Margin + (Margin + ImageWidth) * index_x;
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:images[i]];
        imageView.layer.cornerRadius = 5;
        imageView.layer.masksToBounds = YES;
        imageView.frame = CGRectMake(imageX, imageY, ImageWidth, ImageWidth);
        [superView addSubview:imageView];
    }
    
    return rows * (ImageWidth + Margin) + Margin + 44;
}

#pragma mark 从相册获取图片
- (void)getImageFromAlbumIsCtLib:(BOOL)isCtLib{
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = 9;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups = NO;
    picker.delegate = self;
    
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 5;
        } else {
            return YES;
        }
    }];
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark 拍照获取图片
- (void)getImageFromCameraIsCtLib:(BOOL)isCtLib{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:^{
    }];
}


#pragma mark - ******************* Delegate / DataSource ******************
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        return _billImageHeight;
    }else if (indexPath.section == 3){
        return _ctImageHeight;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                //选择患者
                XLPatientSelectViewController *patientSelectVc = [[XLPatientSelectViewController alloc] init];
                patientSelectVc.patientStatus = PatientStatuspeAll;
                patientSelectVc.isYuYuePush = YES;
                patientSelectVc.hidesBottomBarWhenPushed = YES;
                [self pushViewController:patientSelectVc animated:YES];
            }else if (indexPath.row == 1){
                //选择牙位
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
                self.hengYaVC = [storyboard instantiateViewControllerWithIdentifier:@"XLHengYaViewController"];
                self.hengYaVC.delegate = self;
                self.hengYaVC.hengYaString = self.toothPositionLabel.text;
                [self.navigationController addChildViewController:self.hengYaVC];
                [self.navigationController.view addSubview:self.hengYaVC.view];
            }else{
                //选择预约事项
                XLReserveTypesViewController *reserceVC = [[XLReserveTypesViewController alloc] initWithStyle:UITableViewStylePlain];
                reserceVC.reserve_type = self.reserveTypeLabel.text;
                reserceVC.delegate = self;
                [self pushViewController:reserceVC animated:YES];
            }
            break;
        case 1:
            if (indexPath.row == 0) {
                //选择耗材
                ChooseMaterialViewController *materialVc = [[ChooseMaterialViewController alloc] init];
                materialVc.delegate = self;
                materialVc.clinicId = @"";
                materialVc.chooseMaterials = self.chooseMaterials;
                [self pushViewController:materialVc animated:YES];
            }else if (indexPath.row == 1){
                //选择助理
                ChooseAssistViewController *assistVc = [[ChooseAssistViewController alloc] init];
                assistVc.delegate = self;
                assistVc.clinicId = @"";
                assistVc.chooseAssists = self.chooseAssists;
                [self pushViewController:assistVc animated:YES];
            }else{
                //跳转到修改备注页面
                EditAllergyViewController *allergyVc = [[EditAllergyViewController alloc] init];
                allergyVc.title = @"备注";
                allergyVc.limit = 200;
                allergyVc.content = self.remarkLabel.text;
                allergyVc.type = EditAllergyViewControllerRemark;
                allergyVc.delegate = self;
                [self pushViewController:allergyVc animated:YES];
            }
            break;
        case 2:
        {
            //选择术前检查单图片
            UIActionSheet *actionsheet = [[UIActionSheet alloc]initWithTitle:@"添加术前检查单图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
            actionsheet.tag = 100;
            [actionsheet setActionSheetStyle:UIActionSheetStyleDefault];
            [actionsheet showInView:self.view];
        }
            break;
        case 3:
        {
            //选择CT片
            UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:@"添加CT片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
            actionsheet.tag = 200;
            [actionsheet setActionSheetStyle:UIActionSheetStyleDefault];
            [actionsheet showInView:self.view];
        }
            break;
    }
    
}

#pragma mark ChooseAssistViewControllerDelegate
- (void)chooseAssistViewController:(ChooseAssistViewController *)aController didSelectAssists:(NSArray *)assists{
    self.chooseAssists = assists;
    NSMutableString *str = [NSMutableString string];
    for (AssistCountModel *model in assists) {
        [str appendFormat:@"%@ x %ld,",model.assist_name,(long)model.num];
    }
    if (str.length > 0) {
        NSString *tempStr = [str substringToIndex:str.length - 1];
        self.assistentLabel.text = tempStr;
    }
}

#pragma mark ChooseMaterialViewControllerDelegate
- (void)chooseMaterialViewController:(ChooseMaterialViewController *)mController didSelectMaterials:(NSArray *)materials{
    self.chooseMaterials = materials;
    NSMutableString *str = [NSMutableString string];
    for (MaterialCountModel *model in materials) {
        [str appendFormat:@"%@ x %ld,",model.mat_name,(long)model.num - 1];
    }
    if (str.length > 0) {
        NSString *tempStr = [str substringToIndex:str.length];
        self.materialLabel.text = tempStr;
    }
}


#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex > 1) return;
    
    if (actionSheet.tag == 100) {
        self.isCtImage = NO;
        //选择术前检查单图片
        if (buttonIndex == 0) {
            [self getImageFromCameraIsCtLib:NO];
        }else{
            [self getImageFromAlbumIsCtLib:NO];
        }
        
    }else{
        self.isCtImage = YES;
        //选择CT片
        if (buttonIndex == 0) {
            [self getImageFromCameraIsCtLib:YES];
        }else{
            [self getImageFromAlbumIsCtLib:YES];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    WS(weakSelf);
    [picker dismissViewControllerAnimated:YES completion:^() {
        //压缩图片
        UIImage *resultImage = [UIImage imageCompressForSize:[info objectForKey:UIImagePickerControllerOriginalImage] targetSize:CGSizeMake(60, 60)];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakSelf.isCtImage) {
                [weakSelf.ctImages addObject:resultImage];
            }else{
                [weakSelf.billImages addObject:resultImage];
            }
            [weakSelf calculateImageViewsHeightAll:NO];
            [weakSelf.tableView reloadData];
        });
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - ZYQAssetPickerController Delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *array = [NSMutableArray array];
        for (int i=0; i<assets.count; i++) {
            ALAsset *asset=assets[i];
            UIImage *tempImg = [UIImage imageWithCGImage:asset.thumbnail];
            [array addObject:tempImg];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakSelf.isCtImage) {
                [weakSelf.ctImages addObjectsFromArray:array];
            }else{
                [weakSelf.billImages addObjectsFromArray:array];
            }
            [weakSelf calculateImageViewsHeightAll:NO];
            [weakSelf.tableView reloadData];
        });
    });
}

#pragma mark EditAllergyViewControllerDelegate
- (void)editViewController:(EditAllergyViewController *)editVc didEditWithContent:(NSString *)content type:(EditAllergyViewControllerType)type{
    
    if (content.length > 300) {
        [SVProgressHUD showImage:nil status:@"备注信息过长，请重新输入"];
        return;
    }
    self.remarkLabel.text = content;
}


#pragma mark XLReserveTypesViewControllerDelegate
- (void)reserveTypesViewController:(XLReserveTypesViewController *)vc didSelectReserveType:(NSString *)type{
    self.reserveTypeLabel.text = type;
}

#pragma mark HengYa And RuYa Deleate
-(void)removeHengYaVC{
    [self.hengYaVC willMoveToParentViewController:nil];
    [self.hengYaVC.view removeFromSuperview];
    [self.hengYaVC removeFromParentViewController];
}

- (void)queDingHengYa:(NSMutableArray *)hengYaArray toothStr:(NSString *)toothStr{
    
    if ([toothStr isEqualToString:@"未连续"]) {
        self.toothPositionLabel.text = [hengYaArray componentsJoinedByString:@","];
    }else{
        self.toothPositionLabel.text = toothStr;
    }
    
    [self removeHengYaVC];
}

- (void)queDingRuYa:(NSMutableArray *)ruYaArray toothStr:(NSString *)toothStr{
    if ([toothStr isEqualToString:@"未连续"]) {
        self.toothPositionLabel.text = [ruYaArray componentsJoinedByString:@","];
    }else{
        self.toothPositionLabel.text = toothStr;
    }
    [self removeRuYaVC];
}

-(void)removeRuYaVC{
    [self.ruYaVC willMoveToParentViewController:nil];
    [self.ruYaVC.view removeFromSuperview];
    [self.ruYaVC removeFromParentViewController];
}
-(void)changeToRuYaVC{
    [self removeHengYaVC];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    self.ruYaVC = [storyboard instantiateViewControllerWithIdentifier:@"XLRuYaViewController"];
    self.ruYaVC.delegate = self;
    self.ruYaVC.ruYaString = self.toothPositionLabel.text;
    [self.navigationController addChildViewController:self.ruYaVC];
    [self.navigationController.view addSubview:self.ruYaVC.view];
}
-(void)changeToHengYaVC{
    [self removeRuYaVC];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    self.hengYaVC = [storyboard instantiateViewControllerWithIdentifier:@"XLHengYaViewController"];
    self.hengYaVC.delegate = self;
    self.hengYaVC.hengYaString = self.toothPositionLabel.text;
    [self.navigationController addChildViewController:self.hengYaVC];
    [self.navigationController.view addSubview:self.hengYaVC.view];
}

#pragma mark - ********************* Lazy Method ***********************
- (NSMutableArray *)billImages{
    if (!_billImages) {
        _billImages = [NSMutableArray array];
    }
    return _billImages;
}

- (NSMutableArray *)ctImages{
    if (!_ctImages) {
        _ctImages = [NSMutableArray array];
    }
    return _ctImages;
}
@end
