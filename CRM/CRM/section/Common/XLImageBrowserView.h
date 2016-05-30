//
//  XLImageBrowserView.h
//  CRM
//
//  Created by Argo Zhang on 16/5/27.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLBrowserPicture : NSObject
@property (nonatomic) NSInteger keyidInt;        //区分图片的id (整形)
@property (nonatomic,copy) NSString *keyidStr;   //区分图片的id (字符串)
@property (nonatomic,copy) NSString *title;      //图片描述文字
@property (nonatomic,copy) NSString *url;        //如果是网络图片 给地址
@property (nonatomic, strong)UIImage *image;     //源图片

@property (nonatomic, strong)id obj;//传递的对象

@end

@protocol XLImageBrowserViewDelegate;
@interface XLImageBrowserView : UIView
@property (nonatomic,assign) id <XLImageBrowserViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIToolbar       *topBar;
@property (weak, nonatomic) IBOutlet UIToolbar       *bottomBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *titleBarItem;
@property (weak, nonatomic) IBOutlet UIScrollView    *scrollView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *deleteButton;
@property (weak, nonatomic) IBOutlet UILabel *indexLabel;

//初始化
- (void)setupImageViews:(NSInteger)imageNum;
- (void)setLeftImage:(XLBrowserPicture *)pic;
- (void)setCenterImage:(XLBrowserPicture *)pic;
- (void)setRightImage:(XLBrowserPicture *)pic;

- (IBAction)dismissAction:(id)sender;
- (IBAction)pageupAction:(id)sender;
- (IBAction)pagedownAction:(id)sender;
- (IBAction)deleteAction:(id)sender;
- (void)setBarTintColor:(UIColor *)tintColor;

@end

@protocol XLImageBrowserViewDelegate <NSObject>

- (void)dismissAction:(id)sender;
- (void)pageupAction:(id)sender;
- (void)pagedownAction:(id)sender;
- (void)deleteAction:(id)sender;

@end
