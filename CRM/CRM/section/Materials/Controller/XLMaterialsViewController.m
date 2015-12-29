//
//  XLMaterialsViewController.m
//  CRM
//
//  Created by Argo Zhang on 15/12/26.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "XLMaterialsViewController.h"
#import "NewMaterialsViewController.h"
#import "CRMMacro.h"
#import "UIColor+Extension.h"
#import "MaterialTableViewCell.h"
#import "ChineseSearchEngine.h"
#import "DBManager+Materials.h"
#import "MaterialDetailViewController.h"
#import "UISearchBar+XLMoveBgView.h"
#import "EMSearchBar.h"
#import "EMSearchDisplayController.h"

@interface XLMaterialsViewController () <UISearchBarDelegate,UISearchDisplayDelegate>
{
    UITableView *_tableView;
}

@property (nonatomic, strong)EMSearchBar *searchBar;
@property (nonatomic, strong)EMSearchDisplayController *searchController;

@end

@implementation XLMaterialsViewController

#pragma mark - 界面销毁
- (void)dealloc{
    self.searchBar = nil;
    self.searchController = nil;
    _tableView = nil;
}

#pragma mark - 控件初始化
- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[EMSearchBar alloc] initWithFrame: CGRectMake(0, 0, kScreenWidth, 44)];
        _searchBar.delegate = self;
        _searchBar.placeholder = NSLocalizedString(@"search", @"Search");
        [_searchBar moveBackgroundView];
    }
    
    return _searchBar;
}

- (EMSearchDisplayController *)searchController
{
    if (_searchController == nil) {
        _searchController = [[EMSearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
        _searchController.delegate = self;
        _searchController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _searchController.searchResultsTableView.tableFooterView = [[UIView alloc] init];
        
        __weak XLMaterialsViewController *weakSelf = self;
        [_searchController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            
            return [weakSelf setUpTableViewCellWithTableView:tableView indexPath:indexPath sourceArray:weakSelf.searchController.resultsSource];
        }];
        
        [_searchController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return 40;
        }];
        
        [_searchController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [weakSelf.searchController.searchBar endEditing:YES];
            [weakSelf selectTableViewCellWithTableView:tableView indexPath:indexPath sourceArray:weakSelf.searchController.resultsSource];
            
        }];
        
        [_searchController setCanEditRowAtIndexPath:^BOOL(UITableView *tableView, NSIndexPath *indexPath) {
            
//            if (weakSelf.searchController.editingStyle == UITableViewCellEditingStyleDelete) {
//                [weakSelf deleteMaterialWithIndexPath:indexPath tableView:tableView sourceArray:weakSelf.searchController.resultsSource];
//            }
            
            return NO;
        }];
    }
    return _searchController;
}

- (void)viewDidLoad{
    [super viewDidLoad];
}

- (void)initView
{
    [super initView];
    self.title = @"种植体";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    [self setRightBarButtonWithImage:[UIImage imageNamed:@"btn_new"]];
    self.view.backgroundColor = [UIColor whiteColor];
    //初始化表示图
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, self.view.height - 44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
    
    //初始化搜索框
    [self.view addSubview:self.searchBar];
    [self searchController];
    
}
- (void)refreshView {
    [_tableView reloadData];
}

- (void)initData
{
    dataArray = [[DBManager shareInstance] getAllMaterials];
}

- (void)refreshData {
    dataArray = nil;
    dataArray = [[DBManager shareInstance] getAllMaterials];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self refreshData];
}

- (void)addNotificationObserver {
    [super addNotificationObserver];
    [self addObserveNotificationWithName:MaterialCreatedNotification];
    [self addObserveNotificationWithName:MaterialEditedNotification];
}

- (void)removeNotificationObserver {
    [super removeNotificationObserver];
    [self removeObserverNotificationWithName:MaterialEditedNotification];
    [self removeObserverNotificationWithName:MaterialCreatedNotification];
}

- (void)handNotification:(NSNotification *)notifacation {
    [super handNotification:notifacation];
    if ([notifacation.name isEqualToString:MaterialCreatedNotification] ||
        [notifacation.name isEqualToString:MaterialEditedNotification]) {
        [self refreshData];
        [self refreshView];
    }
}

#pragma mark - Button Action
- (void)onRightButtonAction:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    NewMaterialsViewController * newMaterialsCtl = [storyboard instantiateViewControllerWithIdentifier:@"NewMaterialsViewController"];
    [self pushViewController:newMaterialsCtl animated:YES];
}

#pragma mark - UITableView Delegate

-  (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self setUpTableViewCellWithTableView:tableView indexPath:indexPath sourceArray:dataArray];
}
//增加的表头
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    bgView.backgroundColor = MyColor(238, 238, 238);
    
    UIButton *nameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nameButton setTitle:@"种植体名称" forState:UIControlStateNormal];
    [nameButton setFrame:CGRectMake(20, 0, 100, 40)];
    [nameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    nameButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:nameButton];
    
    UIButton *introducerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [introducerButton setTitle:@"价格" forState:UIControlStateNormal];
    [introducerButton setFrame:CGRectMake(160, 0, 60, 40)];
    [introducerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    introducerButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:introducerButton];
    
    UIButton *numberButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [numberButton setTitle:@"类型" forState:UIControlStateNormal];
    [numberButton setFrame:CGRectMake(255, 0, 60, 40)];
    [numberButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    numberButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:numberButton];
    
    return bgView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self selectTableViewCellWithTableView:tableView indexPath:indexPath sourceArray:dataArray];
}

-(UIImage *)drawRoundWithNum:(NSInteger)row
{
    NSString * numString = nil; //圆圈里面的数字
    if (row + 1 < 10){  //需求里面是个位数的时候，前面要补0
        numString = [NSString stringWithFormat:@"0%ld",row + 1];
    }else{
        numString = [NSString stringWithFormat:@"%ld",row + 1];
    }
    double width=80.0f;
    //圆的背景颜色
    UIColor * color=[UIColor colorWithRed:94.0f / 255.0f green:170.0f / 255.0f blue:235.0f / 255.0f alpha:1];
    //中间字的颜色
    UIColor * color1 = [UIColor whiteColor];
    
    UIGraphicsEndImageContext();
    
    UIImage * roundImage = [[UIImage alloc]init];
    UIImage * roundAndNumImage = nil;
    //画圆
    UIGraphicsBeginImageContext(CGSizeMake(width, width));
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(ctx, 0, 0);
    CGContextSetFillColorWithColor(ctx, color.CGColor);
    UIFont * font = [UIFont systemFontOfSize:40.0f];
    CGContextAddArc(ctx, width/2, width/2, width/2.5, 0, 6.3, 0);
    CGContextFillPath(ctx);
    //取得图片
    roundImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //在画好的圆圈中写中间的数字
    UIGraphicsBeginImageContext(roundImage.size);
    CGContextRef ctx1 = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx1, color1.CGColor);
    [roundImage drawAtPoint:CGPointZero];
    [numString drawAtPoint:CGPointMake(roundImage.size.width / 4, roundImage.size.height / 5) withFont:font];
    roundAndNumImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return roundAndNumImage;
}

//tableview editing
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteMaterialWithIndexPath:indexPath tableView:tableView sourceArray:dataArray];
    }
}
#pragma mark -设置单元格点击事件
- (void)selectTableViewCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath sourceArray:(NSArray *)sourceArray{
    Material *material = [sourceArray objectAtIndex:indexPath.row];
    
    if(self.mode == XLMaterialViewModeSelect) {
        if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectedMaterial:)]) {
            [self.delegate didSelectedMaterial:material];
        }
        [self popViewControllerAnimated:YES];
    } else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
        NewMaterialsViewController *meterialDetailVC = [storyboard instantiateViewControllerWithIdentifier:@"NewMaterialsViewController"];
        meterialDetailVC.edit = YES;
        meterialDetailVC.materialId = material.ckeyid;
        [self pushViewController:meterialDetailVC animated:YES];
    }
}
#pragma mark -设置单元格
- (UITableViewCell *)setUpTableViewCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath sourceArray:(NSArray *)sourceArray{
    //cell选中时的背景颜色要与圆圈的背景颜色一致
    UIColor * seleColor = [UIColor colorWithRed:94.0f / 255.0f green:170.0f / 255.0f blue:235.0f / 255.0f alpha:1];
    static NSString * ideString = @"materialCell";
    MaterialTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ideString];
    if (cell == nil) {
        cell = [[MaterialTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ideString];
        //cell的背景颜色
        [cell.contentView setBackgroundColor:[UIColor whiteColor]];
        //设置选中之后的颜色
        cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
        [cell.selectedBackgroundView setBackgroundColor:seleColor];
    }
    
    //赋值
    [cell.imageView setImage:[self drawRoundWithNum:indexPath.row]];
    Material *material = [sourceArray objectAtIndex:indexPath.row];
    [cell.info_lable setText:material.mat_name];
    [cell.price_label setText:[NSString stringWithFormat:@"%.2f",material.mat_price]];
    if(material.mat_type == 1){
        [cell.type_label setText:@"其他"];
    }else{
        [cell.type_label setText:@"种植体"];
    }
    return cell;
}
#pragma mark -删除材料信息
- (void)deleteMaterialWithIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView sourceArray:(NSArray *)sourceArray{
    TimAlertView *alertView = [[TimAlertView alloc]initWithTitle:@"确认删除？" message:nil  cancelHandler:^{
        [tableView reloadData];
    } comfirmButtonHandlder:^{
        Material *material = [sourceArray objectAtIndex:indexPath.row];
        BOOL ret = [[DBManager shareInstance] deleteMaterialWithId:material.ckeyid];
        if (ret) {
            [self refreshData];
            [self refreshView];
        }
    }];
    [alertView show];
}

#pragma mark - UISearchBar Delegates

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSArray *searchResults;
    if ([searchText isNotEmpty]) {
        searchResults = [ChineseSearchEngine resultArraySearchMaterialOnArray:dataArray withSearchText:searchText];
        [self.searchController.resultsSource removeAllObjects];
        [self.searchController.resultsSource addObjectsFromArray:searchResults];
        [self.searchController.searchResultsTableView reloadData];
    }
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end