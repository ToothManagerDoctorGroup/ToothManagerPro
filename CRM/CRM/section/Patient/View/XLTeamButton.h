//
//  XLTeamButton.h
//  CRM
//
//  Created by Argo Zhang on 16/3/2.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  团队功能按钮
 */
@interface XLTeamButton : UIControl

@property (nonatomic, strong)UIImage *image;

@property (nonatomic, strong)NSString *title;

- (instancetype)initWithImage:(UIImage *)image;

@end
