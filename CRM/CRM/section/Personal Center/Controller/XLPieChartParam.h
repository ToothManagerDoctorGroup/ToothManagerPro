//
//  XLPieChartParam.h
//  CRM
//
//  Created by Argo Zhang on 16/1/21.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  饼状图所需参数
 */
@interface XLPieChartParam : NSObject

@property (nonatomic, strong)UIColor *color;//颜色
@property (nonatomic, assign)double scale;//比例
@property (nonatomic, copy)NSString *status;//类型
@property (nonatomic, assign)double count;//数量

- (instancetype)initWithColor:(UIColor *)color scale:(double)scale status:(NSString *)status count:(double)count;

@end
