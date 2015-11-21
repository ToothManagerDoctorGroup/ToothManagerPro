//
//  MenuView.h
//  CRM
//
//  Created by lsz on 15/11/12.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MenuViewDelegate;

@interface MenuView : UIView

@property(nonatomic,assign) id<MenuViewDelegate> delegate;

@end

@protocol MenuViewDelegate <NSObject>

-(void)yuyueButtonDidSelected;
-(void)huanzheButtonDidSeleted;

@end