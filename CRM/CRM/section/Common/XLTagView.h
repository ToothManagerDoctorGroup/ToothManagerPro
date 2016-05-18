//
//  XLTagView.h
//  CRM
//
//  Created by Argo Zhang on 16/4/27.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLTagFrame.h"

#define TextColor [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0]
#define UIColorRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

typedef NS_ENUM(NSInteger,XLTagViewSelectType){
    XLTagViewSelectTypeSingle,//单选
    XLTagViewSelectTypeMultiple//多选
};
@class XLTagView;
@protocol XLTagViewDelegate <NSObject>

@optional
- (void)tagView:(XLTagView *)tagView tagArray:(NSArray *)tagArray;

@end

@interface XLTagView : UIView{
    //储存选中按钮的tag
    NSMutableArray *selectedTagBtnList;
}

@property (weak, nonatomic) id<XLTagViewDelegate> delegate;

/** 是否能选中 需要在 XLTagFrame 前调用  default is YES*/
@property (assign, nonatomic) BOOL clickbool;

/** 未选中边框大小 需要在 XLTagFrame 前调用 default is 0.5*/
@property (assign, nonatomic) CGFloat borderSize;

/** XLTagFrame */
@property (nonatomic, strong) XLTagFrame *tagsFrame;

/** 选中背景颜色 default is whiteColor */
@property (strong, nonatomic) UIColor *clickBackgroundColor;

/** 选中字体颜色 default is TextColor */
@property (strong, nonatomic) UIColor *clickTitleColor;

/** 多选选中 default is 未选中*/
@property (strong, nonatomic) NSArray *clickArray;

/** 单选选中 default is 未选中*/
@property (strong, nonatomic) NSString *clickString;

/** 选中边框大小 default is 0.5*/
@property (assign, nonatomic) CGFloat clickborderSize;

/** 1-多选 0-单选 default is 0-单选*/
@property (assign, nonatomic) XLTagViewSelectType selectType;

@end
