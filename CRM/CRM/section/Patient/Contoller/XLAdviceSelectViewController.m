//
//  XLAdviceSelectViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/4/26.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLAdviceSelectViewController.h"
#import "XLAdviceDetailCell.h"
#import "XLAddAdviceViewController.h"
#import "XLTagView.h"
#import "XLAdviceDetailCell.h"
#import "UIColor+Extension.h"
#import "CRMMacro.h"
#import "CommonMacro.h"
#import <UITableView+SDAutoTableViewCellHeight.h>
#import <UIView+SDAutoLayout.h>
#import "DoctorTool.h"
#import "CRMHttpRespondModel.h"
#import "XLAdviceTypeModel.h"
#import "AccountManager.h"
#import "XLAdviceDetailModel.h"

@interface XLAdviceSelectViewController ()<UITableViewDataSource,UITableViewDelegate,XLTagViewDelegate,MGSwipeTableCellDelegate>{
    UITableView *_tableView;
}
@property (nonatomic, strong)NSMutableArray *tagList;
@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)XLAdviceTypeModel *selectTypeModel;
@end

@implementation XLAdviceSelectViewController
#pragma mark - ****************** Life Method *********************
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化子视图
    [self setUpViews];
    //添加通知
    [self addNotificationObserver];
}

- (void)dealloc{
    [self removeNotificationObserver];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - ********************* Private Method ***********************
- (void)onRightButtonAction:(id)sender{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PatientStoryboard" bundle:nil];
    XLAddAdviceViewController *addAdviceVc = [storyboard instantiateViewControllerWithIdentifier:@"XLAddAdviceViewController"];
    [self pushViewController:addAdviceVc animated:YES];
}

#pragma mark 添加通知
- (void)addNotificationObserver{
    [self addObserveNotificationWithName:MedicalAdviceAddSuccessNotification];
    [self addObserveNotificationWithName:MedicalAdviceUpdateSuccessNotification];
}
#pragma mark 移除通知
- (void)removeNotificationObserver{
    [self removeObserverNotificationWithName:MedicalAdviceDeleteSuccessNotification];
    [self removeObserverNotificationWithName:MedicalAdviceUpdateSuccessNotification];
}
#pragma mark 通知处理
- (void)handNotification:(NSNotification *)notifacation{
    
    NSString *adviceTypeId = nil;
    NSString *adviceTypeName = nil;
    if ([notifacation.name isEqualToString:MedicalAdviceAddSuccessNotification]) {
        XLAdviceTypeModel *model = notifacation.object;
        adviceTypeId = [model.keyId stringValue];
        adviceTypeName = model.type_name;
    }else if ([notifacation.name isEqualToString:MedicalAdviceUpdateSuccessNotification]){
        XLAdviceDetailModel *model = notifacation.object;
        adviceTypeId = [model.advice_type_id stringValue];
        adviceTypeName = model.advice_type_name;
    }
    
    if ([adviceTypeId isEqualToString:[self.selectTypeModel.keyId stringValue]]) {
        [self requestAdviceDetailAdviceId:adviceTypeId adviceName:adviceTypeName];
    }
}

#pragma mark 初始化子视图
- (void)setUpViews{
    self.title = @"选择医嘱";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    [self setRightBarButtonWithTitle:@"自定义"];
    self.view.backgroundColor = [UIColor colorWithHex:VIEWCONTROLLER_BACKGROUNDCOLOR];
    //初始化表示图
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor colorWithHex:VIEWCONTROLLER_BACKGROUNDCOLOR];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    [self.view addSubview:_tableView];
    
    //获取标签数据
    [self requestTagsData];
    
}
#pragma mark 添加标签视图
- (void)setUpTagViewsWithTagsArray:(NSArray *)tagsArray{
    UIView *header = [UIView new];
    
    UIView *topLine = [UIView new];
    topLine.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
    [header addSubview:topLine];
    
    XLTagFrame *frame = [[XLTagFrame alloc] init];
    frame.tagsMinPadding = 4;
    frame.tagsMargin = 10;
    frame.tagsLineSpacing = 10;
    frame.tagsArray = tagsArray;
    
    XLTagView *tagView = [[XLTagView alloc] init];
    tagView.backgroundColor = [UIColor colorWithHex:VIEWCONTROLLER_BACKGROUNDCOLOR];
    tagView.clickbool = YES;
    tagView.borderSize = 0.5;
    tagView.clickborderSize = 0.5;
    tagView.tagsFrame = frame;
    tagView.clickBackgroundColor = [UIColor colorWithHex:NAVIGATIONBAR_BACKGROUNDCOLOR];
    tagView.clickTitleColor = [UIColor colorWithHex:NAVIGATIONBAR_BACKGROUNDCOLOR];
    tagView.selectType = XLTagViewSelectTypeSingle;
    tagView.delegate = self;
    tagView.clickString = tagsArray[0];
    [header addSubview:tagView];
    
    UIView *bottomLine = [UIView new];
    bottomLine.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
    [header addSubview:bottomLine];
    
    topLine.sd_layout
    .topSpaceToView(header, 0)
    .leftSpaceToView(header, 0)
    .rightSpaceToView(header, 0)
    .heightIs(1);
    
    tagView.sd_layout
    .leftSpaceToView(header, 0)
    .topSpaceToView(topLine, 0)
    .rightSpaceToView(header, 0)
    .heightIs(frame.tagsHeight);
    
    //设置frame
    bottomLine.sd_layout
    .topSpaceToView(tagView, 0)
    .leftSpaceToView(header, 0)
    .rightSpaceToView(header, 0)
    .heightIs(1);
    
    [header setupAutoHeightWithBottomView:bottomLine bottomMargin:0];
    [header layoutSubviews];
    
    _tableView.tableHeaderView = header;
}

#pragma mark 加载标签视图数据
- (void)requestTagsData{
    //获取标签数据
    WS(weakSelf);
    [SVProgressHUD showWithStatus:@"正在加载"];
    [DoctorTool getMedicalAdviceTypeSuccess:^(NSArray *result) {
        [SVProgressHUD dismiss];
        [self.tagList addObjectsFromArray:result];
        NSMutableArray *tagsArray = [NSMutableArray array];
        for (XLAdviceTypeModel *model in result) {
            [tagsArray addObject:model.type_name];
        }
        [weakSelf setUpTagViewsWithTagsArray:tagsArray];
        
        XLAdviceTypeModel *model = [result firstObject];
        
        //查询指定类型下的所有医嘱
        weakSelf.selectTypeModel = model;
        [weakSelf requestAdviceDetailAdviceId:[model.keyId stringValue] adviceName:model.type_name];
        
    } failure:^(NSError *error) {
        [SVProgressHUD showImage:nil status:error.localizedDescription];
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}

#pragma mark 查询指定类型下的所有医嘱
- (void)requestAdviceDetailAdviceId:(NSString *)adviceId adviceName:(NSString *)adviceName{
    WS(weakSelf);
    [SVProgressHUD showWithStatus:@"正在加载"];
    [DoctorTool getMedicalAdviceOfTypeByDoctorId:[AccountManager currentUserid] ckeyid:@"" keyWord:@"" adviceId:adviceId adviceName:adviceName success:^(NSArray *result) {
        [SVProgressHUD dismiss];
        
        [weakSelf.dataList removeAllObjects];
        [weakSelf.dataList addObjectsFromArray:result];
        
        [_tableView reloadData];
        
    } failure:^(NSError *error) {
        [SVProgressHUD showImage:nil status:error.localizedDescription];
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}
#pragma mark 删除某一行数据
-(void) deleteAdvice:(NSIndexPath *) indexPath
{
    WS(weakSelf);
    [SVProgressHUD showWithStatus:@"正在删除"];
    XLAdviceDetailModel *model = self.dataList[indexPath.row];
    [DoctorTool deleteMedicalAdviceOfTypeByCkeyId:model.ckeyid success:^(CRMHttpRespondModel *respond) {
        if ([respond.code integerValue] == 200) {
            [SVProgressHUD showImage:nil status:@"删除成功"];
            [weakSelf.dataList removeObjectAtIndex:indexPath.row];
            [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            [_tableView reloadData];
        }else{
            [SVProgressHUD showImage:nil status:@"删除失败"];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showImage:nil status:error.localizedDescription];
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}

#pragma mark - ********************* Delegate / DataSource *********************
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    XLAdviceDetailModel *model = self.dataList[indexPath.row];
    return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[XLAdviceDetailCell class] contentViewWidth:[XLAdviceDetailCell contentMaxWidth]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XLAdviceDetailCell *cell = [XLAdviceDetailCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.model = self.dataList[indexPath.row];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XLAdviceDetailModel *model = self.dataList[indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(adviceSelectViewController:didSelectAdviceContent:)]) {
        [self.delegate adviceSelectViewController:self didSelectAdviceContent:model.a_content];
    }
    [self popViewControllerAnimated:YES];
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    // 下面这几行代码是用来设置cell的上下行线的位置
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}

#pragma mark XLTagViewDelegate
- (void)tagView:(XLTagView *)tagView tagArray:(NSArray *)tagArray{
    NSInteger index = [[tagArray firstObject] integerValue];
    XLAdviceTypeModel *model = self.tagList[index];
    self.selectTypeModel = model;
    [self requestAdviceDetailAdviceId:[model.keyId stringValue] adviceName:model.type_name];
}

#pragma mark Swipe Delegate

-(BOOL) swipeTableCell:(MGSwipeTableCell*) cell canSwipe:(MGSwipeDirection) direction;
{
    return YES;
}

-(NSArray*) swipeTableCell:(MGSwipeTableCell*) cell swipeButtonsForDirection:(MGSwipeDirection)direction
             swipeSettings:(MGSwipeSettings*) swipeSettings expansionSettings:(MGSwipeExpansionSettings*) expansionSettings
{
    
    swipeSettings.transition = MGSwipeTransitionBorder;
    expansionSettings.buttonIndex = 0;
    
    WS(weakSelf);
    if (direction != MGSwipeDirectionLeftToRight){
        
        expansionSettings.fillOnTrigger = YES;
        expansionSettings.threshold = 1.1;
        
        CGFloat padding = 15;
        
        MGSwipeButton * trash = [MGSwipeButton buttonWithTitle:@"删除" backgroundColor:[UIColor colorWithRed:1.0 green:59/255.0 blue:50/255.0 alpha:1.0] padding:padding callback:^BOOL(MGSwipeTableCell *sender) {
            
            NSIndexPath * indexPath = [_tableView indexPathForCell:sender];
            TimAlertView *alertView = [[TimAlertView alloc] initWithTitle:@"是否删除此医嘱？" message:nil cancelHandler:^{
            } comfirmButtonHandlder:^{
                [weakSelf deleteAdvice:indexPath];
            }];
            [alertView show];
            
            return NO;
        }];
        
        MGSwipeButton * more = [MGSwipeButton buttonWithTitle:@"编辑" backgroundColor:[UIColor colorWithRed:200/255.0 green:200/255.0 blue:205/255.0 alpha:1.0] padding:padding callback:^BOOL(MGSwipeTableCell *sender) {
            
            NSIndexPath *indexPath = [_tableView indexPathForCell:sender];
            XLAdviceDetailModel *model = self.dataList[indexPath.row];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PatientStoryboard" bundle:nil];
            XLAddAdviceViewController *addAdviceVc = [storyboard instantiateViewControllerWithIdentifier:@"XLAddAdviceViewController"];
            addAdviceVc.isEdit = YES;
            addAdviceVc.model = model;
            [weakSelf pushViewController:addAdviceVc animated:YES];
            
            return YES;
        }];
        
        return @[trash, more];
    }
    
    return nil;
    
}

#pragma mark - ********************* Lazy Method ***********************
- (NSMutableArray *)dataList{

    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}
- (NSMutableArray *)tagList{
    if (!_tagList) {
        _tagList = [NSMutableArray array];
    }
    return _tagList;
}


@end
