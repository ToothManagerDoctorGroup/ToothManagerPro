//
//  ImageBrowserViewController.h
//  CRM
//
//  Created by TimTiger on 2/1/15.
//  Copyright (c) 2015 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PicBrowserView.h"

@protocol ImageBrowserViewControllerDelegate;
@interface ImageBrowserViewController : UIViewController
@property (nonatomic,retain) NSMutableArray *imageArray;
@property (nonatomic,weak) id <ImageBrowserViewControllerDelegate> delegate;

@end

@protocol ImageBrowserViewControllerDelegate <NSObject>

- (void)picBrowserViewController:(ImageBrowserViewController *)controller didFinishBrowseImages:(NSArray *)images;
- (void)picBrowserViewController:(ImageBrowserViewController *)controller didDeleteBrowserPicture:(BrowserPicture *)pic;

@end