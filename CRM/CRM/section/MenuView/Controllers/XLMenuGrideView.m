//
//  XLMenuGrideView.m
//  CRM
//
//  Created by Argo Zhang on 16/5/31.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLMenuGrideView.h"
#import "XLMenuGridItemView.h"


static const NSInteger kMenuGrideViewRowItemCount = 3;
//static const NSInteger kMenuGrideViewTopSectionRowCount = 3;

#define kMenuGrideViewLineColor [[UIColor lightGrayColor] colorWithAlphaComponent:0.8];
#define kMenuGrideViewLineHeight 0.6

@interface XLMenuGrideView ()<UIScrollViewDelegate>{
    BOOL _shouldAdjustedSeparators;//是否重新设置分割线的frame
    CGPoint _lastPoint;
    UIButton *_placeholderButton;//占位按钮
    XLMenuGridItemView *_currentPressedView;//当前长按的itemView
    UIButton *_moreItemButton;//更多按钮
    CGRect _currentPresssViewFrame;//当前长按的itemView的frame
}

@property (nonatomic, strong)NSMutableArray *itemsArray;//模型数组
@property (nonatomic, strong)NSMutableArray *rowSeparatorsArray;//行分割线数组
@property (nonatomic, strong)NSMutableArray *columnSeparatorsArray;//列分割线数组

@end

@implementation XLMenuGrideView

#pragma mark - ********************* Life Method ***********************
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.showsVerticalScrollIndicator = NO;
        self.delegate = self;
        _shouldAdjustedSeparators = NO;
        _placeholderButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        self.delaysContentTouches = NO;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    NSLog(@"我被调用了");
    
    CGFloat itemW = self.frame.size.width / kMenuGrideViewRowItemCount;
    CGFloat itemH = itemW;
    
    [self setUpSubViewsFrame];
    
    __weak typeof(self) weakSelf = self;
    if (_shouldAdjustedSeparators) {
        NSLog(@"分割线Frame");
        //计算分割线的frame
        [self.rowSeparatorsArray enumerateObjectsUsingBlock:^(UIView *rowView, NSUInteger idx, BOOL * _Nonnull stop) {
            CGFloat rowW = weakSelf.frame.size.width;
            CGFloat rowH = kMenuGrideViewLineHeight;
            CGFloat rowX = 0;
            CGFloat rowY = idx * (itemH + kMenuGrideViewLineHeight);
            rowView.frame = CGRectMake(rowX, rowY, rowW, rowH);
            
            NSLog(@"%lu-----%@",(unsigned long)idx,NSStringFromCGRect(rowView.frame));
        }];
        
        [self.columnSeparatorsArray enumerateObjectsUsingBlock:^(UIView *columView, NSUInteger idx, BOOL * _Nonnull stop) {
            CGFloat columW = kMenuGrideViewLineHeight;
            CGFloat columH = MAX(weakSelf.contentSize.height, weakSelf.frame.size.height);
            CGFloat columX = (idx + 1) * itemW + idx * kMenuGrideViewLineHeight;
            CGFloat columY = 0;
            columView.frame = CGRectMake(columX, columY, columW, columH);
        }];
        
        _shouldAdjustedSeparators = NO;
    }
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    //NO scroll不可以滚动 YES scroll可以滚动
    return YES;
}

#pragma mark - ********************* Private Method ***********************
#pragma mark 长按事件
- (void)itemLongPressed:(UILongPressGestureRecognizer *)longPress{
    //获取当前长按的view的坐标
    XLMenuGridItemView *itemView = (XLMenuGridItemView *)longPress.view;
    CGPoint point = [longPress locationInView:self];
    //判断长按的状态（开始长按）
    if (longPress.state == UIGestureRecognizerStateBegan) {
        _currentPressedView.hidenIcon = YES;
        _currentPressedView = itemView;
        _currentPresssViewFrame = itemView.frame;
        longPress.view.transform = CGAffineTransformMakeScale(1.1, 1.1);
        itemView.hidenIcon = NO;
        long index = [self.itemsArray indexOfObject:longPress.view];
        //移除当前数组里的itemView
        [self.itemsArray removeObject:longPress.view];
        //将占位按钮插入itemView的位置
        [self.itemsArray insertObject:_placeholderButton atIndex:index];
        _lastPoint = point;
        [self bringSubviewToFront:longPress.view];
    }
    
    //计算frame，让按钮跟随手指移动
    CGRect temp = longPress.view.frame;
    temp.origin.x += point.x - _lastPoint.x;
    temp.origin.y += point.y - _lastPoint.y;
    longPress.view.frame = temp;
    
    //重新记录frame
    _lastPoint = point;
    
    //遍历itemsArray
    [self.itemsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = (UIButton *)obj;
        //如果是更多按钮，则不响应长按事件
        if (button == _moreItemButton) return;
        //判断button是否包含当前手指所在的point
        if (CGRectContainsPoint(button.frame, point) && button != longPress.view) {
            [self.itemsArray removeObject:_placeholderButton];
            [self.itemsArray insertObject:_placeholderButton atIndex:idx];
            *stop = YES;//停止遍历
            [UIView animateWithDuration:0.5 animations:^{
               //重新设置子视图的frame
                [self setUpSubViewsFrame];
            }];
        }
    }];
    
    //结束长按
    if (longPress.state == UIGestureRecognizerStateEnded) {
        //获取当前占位button所在的位置
        long index = [self.itemsArray indexOfObject:_placeholderButton];
        //移除占位button
        [self.itemsArray removeObject:_placeholderButton];
        [self.itemsArray insertObject:longPress.view atIndex:index];
        
        //保存当前的菜单顺序（暂未实现）
        [UIView animateWithDuration:0.4 animations:^{
            longPress.view.transform = CGAffineTransformIdentity;
            [self setUpSubViewsFrame];
        } completion:^(BOOL finished) {
            if (!CGRectEqualToRect(_currentPresssViewFrame, _currentPressedView.frame)) {
                _currentPressedView.hidenIcon = YES;
            }
        }];
    }
}

#pragma mark 编辑按钮点击事件
- (void)deleteView:(XLMenuGridItemView *)itemView{
    [self.itemsArray removeObject:itemView];
    [itemView removeFromSuperview];
    //保存用户的菜单数据
    
    //重新设置frame
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.4 animations:^{
        [weakSelf setUpSubViewsFrame];
    }];
}

#pragma mark 设置子视图的frame
- (void)setUpSubViewsFrame{
    CGFloat itemW = self.frame.size.width / kMenuGrideViewRowItemCount - self.columnSeparatorsArray.count * kMenuGrideViewLineHeight;
    CGFloat itemH = itemW;
    [self.itemsArray enumerateObjectsUsingBlock:^(UIView *item, NSUInteger idx, BOOL * _Nonnull stop) {
        //获取item坐标
        long rowIndex = idx / kMenuGrideViewRowItemCount;
        long columIndex = idx % kMenuGrideViewRowItemCount;
        //重新计算frame
        CGFloat x = (itemW + kMenuGrideViewLineHeight) * columIndex;
        CGFloat y = itemH * rowIndex + kMenuGrideViewLineHeight;
//        if (idx < kMenuGrideViewRowItemCount * kMenuGrideViewTopSectionRowCount) {
//            y = itemH * rowIndex;
//        }else{
//            y = itemH * (rowIndex + 1);
//        }
        
        item.frame = CGRectMake(x, y, itemW, itemH);
        if (idx == (self.itemsArray.count - 1)) {
            self.contentSize = CGSizeMake(0, item.frame.size.height + item.frame.origin.y + self.rowSeparatorsArray.count * kMenuGrideViewLineHeight);
        }
    }];
}

#pragma mark 更多按钮点击事件
- (void)moreItemButtonClicked{
    
}

#pragma mark 获取当前的rowCount
- (NSInteger)rowCountWithItemsCount:(NSInteger)count
{
    long rowCount = (count + kMenuGrideViewRowItemCount - 1) / kMenuGrideViewRowItemCount;
    rowCount = (rowCount < kMenuGrideViewRowItemCount) ? kMenuGrideViewRowItemCount : ++rowCount;
    return rowCount;
}


#pragma mark - ********************* Setter ***********************
- (void)setGridModels:(NSArray *)gridModels{
    _gridModels = gridModels;
    NSLog(@"setGridModels");
    
    [self.itemsArray removeAllObjects];
    [self.rowSeparatorsArray removeAllObjects];
    [self.columnSeparatorsArray removeAllObjects];
    
    //遍历数组
    [gridModels enumerateObjectsUsingBlock:^(XLGridItemModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        //创建itemView
        XLMenuGridItemView *itemView = [[XLMenuGridItemView alloc] init];
        itemView.itemModel = model;
        __weak typeof(self) weakSelf = self;
        itemView.longPressOperationBlock = ^(UILongPressGestureRecognizer *longPress){
            //长按事件
            [weakSelf itemLongPressed:longPress];
        };
        itemView.buttonClickOperationBlock = ^(XLMenuGridItemView *itemView){
            //如果当前是编辑模式，则取消编辑模式
            if (!_currentPressedView.hidenIcon && _currentPressedView) {
                _currentPressedView.hidenIcon = YES;
                return;
            }
            //响应点击事件
        };
        
        itemView.iconViewClickOperationBlock = ^(XLMenuGridItemView *iconView){
            //编辑模式点击事件(删除当前点击的view)
            [self deleteView:iconView];
        };
        
        [self addSubview:itemView];
        [self.itemsArray addObject:itemView];
    }];
    
    UIButton *more = [[UIButton alloc] init];
    [more setImage:[UIImage imageNamed:@"btn_new_orange"] forState:UIControlStateNormal];
    [more addTarget:self action:@selector(moreItemButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:more];
    [_itemsArray addObject:more];
    _moreItemButton = more;
    
    long rowCount = [self rowCountWithItemsCount:gridModels.count];
    
    //计算行分割线的frame
    for (int i = 0; i < (rowCount + 1); i++) {
        UIView *rowSeparatorView = [UIView new];
        rowSeparatorView.backgroundColor = kMenuGrideViewLineColor;
        [self addSubview:rowSeparatorView];
        [self.rowSeparatorsArray addObject:rowSeparatorView];
    }
    
    for (int i = 0; i < (kMenuGrideViewRowItemCount - 1); i++) {
        UIView *columSeparatorView = [UIView new];
        columSeparatorView.backgroundColor = kMenuGrideViewLineColor;
        [self addSubview:columSeparatorView];
        [self.columnSeparatorsArray addObject:columSeparatorView];
    }
    
    _shouldAdjustedSeparators = YES;
}

#pragma mark - ********************* Delegate / DataSource *******************
#pragma mark UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _currentPressedView.hidenIcon = YES;
}


#pragma mark - ********************* Lazy Method ***********************
- (NSMutableArray *)itemsArray{
    if (!_itemsArray) {
        _itemsArray = [NSMutableArray array];
    }
    return _itemsArray;
}

- (NSMutableArray *)rowSeparatorsArray{
    if (!_rowSeparatorsArray) {
        _rowSeparatorsArray = [NSMutableArray array];
    }
    return _rowSeparatorsArray;
}

- (NSMutableArray *)columnSeparatorsArray{
    if (!_columnSeparatorsArray) {
        _columnSeparatorsArray = [NSMutableArray array];
    }
    return _columnSeparatorsArray;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    NSLog(@"%ld---%ld",(long)event.subtype,event.type);
    return self;
}

@end
