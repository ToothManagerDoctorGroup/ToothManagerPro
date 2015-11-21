

#import "TTMAddOtherController.h"
#import "TTMMaterialModel.h"
#import "TTMAddOtherLineView.h"
#import "TTMSelectValueView.h"

/**
 *  按钮类型
 */
typedef NS_ENUM(NSUInteger, ButtonType) {
    /**
     *  确定按钮
     */
    ButtonTypeSubmit = 0,
    /**
     *  添加按钮
     */
    ButtonTypeAdd = 1,
};

@interface TTMAddOtherController ()<TTMSelectValueViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView; // 滚动视图

@property (nonatomic, strong) UIView *materialListView; // 存放材料列表视图

@property (nonatomic, strong) UIView *bottomView; // 添加按钮和总计价格的视图容器

@property (nonatomic, strong) UIButton *addButton; // 添加按钮

@property (nonatomic, strong) UILabel *countLabel; // 总计价格label

@property (nonatomic, strong) TTMSelectValueView *selectValueView; // 选值视图

@property (nonatomic, assign) NSUInteger countMoney; // 总价格

@end

@implementation TTMAddOtherController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"添加其他费用";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setupViews];
    [self queryData];
}

#pragma mark - 视图加载
- (void)setupViews {
    [self setupRightItem];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.materialListView];
    [self.scrollView addSubview:self.bottomView];
    [self setupNotification];
    if (self.detailModel.extra_detail.count > 0) {
        for (TTMMaterialModel *materialModel in self.detailModel.extra_detail) {
            [self addLineViewWithModel:materialModel];
        }
    } else {
        [self addLineView];
    }
}

- (void)setupNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(caculateMoney)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
}

- (void)setupRightItem {
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithTitle:@"确定"
                                                                     normalImageName:@"member_bar_item_bg"
                                                                              action:@selector(buttonAction:)
                                                                              target:self];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
        _scrollView = scrollView;
    }
    return _scrollView;
}

- (UIView *)materialListView {
    if (!_materialListView) {
        UIView *materialListView = [[UIView alloc] init];
        materialListView.frame = CGRectMake(0, 0, ScreenWidth, 0);
        _materialListView = materialListView;
    }
    return _materialListView;
}

- (UIButton *)addButton {
    if (!_addButton) {
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [addButton setBackgroundImage:[UIImage imageNamed:@"member_charge_add"] forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        addButton.size = CGSizeMake(19.f, 19.f);
        addButton.tag = ButtonTypeAdd;
        _addButton = addButton;
    }
    return _addButton;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        // 总计价格
        UILabel *countLabel = [UILabel new];
        countLabel.textColor = [UIColor redColor];
        countLabel.font = [UIFont systemFontOfSize:14];
        countLabel.textAlignment = NSTextAlignmentRight;
        countLabel.text = [NSString stringWithFormat:@"合计 ￥%@", @"0"];
        _countLabel = countLabel;
    }
    return _countLabel;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        UIView *bottomView = [UIView new];
        [bottomView addSubview:self.addButton];
        [bottomView addSubview:self.countLabel];
        _bottomView = bottomView;
    }
    return _bottomView;
}

- (TTMSelectValueView *)selectValueView {
    if (!_selectValueView) {
        TTMSelectValueView *selectValueView = [[TTMSelectValueView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        selectValueView.delegate = self;
        _selectValueView = selectValueView;
    }
    return _selectValueView;
}

/**
 *  刷新位置
 */
- (void)updateFrame {
    NSArray *materialSubView = self.materialListView.subviews;
    CGFloat lineH = 44.f;
    // 材料视图坐标
    self.materialListView.height = materialSubView.count * lineH;
    for (NSUInteger i = 0; i < materialSubView.count; i ++) {
        TTMAddOtherLineView *linView = materialSubView[i];
        linView.frame = CGRectMake(0, i * lineH, ScreenWidth, lineH);
    }
    
    // 底部视图坐标
    CGFloat bottomViewH = 2 * lineH;
    CGFloat countLabelH = 20.f;
    CGFloat countLabelW = 200.f;
    CGFloat addButtonX = ScreenWidth - self.addButton.width - 20.f;
    CGFloat addButtonY = (lineH - self.addButton.height) / 2;
    CGFloat countLabelX = ScreenWidth - countLabelW - 20.f;
    CGFloat countLabelY = lineH + (lineH - countLabelH) / 2;
    
    self.bottomView.frame = CGRectMake(0, self.materialListView.bottom, ScreenWidth, bottomViewH);
    self.addButton.origin = CGPointMake(addButtonX, addButtonY);
    self.countLabel.frame = CGRectMake(countLabelX, countLabelY, countLabelW, countLabelH);
}

#pragma mark - TTMSelectValueViewDelegate
- (void)selectValueView:(TTMSelectValueView *)selectValueView selectedModel:(TTMMaterialModel *)selectedModel {
    TTMAddOtherLineView *linView = (TTMAddOtherLineView *)[selectValueView.clickedButton superview];
    linView.model = [selectedModel copy];
    [self caculateMoney];
}

/**
 *  计算总价
 */
- (void)caculateMoney {
    NSUInteger countMoney = 0;
    for (TTMAddOtherLineView *linView in self.materialListView.subviews) {
        NSString *priceText = [linView.priceTextField.text trim];
        countMoney += [priceText integerValue];
    }
    self.countMoney = countMoney;
    
    self.countLabel.text = [NSString stringWithFormat:@"总计￥%@", @(countMoney)];
}

/**
 *  按钮事件
 *
 */
- (void)buttonAction:(UIButton *)button {
    if (button.tag == ButtonTypeAdd) { // 添加按钮
        [self addLineView];
    } else { // 确定按钮
        // 计算传回的数据
        if ([self.delegate respondsToSelector:@selector(addOtherController:countMoney:materialArray:)]) {
            NSMutableArray *resultArray = [NSMutableArray array];
            for (TTMAddOtherLineView *lineView in self.materialListView.subviews) {
                if (lineView.model) {
                    lineView.model.countPrice = [lineView.priceTextField.text trim];
                    if ([lineView.model.countPrice integerValue] > 0) {
                        [resultArray addObject:lineView.model];
                    }
                }
            }
            [self.delegate addOtherController:self countMoney:self.countMoney materialArray:resultArray];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

/**
 *  添加行视图
 */
- (void)addLineView {
    TTMAddOtherLineView *linView = [[TTMAddOtherLineView alloc] init];
    if (self.selectValueView.dataArray.count > 0) {
        linView.model = [self.selectValueView.dataArray[0] copy];
    }
    [linView.valueButton addTarget:self action:@selector(showSelectValueView:) forControlEvents:UIControlEventTouchUpInside];
    [linView.deleteButton addTarget:self action:@selector(removeLineView:) forControlEvents:UIControlEventTouchUpInside];
    [self.materialListView addSubview:linView];
    [self updateFrame];
    [self caculateMoney];
}

/**
 *  添加有model的行视图
 */
- (void)addLineViewWithModel:(TTMMaterialModel *)model {
    TTMAddOtherLineView *linView = [[TTMAddOtherLineView alloc] init];
    linView.model = model;
    linView.priceTextField.text = model.actual_money;
    [linView.valueButton addTarget:self action:@selector(showSelectValueView:) forControlEvents:UIControlEventTouchUpInside];
    [linView.deleteButton addTarget:self action:@selector(removeLineView:) forControlEvents:UIControlEventTouchUpInside];
    [self.materialListView addSubview:linView];
    [self updateFrame];
    [self caculateMoney];
}

/**
 *  删除行
 */
- (void)removeLineView:(UIButton *)button {
    TTMAddOtherLineView *linView = (TTMAddOtherLineView *)button.superview;
    [linView removeFromSuperview];
    [self updateFrame];
    [self caculateMoney];
}

/**
 *  显示选择视图
 */
- (void)showSelectValueView:(UIButton *)button {
    if (self.selectValueView.dataArray.count > 0) {
        self.selectValueView.clickedButton = button;
        [self.selectValueView showInView:self.view.window];
    } else {
        [MBProgressHUD showToastWithText:@"没有材料数据"];
    }
}

/**
 *  查询其他的材料数据
 */
- (void)queryData {
    __weak __typeof(&*self) weakSelf = self;
    [TTMMaterialModel queryMaterialWithStatus:2 complete:^(id result) {
        if ([result isKindOfClass:[NSMutableArray class]]) {
            weakSelf.selectValueView.dataArray = result;
            
            if (!weakSelf.detailModel.extra_detail.count) {
                if (weakSelf.selectValueView.dataArray.count > 0) {
                    TTMAddOtherLineView *firstLineView = weakSelf.materialListView.subviews[0];
                    firstLineView.model = [weakSelf.selectValueView.dataArray[0] copy];
                    [weakSelf caculateMoney];
                }
            }
        } else {
            [MBProgressHUD showToastWithText:result];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
