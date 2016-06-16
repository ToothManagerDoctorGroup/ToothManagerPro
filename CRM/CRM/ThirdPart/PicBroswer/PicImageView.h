//
//  PicImageView.h
//  CRM
//
//  Created by Argo Zhang on 16/3/28.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PicImageView : UIView

@property (nonatomic, copy)NSString *urlStr;
@property (nonatomic, strong)UIImage *targetImage;//标识图片
@property (nonatomic, assign)BOOL targetImageHidden;

@end
