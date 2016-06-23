//
//  XLPayWayAlertView.m
//  CRM
//
//  Created by Argo Zhang on 16/5/20.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLPayWayAlertView.h"
#import "UIColor+Extension.h"
#import "XLPayWayAlertCell.h"
#import <Masonry.h>

@interface XLPayWayAlertView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)UIView *paySuperView;//父视图
@property (nonatomic, strong)UITableView *tableView;//支付方式
@property (nonatomic, strong)UIButton *cancelButton;//取消按钮
@property (nonatomic, strong)UILabel *titleLabel;//标题
@property (nonatomic, strong)UIView *dividerView;//分割线
@property (nonatomic, strong)UILabel *payTitleLabel;//付款标题
@property (nonatomic, strong)UILabel *priceLabel;//付款金额
@property (nonatomic, strong)UIButton *payButton;//付款按钮

@property (nonatomic, strong)NSArray *dataList;

@property (nonatomic, weak)id<XLPayWayAlertViewDelegate> delegate;
@property (nonatomic, copy)CertainButtonBlock certainBlock;
@property (nonatomic, strong)XLPayWayAlertViewModel *selectModel;//当前选中的model

@end

@implementation XLPayWayAlertView

- (instancetype)initWithPrice:(NSString *)price delegate:(id<XLPayWayAlertViewDelegate>)delegate{
    CGRect frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    if (self = [super initWithFrame:frame]) {
        [self setUp];
        self.delegate = delegate;
        self.priceLabel.text = [NSString stringWithFormat:@"%@元",price];
    }
    return self;
}

- (instancetype)initWithPrice:(NSString *)price certainButtonBlock:(CertainButtonBlock)certainButtonBlock{
    CGRect frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    if (self = [super initWithFrame:frame]) {
        [self setUp];
        self.priceLabel.text = [NSString stringWithFormat:@"%@元",price];
        self.certainBlock = certainButtonBlock;
    }
    return self;
}

- (void)show{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    WS(weakSelf);
    [UIView animateWithDuration:.35 animations:^{
        weakSelf.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        [weakSelf.paySuperView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.mas_bottom).with.offset(-350);
        }];
    } completion:^(BOOL finished) {
    }];
}

- (void)dismiss{
    WS(weakSelf);
    [UIView animateWithDuration:.35 animations:^{
        weakSelf.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        [weakSelf.paySuperView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.mas_bottom);
        }];
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

- (void)setUp{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    [self addSubview:[self paySuperView]];
    //设置约束
    [self setUpConstraints];
}

- (void)setUpConstraints{
    CGFloat margin = 15;
    WS(weakSelf);
    
    [self.paySuperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.right.equalTo(weakSelf);
        make.top.equalTo(weakSelf.mas_bottom);
        make.height.mas_equalTo(350);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.paySuperView);
        make.left.equalTo(weakSelf.paySuperView);
        make.size.mas_equalTo(CGSizeMake(50, 50));
        
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.paySuperView);
        make.top.equalTo(weakSelf.paySuperView).with.offset(margin);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
    
    [self.dividerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.paySuperView);
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).with.offset(margin);
        make.right.equalTo(weakSelf.paySuperView);
        make.height.mas_equalTo(1);
    }];
    
    [self.payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.paySuperView).with.offset(margin);
        make.right.equalTo(weakSelf.paySuperView).with.offset(-margin);
        make.bottom.equalTo(weakSelf.paySuperView).with.offset(-margin * 2);
        make.height.mas_equalTo(44);
    }];
    
    [self.payTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.paySuperView).with.offset(margin);
        make.bottom.equalTo(weakSelf.payButton.mas_top).with.offset(-40);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.payTitleLabel.mas_right);
        make.bottom.equalTo(weakSelf.payTitleLabel.mas_bottom);
        make.right.equalTo(weakSelf.paySuperView).with.offset(-margin);
        make.height.mas_equalTo(30);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.paySuperView);
        make.right.equalTo(weakSelf.paySuperView);
        make.top.equalTo(weakSelf.dividerView.mas_bottom).with.offset(margin);
        make.bottom.equalTo(weakSelf.payTitleLabel.mas_top).with.offset(-margin);
    }];
}

#pragma mark 支付方法
- (void)payAction{
    [self dismiss];
    if (self.certainBlock) {
        self.certainBlock(self,self.selectModel.paymentMethod);
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(payWayAlertView:paymentMethod:)]) {
        [self.delegate payWayAlertView:self paymentMethod:self.selectModel.paymentMethod];
    }
}

#pragma mark - ********************* delegate/datasource ********************
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XLPayWayAlertCell *cell = [XLPayWayAlertCell cellWithTableView:tableView];
    
    XLPayWayAlertViewModel *model = self.dataList[indexPath.row];
    if (model.isSelect) {
        self.selectModel = model;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    if (model.paymentMethod == XLPaymentMethodWeixin) {
        cell.logoImageView.image = [UIImage imageNamed:@"pay_weixin_logo"];
    }else{
        cell.logoImageView.image = [UIImage imageNamed:@"pay_zhifubao_logo"];
    }
    cell.contentLabel.text = model.payMethodTitle;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XLPayWayAlertViewModel *model = self.dataList[indexPath.row];
    if (model.isSelect) return;
    
    self.selectModel.select = NO;
    model.select = YES;
    self.selectModel = model;
    
    [self.tableView reloadData];
}

#pragma mark - ********************* Lazy Method ***********************
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 44;
    }
    return _tableView;
}

- (UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setImage:[UIImage imageNamed:@"pay_close"] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"付款详情";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor colorWithHex:0x333333];
        _titleLabel.font = [UIFont systemFontOfSize:18];
    }
    return _titleLabel;
}

- (UILabel *)payTitleLabel{
    if (!_payTitleLabel) {
        _payTitleLabel = [[UILabel alloc] init];
        _payTitleLabel.text = @"需付款";
        _payTitleLabel.textColor = [UIColor colorWithHex:0x333333];
        _payTitleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _payTitleLabel;
}

- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textAlignment = NSTextAlignmentRight;
        _priceLabel.textColor = [UIColor colorWithHex:0x333333];
        _priceLabel.font = [UIFont systemFontOfSize:24];
    }
    return _priceLabel;
}

- (UIButton *)payButton{
    if (!_payButton) {
        _payButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_payButton setTitle:@"确认付款" forState:UIControlStateNormal];
        [_payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _payButton.titleLabel.font = [UIFont systemFontOfSize:20];
        _payButton.backgroundColor = [UIColor colorWithHex:0x00a0ea];
        _payButton.layer.cornerRadius = 5;
        _payButton.layer.masksToBounds = YES;
        [_payButton addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _payButton;
}
- (UIView *)dividerView{
    if (!_dividerView) {
        _dividerView = [[UIView alloc] init];
        _dividerView.backgroundColor = [UIColor colorWithHex:0xcccccc];
    }
    return _dividerView;
}

- (UIView *)paySuperView{
    if (!_paySuperView) {
        _paySuperView = [[UIView alloc] init];
        _paySuperView.backgroundColor = [UIColor whiteColor];
        [_paySuperView addSubview:[self tableView]];
        [_paySuperView addSubview:[self cancelButton]];
        [_paySuperView addSubview:[self titleLabel]];
        [_paySuperView addSubview:[self dividerView]];
        [_paySuperView addSubview:[self priceLabel]];
        [_paySuperView addSubview:[self payButton]];
        [_paySuperView addSubview:[self payTitleLabel]];
    }
    return _paySuperView;
}

- (NSArray *)dataList{
    if (!_dataList) {
        XLPayWayAlertViewModel *wxModel = [[XLPayWayAlertViewModel alloc] initWithPaymentMethod:XLPaymentMethodWeixin payMethodTitle:@"微信支付" select:YES];
        XLPayWayAlertViewModel *alipyModel = [[XLPayWayAlertViewModel alloc] initWithPaymentMethod:XLPaymentMethodAlipay payMethodTitle:@"支付宝支付" select:NO];
        
        _dataList = @[wxModel,alipyModel];
    }
    return _dataList;
}


@end



@implementation XLPayWayAlertViewModel
- (instancetype)initWithPaymentMethod:(XLPaymentMethod)method
                       payMethodTitle:(NSString *)methodTitle
                             select:(BOOL)select{
    if (self = [super init]) {
        self.paymentMethod = method;
        self.payMethodTitle = methodTitle;
        self.select = select;
    }
    return self;
}

@end
