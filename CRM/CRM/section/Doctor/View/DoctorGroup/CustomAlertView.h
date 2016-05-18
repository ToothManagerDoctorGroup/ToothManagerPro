//
//  CustomAlertView.h
//  CRM
//
//  Created by Argo Zhang on 15/12/8.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, CustomAlertViewType) {
    CustomAlertViewTextField = 1,
    CustomAlertViewLabel = 2,
};
@class CustomAlertView;
@protocol CustomAlertViewDelegate <NSObject>

@optional
- (void)alertView:(CustomAlertView *)alertView didClickCertainButtonWithContent:(NSString *)content;

@end

@interface CustomAlertView : UIView

/**
 *  显示
 */
- (void)show;

/**
 *  标题
 */
@property (nonatomic, copy)NSString *alertTitle;
/**
 *  显示的类型
 */
@property (nonatomic, assign)CustomAlertViewType type;
/**
 *  取消标题
 */
@property (nonatomic, copy)NSString *cancleTitle;
/**
 *  确定标题
 */
@property (nonatomic, copy)NSString *certainTitle;
/**
 *  提醒事项
 */
@property (nonatomic, copy)NSString *tipContent;
/**
 *  输入框默认文字
 */
@property (nonatomic, copy)NSString *placeHolder;

/**
 *  设置确定按钮的颜色
 */
@property (nonatomic, strong)UIColor *certainColor;


@property (nonatomic, weak)id<CustomAlertViewDelegate> delegate;

- (instancetype)initWithAlertTitle:(NSString *)alertTitle cancleTitle:(NSString *)cancleTitle certainTitle:(NSString *)certainTitle;


@end
