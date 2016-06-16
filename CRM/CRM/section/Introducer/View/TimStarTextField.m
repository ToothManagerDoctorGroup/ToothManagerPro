//
//  TimStarTextField.m
//  CRM
//
//  Created by TimTiger on 6/1/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "TimStarTextField.h"
#import "TimFramework.h"


@interface TimStarTextField () <UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,retain) TimToolBar *toolBar;
@property (nonatomic,retain) UIPickerView *inputPickerView;
@property (nonatomic,retain) TimStarView *starView;
@property (nonatomic,readonly) NSArray *levelArray;

@end

@implementation TimStarTextField
@synthesize toolBar,inputPickerView = _inputPickerView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setupView {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handNotification:) name:UIKeyboardHideNotification object:nil];
    if (_levelArray == nil) {
        _levelArray = @[@(1),@(2),@(3),@(4),@(5)];
    }
    [self initToolBar];
    [self initPicker];
    [self initStarView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setupView];
    self.inputView = self.inputPickerView;
    self.inputAccessoryView = self.toolBar;
}

//光标的处理
- (CGRect)caretRectForPosition:(UITextPosition *)position
{
    return CGRectZero;
}

- (void)initStarView {
    if (self.starView == nil) {
        self.starView = [[TimStarView alloc]initWithFrame:CGRectMake(self.bounds.size.width - 75,7.5, 75, 15)];
        self.starView.userInteractionEnabled = NO;
        [self addSubview:self.starView];
    }
//    self.starView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
}

- (void)initToolBar {
    if (toolBar == nil) {
        toolBar = [[TimToolBar alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        UIControl *lineControl = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, toolBar.bounds.size.width, 0.5)];
        lineControl.backgroundColor = [UIColor grayColor];
        [toolBar addSubview:lineControl];
        UIBarButtonItem *doneItem = [UIBarButtonItem itemWithTitle:@"完成" target:self
                                                            action:@selector(onFinishButtonAction:)];
        [doneItem setTitleColor:[UIColor colorWithHex:0x007aff] forState:UIControlStateNormal];
        
        UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                  target:nil action:nil];
        
        UIBarButtonItem *cancelItem = [UIBarButtonItem itemWithTitle:@"取消" target:self
                                                              action:@selector(onCancelButtonAction:)];
        
        [cancelItem setTitleColor:[UIColor colorWithHex:0x007aff] forState:UIControlStateNormal];
        
        [toolBar setItems:[NSArray arrayWithObjects:cancelItem,spaceItem,doneItem, nil]];
    }
}

- (void)initPicker {
    if (_inputPickerView == nil) {
        _inputPickerView = [[UIPickerView alloc]init];
        _inputPickerView.frame = CGRectMake(0,44, kScreenWidth, 216);
        _inputPickerView.delegate = self;
        _inputPickerView.dataSource = self;
    }
    _inputPickerView.frame = CGRectMake(0,44, kScreenWidth, 216);
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Set / Get
- (void)setStarLevel:(NSInteger)starLevel {
    _starLevel = starLevel;
    self.starView.scale = starLevel;
}

#pragma mark - Notification
- (void)handNotification:(NSNotification *)notifacation {
    if ([notifacation.name isEqualToString:UIKeyboardHideNotification]) {
        [self resignFirstResponder];
    }
}

#pragma mark - UIPickerView Delegate /DataSource
- (void)onFinishButtonAction:(UIBarButtonItem *)sender {
    NSInteger row = [self.inputPickerView selectedRowInComponent:0];
    self.starView.scale = [[self.levelArray objectAtIndex:row] integerValue];
    self.starLevel = [[self.levelArray objectAtIndex:row] integerValue];
    [self resignFirstResponder];
}

- (void)onCancelButtonAction:(UIBarButtonItem *)sender {
    [self resignFirstResponder];
}

//选择了某一行的回调
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.starView.scale = [[self.levelArray objectAtIndex:row] integerValue];
    self.starLevel = [[self.levelArray objectAtIndex:row] integerValue];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.levelArray.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return SCREEN_WIDTH;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    TimStarView *rowView = nil;
    if ([view isKindOfClass:[TimStarView class]]) {
        rowView = (TimStarView *)view;
    } else {
        rowView = [[TimStarView alloc]initWithFrame:CGRectMake(0,7, 75, 15)];
    }
    rowView.scale = [[self.levelArray objectAtIndex:row] integerValue];
    return rowView;
}
@end
