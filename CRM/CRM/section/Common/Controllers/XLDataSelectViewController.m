//
//  XLDataSelectViewController.m
//  CRM
//
//  Created by Argo Zhang on 15/12/28.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "XLDataSelectViewController.h"
#import "UIColor+Extension.h"
#import "CommonMacro.h"

@interface XLDataSelectViewController ()

@property (nonatomic, strong)NSArray *dataList;

@end

@implementation XLDataSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MyColor(245, 245, 245);
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"back"]];
    //设置数据项
    if (self.type == XLDataSelectViewControllerSex) {
        //性别
        self.dataList = @[@"男",@"女"];
        self.title = @"性别";
    }else if (self.type == XLDataSelectViewControllerDepartment){
        //科室
        self.dataList = @[@"口腔综合科",@"口腔科",@"正畸科",@"儿童口腔科",@"颌面外科",@"牙周科",@"牙体牙髓科",@"口腔黏膜科",@"种植科",@"口腔预防科",@"其他"];
        self.title = @"科室";
    }else if(self.type == XLDataSelectViewControllerHospital){
        //医院
        self.title = @"医院";
    }else if (self.type == XLDataSelectViewControllerProfressional){
        //职称
        self.dataList = @[@"医师",@"主治医师",@"副主任医师",@"主任医师"];
        self.title = @"职称";
    }else if (self.type == XLDataSelectViewControllerDegree){
        //学历
        self.dataList = @[@"大专",@"本科",@"硕士",@"博士"];
        self.title = @"学历";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableView Delegate/dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"select_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
    }
    
    cell.textLabel.text = self.dataList[indexPath.row];
    
    if (self.dataList[indexPath.row] != nil && [self.dataList[indexPath.row] isEqualToString:self.currentContent]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *selectContent = self.dataList[indexPath.row];
    self.currentContent = selectContent;
    [self.tableView reloadData];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(dataSelectViewController:didSelectContent:type:)]) {
        [self.delegate dataSelectViewController:self didSelectContent:selectContent type:self.type];
    }
    
    [self popViewControllerAnimated:YES];
}
@end
