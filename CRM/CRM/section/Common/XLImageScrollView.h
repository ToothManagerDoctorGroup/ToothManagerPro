//
//  XLImageScrollView.h
//  CRM
//
//  Created by Argo Zhang on 16/5/24.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLImageScrollView : UIView

@property (nonatomic, strong)NSArray *imageModelsArray;//数据源

@end


@interface XLImageScrollViewModel : NSObject

@property (nonatomic, copy)NSString *imageUrl;//图片url
@property (nonatomic, copy)NSString *imageHDUrl;//高清图片的url


@end