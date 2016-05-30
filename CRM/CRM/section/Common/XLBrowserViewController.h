//
//  XLBrowserViewController.h
//  CRM
//
//  Created by Argo Zhang on 16/5/27.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLImageBrowserView.h"

@protocol XLBrowserViewControllerDelegate;
@interface XLBrowserViewController : UIViewController
@property (nonatomic,retain) NSMutableArray *imageArray;
@property (nonatomic, assign)NSInteger currentPage;
@property (nonatomic,weak) id <XLBrowserViewControllerDelegate> delegate;

@end

@protocol XLBrowserViewControllerDelegate <NSObject>

- (void)picBrowserViewController:(XLBrowserViewController *)controller didFinishBrowseImages:(NSArray *)images;
- (void)picBrowserViewController:(XLBrowserViewController *)controller didDeleteBrowserPicture:(XLBrowserPicture *)pic;

@end
