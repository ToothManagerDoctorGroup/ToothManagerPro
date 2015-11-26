//
//  MenuTitleViewController.m
//  CRM
//
//  Created by Argo Zhang on 15/11/26.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "MenuTitleViewController.h"

@interface MenuTitleViewController ()
@property (nonatomic, strong)NSArray *dataList;
@end

@implementation MenuTitleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (instancetype)initWithStyle:(UITableViewStyle)style dataList:(NSArray *)dataList{
    if (self = [super initWithStyle:style]) {
        self.tableView.rowHeight = 44;
        self.dataList = dataList;
        
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"yuyue_title_menu_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    cell.textLabel.text = self.dataList[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *title = self.dataList[indexPath.row];
    
    if ([self.delegate respondsToSelector:@selector(titleViewController:didSelectTitle:type:)]) {
        [self.delegate titleViewController:self didSelectTitle:title type:self.type];
    }
}

@end
