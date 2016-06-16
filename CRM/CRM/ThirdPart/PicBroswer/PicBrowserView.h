//
//  PicBrowerView.h
//  MudmenPictureBrowser
//
//  Created by TimTiger on 1/18/15.
//  Copyright (c) 2015 Mudmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CTLib;
@interface BrowserPicture : NSObject
@property (nonatomic) NSInteger keyidInt;        //区分图片的id (整形)
@property (nonatomic,copy) NSString *keyidStr;   //区分图片的id (字符串)
@property (nonatomic,copy) NSString *title;      //图片描述文字
@property (nonatomic,copy) NSString *url;        //如果是网络图片 给地址
@property (nonatomic, strong)UIImage *image;     //如果传过来图片对象

@property (nonatomic, strong)CTLib *ctLib;//图片模型
@end

@protocol PicBrowserViewDelegate;
@interface PicBrowserView : UIView
@property (nonatomic,assign) id <PicBrowserViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *titleBarItem;
@property (weak, nonatomic) IBOutlet UIScrollView    *scrollView;
@property (weak, nonatomic) IBOutlet UIToolbar       *topBar;
@property (weak, nonatomic) IBOutlet UIToolbar       *bottomBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *deleteButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *pageupButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *pagedownButton;
@property (weak, nonatomic) IBOutlet UILabel *indexLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *leftBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *mainCTButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *midBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveImageButton;

//初始化
- (void)setupImageViews:(NSInteger)imageNum;
- (void)setLeftImage:(BrowserPicture *)pic;
- (void)setCenterImage:(BrowserPicture *)pic;
- (void)setRightImage:(BrowserPicture *)pic;

- (IBAction)dismissAction:(id)sender;
- (IBAction)pageupAction:(id)sender;
- (IBAction)pagedownAction:(id)sender;
- (IBAction)deleteAction:(id)sender;
- (IBAction)saveImageAction:(id)sender;
- (void)setBarTintColor:(UIColor *)tintColor;

@end

@protocol PicBrowserViewDelegate <NSObject>

- (void)dismissAction:(id)sender;
- (void)pageupAction:(id)sender;
- (void)pagedownAction:(id)sender;
- (void)deleteAction:(id)sender;
- (void)mainImgAction:(id)sender;
- (void)saveImageAction:(id)sender;

@end