//
//  XLAdvertisementView.h
//  CRM
//
//  Created by Argo Zhang on 16/1/20.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^AdvertisementViewDismissBlock)();

@interface XLAdvertisementView : UIImageView

@property (nonatomic, copy)AdvertisementViewDismissBlock completeBlock;

- (void)dismiss:(AdvertisementViewDismissBlock)dismissblock;
- (void)start;
@end
