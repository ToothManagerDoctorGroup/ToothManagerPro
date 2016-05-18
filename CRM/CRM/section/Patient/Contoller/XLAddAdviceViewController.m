//
//  XLAddAdviceViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/4/27.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLAddAdviceViewController.h"
#import "XLTextViewPlaceHolder.h"
#import "XLAdviceTypeSelectViewController.h"
#import "XLAdviceTypeModel.h"
#import "DoctorTool.h"
#import "XLAdviceDetailModel.h"
#import "CRMHttpRespondModel.h"

@interface XLAddAdviceViewController ()<XLAdviceTypeSelectViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *adviceTypeLabel;
@property (weak, nonatomic) IBOutlet XLTextViewPlaceHolder *adviceContentTextView;
@property (weak, nonatomic) IBOutlet UILabel *limitLabel;

@property (nonatomic, strong)XLAdviceTypeModel *currentModel;

@end

@implementation XLAddAdviceViewController
@synthesize adviceContentTextView,adviceTypeLabel,limitLabel;

#pragma mark - ********************* Life Method *********************

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib{
    NSLog(@"awakeFromNib");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置子视图样式
    [self setUpViews];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - ********************** Private Method ********************

- (void)onRightButtonAction:(id)sender{
    
    if (self.isEdit) {
        if (self.adviceContentTextView.text.length == 0) {
            [SVProgressHUD showImage:nil status:@"请输入医嘱内容"];
            return;
        }
        
        //编辑医嘱
        WS(weakSelf);
        self.model.a_content = self.adviceContentTextView.text;
        [SVProgressHUD showWithStatus:@"正在修改"];
        [DoctorTool editMedicalAdviceOfTypeByAdviceDetailModel:self.model success:^(CRMHttpRespondModel *respond) {
            if ([respond.code integerValue] == 200) {
                [SVProgressHUD showImage:nil status:@"修改成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //发送通知
                    [weakSelf postNotificationName:MedicalAdviceUpdateSuccessNotification object:weakSelf.model];
                    [weakSelf popViewControllerAnimated:YES];
                });
            }else{
                [SVProgressHUD showImage:nil status:respond.result];
            }
        } failure:^(NSError *error) {
            [SVProgressHUD showImage:nil status:error.localizedDescription];
            if (error) {
                NSLog(@"error:%@",error);
            }
        }];
    }else {
        //保存医嘱
        if (!self.currentModel) {
            [SVProgressHUD showImage:nil status:@"请选择医嘱类型"];
            return;
        }
        
        if (self.adviceContentTextView.text.length == 0) {
            [SVProgressHUD showImage:nil status:@"请输入医嘱内容"];
            return;
        }
        
        XLAdviceDetailModel *model = [[XLAdviceDetailModel alloc] initWithName:self.currentModel.type_name adviceTypeId:self.currentModel.keyId adviceTypeName:self.currentModel.type_name contentType:@"text" content:self.adviceContentTextView.text];
        [SVProgressHUD showWithStatus:@"正在创建"];
        WS(weakSelf);
        [DoctorTool addNewMedicalAdviceOfTypeByAdviceDetailModel:model success:^(CRMHttpRespondModel *respond) {
            if ([respond.code integerValue] == 200) {
                //创建成功
                [SVProgressHUD showSuccessWithStatus:@"创建成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //发送通知
                    [weakSelf postNotificationName:MedicalAdviceAddSuccessNotification object:weakSelf.currentModel];
                    [weakSelf popViewControllerAnimated:YES];
                });
                
            }else{
                [SVProgressHUD showImage:nil status:respond.result];
            }
        } failure:^(NSError *error) {
            [SVProgressHUD showImage:nil status:error.localizedDescription];
            if (error) {
                NSLog(@"error:%@",error);
            }
        }];
    }
}

#pragma mark 设置子视图样式
- (void)setUpViews{
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    if (self.isEdit) {
        self.title = @"编辑医嘱";
        self.adviceContentTextView.text = self.model.a_content;
        self.adviceTypeLabel.text = self.model.advice_type_name;
        [self textChanged];
    }else{
        self.title = @"添加医嘱";
    }
    
    [self setRightBarButtonWithTitle:@"保存"];
    //添加通知，监听textView的内容的变化
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChanged) name:UITextViewTextDidChangeNotification object:nil];
    
    adviceContentTextView.placeHolder = @"请输入医嘱内容";
}
//监听textView内容的变化
- (void)textChanged{
    //判断是否有内容
    if (adviceContentTextView.text.length) {
        //隐藏placeHolder
        adviceContentTextView.hidePlaceHolder = YES;
    }else{
        adviceContentTextView.hidePlaceHolder = NO;
    }
    
    NSInteger number = [adviceContentTextView.text length];
    if (number > 500) {
        adviceContentTextView.text = [adviceContentTextView.text substringToIndex:500];
        number = 500;
    }
    limitLabel.text = [NSString stringWithFormat:@"还可输入%ld个字",500 - (long)number];
    
}

#pragma mark - *********************** Delegate / DataSource ******************
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.isEdit) {
        if (indexPath.section == 0) {
            //选择医嘱类型
            XLAdviceTypeSelectViewController *typeSelectVc = [[XLAdviceTypeSelectViewController alloc] initWithStyle:UITableViewStyleGrouped];
            typeSelectVc.currentModel = self.currentModel;
            typeSelectVc.delegate = self;
            [self pushViewController:typeSelectVc animated:YES];
            
        }
    }
}
#pragma mark XLAdviceTypeSelectViewControllerDelegate
- (void)adviceTypeSelectViewController:(XLAdviceTypeSelectViewController *)selectVC didSelectTypeModel:(XLAdviceTypeModel *)model{
    adviceTypeLabel.text = model.type_name;
    self.currentModel = model;
}

#pragma mark UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [adviceContentTextView resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

@end
