//
//  XLTemplateDetailViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/1/26.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLTemplateDetailViewController.h"
#import "UIColor+Extension.h"
#import "XLMessageTemplateModel.h"
#import "AccountManager.h"
#import "NSString+TTMAddtion.h"
#import "XLMessageTemplateTool.h"
#import "XLMessageTemplateParam.h"
#import "MBProgressHUD+Add.h"

@interface XLTemplateDetailViewController ()<UITextFieldDelegate,UITextViewDelegate>{
    UILabel *_limitLabel;
}

@property (nonatomic, weak)UITextField *messageTypeField;
@property (nonatomic, weak)UITextView *messageContentView;
@property (nonatomic, weak)UIView *headerView;//头视图
@property (nonatomic, weak)UIView *footerView;//尾视图

@end

@implementation XLTemplateDetailViewController

- (UIView *)footerView{
    if (!_footerView) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
        footerView.backgroundColor = [UIColor clearColor];
        if (!self.isSystem) {
            self.tableView.tableFooterView = footerView;
        }
        
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        deleteBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        deleteBtn.frame = CGRectMake(10, 10, kScreenWidth - 20, 40);
        deleteBtn.layer.cornerRadius = 5;
        deleteBtn.layer.masksToBounds = YES;
        deleteBtn.backgroundColor = [UIColor colorWithHex:0xff5050];
        [deleteBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:deleteBtn];
    }
    return _footerView;
}

- (UIView *)headerView{
    if (!_headerView) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 300)];
        headerView.backgroundColor = [UIColor whiteColor];
        _headerView = headerView;
        self.tableView.tableHeaderView = headerView;
        
        UITextField *messageTypeField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth, 50)];
        messageTypeField.textColor = [UIColor colorWithHex:0x333333];
        messageTypeField.font = [UIFont systemFontOfSize:15];
        messageTypeField.placeholder = @"请输入预约事项";
        messageTypeField.delegate = self;
        messageTypeField.returnKeyType = UIReturnKeyDone;
        _messageTypeField = messageTypeField;
        [headerView addSubview:messageTypeField];
        
        //添加标题视图
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, kScreenWidth, 50)];
        titleView.backgroundColor = MyColor(238, 238, 238);
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth - 20, 50)];
        titleLabel.text = @"给患者的提醒";
        titleLabel.textColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.backgroundColor = [UIColor colorWithHex:VIEWCONTROLLER_BACKGROUNDCOLOR];
        [titleView addSubview:titleLabel];
        [headerView addSubview:titleView];
        
        UITextView *messageContentView = [[UITextView alloc] initWithFrame:CGRectMake(10, 100, kScreenWidth - 20, 150)];
        messageContentView.textColor = [UIColor colorWithHex:0x333333];
        messageContentView.font = [UIFont systemFontOfSize:15];
        messageContentView.delegate = self;
        messageContentView.returnKeyType = UIReturnKeyDone;
        _messageContentView = messageContentView;
        [headerView addSubview:messageContentView];
        //添加通知，监听textView的内容的变化
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged) name:UITextViewTextDidChangeNotification object:nil];
        
        //内容限制视图
        NSString *limitStr = @"还可输入5000个字";
        CGSize limitSzie = [limitStr measureFrameWithFont:[UIFont systemFontOfSize:12] size:CGSizeMake(MAXFLOAT, 20)].size;
        _limitLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - limitSzie.width - 5, messageContentView.bottom - 20, limitSzie.width, 20)];
        _limitLabel.textColor = [UIColor colorWithHex:0xbbbbbb];
        _limitLabel.font = [UIFont systemFontOfSize:12];
        _limitLabel.text = limitStr;
        [headerView addSubview:_limitLabel];

        //添加提醒视图
        UIView *tintView = [[UIView alloc] initWithFrame:CGRectMake(0, messageContentView.bottom, kScreenWidth, 50)];
        tintView.backgroundColor = [UIColor colorWithHex:VIEWCONTROLLER_BACKGROUNDCOLOR];
        [headerView addSubview:tintView];
        if (!self.hindTintView) {
            NSString *tint = @"特别说明：蓝色部分请勿修改，添加预约时系统会自动填写！";
            CGSize tintSize = [tint sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(kScreenWidth - 20, MAXFLOAT)];
            UILabel *tintLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, tintSize.height)];
            tintLabel.textColor = [UIColor colorWithHex:0x00a0ea];
            tintLabel.font = [UIFont systemFontOfSize:15];
            tintLabel.text = tint;
            tintLabel.numberOfLines = 0;
            [tintView addSubview:tintLabel];
        }
        
        //添加分割线
        for (int i = 0; i < 4; i++) {
            UIView *divider = [[UIView alloc] init];
            if (i == 3) {
                divider.frame = CGRectMake(0, 249, kScreenWidth, 1);
            }else{
                divider.frame = CGRectMake(0, i * 50, kScreenWidth, 1);
            }
            
            divider.backgroundColor = [UIColor colorWithHex:0xdddddd];
            
            [headerView addSubview:divider];
        }
    }
    return _headerView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏样式
    [self setUpNavStyle];
    //初始化子视图
    [self setUpSubViews];
    //设置数据
    [self setUpData];
}

#pragma mark - 设置导航栏样式
- (void)setUpNavStyle{
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setRightBarButtonWithTitle:@"保存"];
}
#pragma mark - 初始化子视图
- (void)setUpSubViews{
    [self headerView];
    [self footerView];
    if (self.isEdit) {
        self.messageTypeField.enabled = NO;
    }
}
#pragma mark - 设置数据
- (void)setUpData{
    if (self.isEdit) {
        self.title = self.model.message_name;
        self.messageTypeField.text = self.model.message_name;
        self.messageContentView.attributedText = [self changeStrColorWithSourceStr:self.model.message_content];
        //计算文字的个数
        _limitLabel.text = [NSString stringWithFormat:@"还可输入%d个字",500 - (int)self.model.message_content.length];
    }else{
        self.title = @"新增预约事项";
        NSString *content = [NSString stringWithFormat:@"您好，我是{5}医生。您已成功预约{6}{7}，请按时就诊，如有疑问或时间变动，请提前联系。"];
        self.messageContentView.attributedText = [self changeStrColorWithSourceStr:content];
        //计算文字的个数
        _limitLabel.text = [NSString stringWithFormat:@"还可输入%d个字",500 - (int)content.length];
    }
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //设置键盘响应者
    if (self.isEdit) {
        [self.messageContentView becomeFirstResponder];
    }else{
        [self.messageTypeField becomeFirstResponder];
    }
}

#pragma mark - 设置按钮是否可点
- (void)setButtonEnable:(BOOL)enable{
    self.navigationItem.rightBarButtonItem.enabled = enable;
}

#pragma mark - 保存按钮点击
- (void)onRightButtonAction:(id)sender{
    if (self.messageTypeField.text.length == 0) {
        [SVProgressHUD showImage:nil status:@"请输入提醒事项"];
        return;
    }
    if ([self.messageTypeField.text isValidLength:32]) {
        [SVProgressHUD showImage:nil status:@"提醒事项过长，请重新输入"];
        return;
    }
    if ([self.messageContentView.text isValidLength:1000]) {
        [SVProgressHUD showImage:nil status:@"提醒内容过长，请重新输入"];
        return;
    }
    
    NSArray *leftArray = [self.messageContentView.text indexOfTargetStr:@"{"];
    NSArray *rightArray = [self.messageContentView.text indexOfTargetStr:@"}"];
    if (leftArray.count != rightArray.count) {
        [SVProgressHUD showImage:nil status:@"消息格式不正确，请重新填写"];
        return;
    }
    
    //设置按钮不可点
    [self setButtonEnable:NO];
    if (self.isEdit == YES) {
        //表明是编辑
        [SVProgressHUD showWithStatus:@"正在修改"];
        self.model.message_content = self.messageContentView.text;
        XLMessageTemplateParam *param = [[XLMessageTemplateParam alloc] initWithMessageTemplateModel:self.model];
        __weak typeof(self) weakSelf = self;
        [XLMessageTemplateTool editMessageTemplateWithParam:param success:^(CRMHttpRespondModel *model) {
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:MessageTemplateEditNotification object:nil];
            [weakSelf popViewControllerAnimated:YES];
            
        } failure:^(NSError *error) {
            [self setButtonEnable:YES];
            [SVProgressHUD dismiss];
            if (error) {
                NSLog(@"error:%@",error);
            }
        }];
    }else{
        //新增
        [SVProgressHUD showWithStatus:@"正在添加"];
        XLMessageTemplateParam *param = [[XLMessageTemplateParam alloc] initWithDoctorId:[AccountManager currentUserid] messageType:self.messageTypeField.text messageContent:self.messageContentView.text];
        [XLMessageTemplateTool addMessageTemplateWithParam:param success:^(CRMHttpRespondModel *model) {
            [SVProgressHUD showSuccessWithStatus:@"添加成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:MessageTemplateAddNotification object:nil];
                [self popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            [self setButtonEnable:YES];
            [SVProgressHUD dismiss];
            if (error) {
                NSLog(@"error:%@",error);
            }
        }];
    }
}
#pragma mark - 删除按钮点击
- (void)deleteAction{
    __weak typeof(self) weakSelf = self;
    TimAlertView *alertView = [[TimAlertView alloc] initWithTitle:@"提示" message:@"确认删除此消息模板吗?" cancelHandler:^{
    } comfirmButtonHandlder:^{
        //表明是编辑
        [SVProgressHUD showWithStatus:@"正在删除"];
        XLMessageTemplateParam *param = [[XLMessageTemplateParam alloc] initWithMessageTemplateModel:weakSelf.model];
        [XLMessageTemplateTool deleteMessageTemplateWithParam:param success:^(CRMHttpRespondModel *model) {
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:MessageTemplateDeleteNotification object:nil];
            [weakSelf popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
            if (error) {
                NSLog(@"error:%@",error);
            }
        }];
    }];
    [alertView show];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    NSLog(@"结束编辑");
    if (textField.text.length > 0) {
        NSString *content = self.messageContentView.text;
        content = [content stringByReplacingOccurrencesOfString:@"{7}" withString:textField.text];
        //检索出现的字符串
        self.messageContentView.attributedText = [self changeStrColorWithSourceStr:content];
    }
    return YES;
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [textView resignFirstResponder];
        
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

//监听textView内容的变化
- (void)textChanged{
    
    NSInteger number = [self.messageContentView.text length];
    if (number > 500) {
        self.messageContentView.text = [self.messageContentView.text substringToIndex:500];
        number = 500;
    }
    _limitLabel.text = [NSString stringWithFormat:@"还可输入%ld个字",500 - (long)number];
    
}

#pragma mark - 修改字符串中指定字符的颜色
- (NSMutableAttributedString *)changeStrColorWithSourceStr:(NSString *)sourceStr{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:sourceStr];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, attrStr.length)];
    //检索出现的字符串
    NSArray *leftArray = [sourceStr indexOfTargetStr:@"{"];
    NSArray *rightArray = [sourceStr indexOfTargetStr:@"}"];
    for (int i = 0; i < leftArray.count; i++) {
        NSUInteger len = [rightArray[i] integerValue] - [leftArray[i] integerValue] + 1;
        NSRange range = NSMakeRange([leftArray[i] integerValue], len);
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x00a0ea] range:range];
    }
    return attrStr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
