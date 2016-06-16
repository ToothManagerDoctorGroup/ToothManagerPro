//
//  ChooseAssistViewController.m
//  CRM
//
//  Created by Argo Zhang on 15/11/24.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "ChooseAssistViewController.h"
#import "ChooseAssistCell.h"
#import "AssistCountModel.h"
#import "MyClinicTool.h"

@interface ChooseAssistViewController ()<UITableViewDataSource,UITableViewDelegate,ChooseAssistCellDelegate>{
    UITableView *_tableView; //表视图
    UIView *_bottomSuperView; //底部的视图
    UIView *_bottomLineView;//分割线
    UILabel *_totalPriceLabel;//总价格
    
}

@property (nonatomic, assign)float allPrice; //总价格

@property (nonatomic, strong)NSArray *dataList;

@property (nonatomic, assign)NSInteger totalNum; //总数

@property (nonatomic, strong)NSMutableArray *selectAssists;

@end

@implementation ChooseAssistViewController

#pragma mark -
#pragma mark -懒加载
- (NSArray *)dataList{
    if (!_dataList ) {
        
        _dataList = [NSArray array];
    }
    return _dataList;
}

- (NSMutableArray *)selectAssists{
    if (!_selectAssists) {
        _selectAssists = [NSMutableArray array];
    }
    return _selectAssists;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化导航栏
    [self setUpNavBarStyle];
    
    //初始化子视图
    [self setUpSubViews];
    
    //请求网络数据
    [self requestAssistData];
}
#pragma mark -
#pragma mark -初始化导航栏
- (void)setUpNavBarStyle{
    //初始化导航栏
    [super initView];
    self.title = @"选择助手";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    [self setRightBarButtonWithTitle:@"完成"];
}

#pragma mark -右侧按钮点击
- (void)onRightButtonAction:(id)sender{
    for (AssistCountModel *model in self.dataList) {
        if (model.num > 0) {
            [self.selectAssists addObject:model];
        }
    }
    
    //调用代理方法
    if ([self.delegate respondsToSelector:@selector(chooseAssistViewController:didSelectAssists:)]) {
        [self.delegate chooseAssistViewController:self didSelectAssists:self.selectAssists];
    }
    
    //关闭当前视图
    [self popViewControllerAnimated:YES];
    
}

#pragma mark -初始化子视图
- (void)setUpSubViews{
    //表示图
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 44) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    //底部父视图
    _bottomSuperView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 64 - 44, kScreenWidth, 44)];
    _bottomSuperView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomSuperView];
    //底部分割线
    _bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    _bottomLineView.backgroundColor = [UIColor grayColor];
    [_bottomSuperView addSubview:_bottomLineView];
    //总价格视图
    NSString *totalPrice = [NSString stringWithFormat:@"总价: %@元",@"0.0"];
    _totalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 10, 43)];
    _totalPriceLabel.text = totalPrice;
    _totalPriceLabel.textAlignment = NSTextAlignmentRight;
    _totalPriceLabel.textColor = [UIColor blueColor];
    _totalPriceLabel.font = [UIFont systemFontOfSize:16];
    [_bottomSuperView addSubview:_totalPriceLabel];
    
}
#pragma mark -请求网络数据
- (void)requestAssistData{
    
    [MyClinicTool getAssistentListWithClinicId:self.clinicId success:^(NSArray *result) {
        //设置数据
        self.dataList = result;
        
        //请求网络数据成功后
        if (self.chooseAssists.count > 0 && self.chooseAssists) {
            for (AssistCountModel *selectModel in self.chooseAssists) {
                for (AssistCountModel *model in self.dataList) {
                    if ([model.keyId isEqualToString:selectModel.keyId]) {
                        model.num = selectModel.num;
                    }
                }
            }
        }
        //计算总价格
        [self totalPrice];
        //刷新表格
        [_tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error);
    }];
}


#pragma mark -
#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AssistCountModel *model = self.dataList[indexPath.row];

    ChooseAssistCell *cell = [ChooseAssistCell assistCellWithTableView:tableView];
    cell.delegate = self;
    
    cell.assistModel = model;

    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark -ChooseAssistCellDelegate
- (void)btnClick:(ChooseAssistCell *)cell andFlag:(int)flag{
    
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    AssistCountModel *model = self.dataList[indexPath.row];
    switch (flag) {
        case 110:
            //加
            model.num++;
            break;
            
        case 100:
            //减
            if (model.num > 0) {
                model.num--;
            }
            break;
        default:
            break;
    }
    
    [_tableView reloadData];
    
    [self totalPrice];

}

#pragma mark -- 计算价格
-(void)totalPrice
{
    //遍历整个数据源，然后判断如果是选中的商品，就计算价格（单价 * 商品数量）
    for ( int i =0; i< self.dataList.count; i++)
    {
        AssistCountModel *model = [self.dataList objectAtIndex:i];
        _allPrice = _allPrice + model.num * [model.assist_price intValue];

    }
    
    //给总价文本赋值
    _totalPriceLabel.text = [NSString stringWithFormat:@"总价: %.f元",_allPrice];
    
    //每次算完要重置为0，因为每次的都是全部循环算一遍
    _allPrice = 0.0;
}



@end
