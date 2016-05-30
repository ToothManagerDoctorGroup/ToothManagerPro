//
//  XLSegmentView.m
//  CRM
//
//  Created by Argo Zhang on 16/5/25.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLSegmentView.h"

#define kWindowWidth  ([[UIScreen mainScreen] bounds].size.width)
#define SFQRedColor [UIColor colorWithRed:255/255.0 green:92/255.0 blue:79/255.0 alpha:1]
#define MAX_TitleNumInWindow 5

@interface XLSegmentView ()

@property (nonatomic,strong) NSMutableArray *btns;//按钮数组
@property (nonatomic,strong) NSArray *titles;   //标题数组
@property (nonatomic,strong) UIButton *titleBtn;//当前选中的button
@property (nonatomic,strong) UIScrollView *bgScrollView;
@property (nonatomic,strong) UIView *selectLine;//选中的下划线
@property (nonatomic,assign) CGFloat btn_w;     //按钮的宽度

@end

@implementation XLSegmentView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titleArray clickBlick:(BtnClickBlock)block{
    if (self = [super initWithFrame:frame]) {
        _btn_w = 0.0;
        if (titleArray.count < MAX_TitleNumInWindow + 1) {
            _btn_w = kWindowWidth / titleArray.count;
        }else{
            _btn_w = kWindowWidth / MAX_TitleNumInWindow;
        }
        _titles = titleArray;
        _defaultIndex = 1;
        _titleNormalColor = [UIColor blackColor];
        _titleSelectColor = SFQRedColor;
        _titleNormalFont = [UIFont systemFontOfSize:15];
        _titleSelectFont = [UIFont systemFontOfSize:15];
        //初始化scrollView
        _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, self.frame.size.height)];
        _bgScrollView.backgroundColor = [UIColor whiteColor];
        _bgScrollView.showsHorizontalScrollIndicator = NO;
        _bgScrollView.contentSize = CGSizeMake(_btn_w * titleArray.count, self.frame.size.height);
        [self addSubview:_bgScrollView];
        
        //分割线
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 1, _btn_w * titleArray.count, 1)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [_bgScrollView addSubview:lineView];
        
        //当前选中的下划线
        _selectLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 2, _btn_w, 2)];
        _selectLine.backgroundColor = _titleSelectColor;
        [_bgScrollView addSubview:_selectLine];
        
        //创建按钮
        for (int i=0; i<titleArray.count; i++) {
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame=CGRectMake(_btn_w*i, 0, _btn_w, self.frame.size.height-2);
            btn.tag=i+1;
            [btn setTitle:titleArray[i] forState:UIControlStateNormal];
            [btn setTitleColor:_titleNormalColor forState:UIControlStateNormal];
            [btn setTitleColor:_titleSelectColor forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
            [btn setBackgroundColor:[UIColor whiteColor]];
            btn.titleLabel.font = _titleNormalFont;
            [_bgScrollView addSubview:btn];
            [_btns addObject:btn];
            if (i==0) {
                _titleBtn=btn;
                btn.selected=YES;
            }
            self.block=block;
        }
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _defaultIndex = 1;
        _titleNormalColor = [UIColor blackColor];
        _titleSelectColor = SFQRedColor;
        _titleNormalFont = [UIFont systemFontOfSize:15];
        _titleSelectFont = [UIFont systemFontOfSize:15];
    }
    return self;
}

- (void)setTitleArray:(NSArray *)titleArray{
    _titleArray = titleArray;
    
    if (titleArray.count == 0) return;
    
    _btn_w = 0.0;
    if (titleArray.count < MAX_TitleNumInWindow + 1) {
        _btn_w = kWindowWidth / titleArray.count;
    }else{
        _btn_w = kWindowWidth / MAX_TitleNumInWindow;
    }
    _titles = titleArray;
    //初始化scrollView
    _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, self.frame.size.height)];
    _bgScrollView.backgroundColor = [UIColor whiteColor];
    _bgScrollView.showsHorizontalScrollIndicator = NO;
    _bgScrollView.contentSize = CGSizeMake(_btn_w * titleArray.count, self.frame.size.height);
    [self addSubview:_bgScrollView];
    
    //分割线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 1, _btn_w * titleArray.count, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [_bgScrollView addSubview:lineView];
    
    //当前选中的下划线
    _selectLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 2, _btn_w, 2)];
    _selectLine.backgroundColor = _titleSelectColor;
    [_bgScrollView addSubview:_selectLine];
    
    //创建按钮
    for (int i=0; i<titleArray.count; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(_btn_w*i, 0, _btn_w, self.frame.size.height-2);
        btn.tag=i+1;
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:_titleNormalColor forState:UIControlStateNormal];
        [btn setTitleColor:_titleSelectColor forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
        [btn setBackgroundColor:[UIColor whiteColor]];
        btn.titleLabel.font = _titleNormalFont;
        [_bgScrollView addSubview:btn];
        [_btns addObject:btn];
        if (i==0) {
            _titleBtn=btn;
            btn.selected=YES;
        }
    }
}


-(void)btnClick:(UIButton *)btn{
    
    if (self.block) {
        self.block(btn.tag);
    }
    
    if (btn.tag==_defaultIndex) {
        return;
    }else{
        _titleBtn.selected=!_titleBtn.selected;
        _titleBtn=btn;
        _titleBtn.selected=YES;
        _defaultIndex=btn.tag;
    }
    
    //计算偏移量
    CGFloat offsetX=btn.frame.origin.x - 2 * _btn_w;
    if (offsetX < 0) {
        offsetX=0;
    }
    CGFloat maxOffsetX= _bgScrollView.contentSize.width-kWindowWidth;
    if (offsetX>maxOffsetX) {
        offsetX=maxOffsetX;
    }
    
    [UIView animateWithDuration:.2 animations:^{
        
        [_bgScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
        _selectLine.frame=CGRectMake(btn.frame.origin.x, self.frame.size.height-2, btn.frame.size.width, 2);
        
    } completion:^(BOOL finished) {
        
    }];
}


- (void)setTitleNormalColor:(UIColor *)titleNormalColor{
    _titleNormalColor = titleNormalColor;
    [self updateView];
}

- (void)setTitleSelectColor:(UIColor *)titleSelectColor{
    _titleSelectColor = titleSelectColor;
    
    [self updateView];
}

- (void)setTitleNormalFont:(UIFont *)titleNormalFont{
    _titleNormalFont = titleNormalFont;
    [self updateView];
}

- (void)setTitleSelectFont:(UIFont *)titleSelectFont {
    _titleSelectFont = titleSelectFont;
    [self updateView];
}

- (void)setDefaultIndex:(NSInteger)defaultIndex{
    _defaultIndex = defaultIndex;
    [self updateView];
}

//更新视图
-(void)updateView{
    for (UIButton *btn in _btns) {
        [btn setTitleColor:_titleNormalColor forState:UIControlStateNormal];
        [btn setTitleColor:_titleSelectColor forState:UIControlStateSelected];
        btn.titleLabel.font=_titleNormalFont;
        _selectLine.backgroundColor=_titleSelectColor;
        
        if (btn.tag-1==_defaultIndex-1) {
            _titleBtn=btn;
            btn.selected=YES;
        }else{
            btn.selected=NO;
        }
    }
}

@end
