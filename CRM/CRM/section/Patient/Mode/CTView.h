//
//  CTView.h
//  CRM
//
//  Created by Kane.Zhu on 14-5-18.
//  Copyright (c) 2014年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewCaseScrollew.h"
#import "TimFramework.h"
#import "DBTableMode.h"
#import "CaseFunction.h"
#import "MWPhotoBrowser.h"


@protocol CTViewDelegate;
@interface CTView : UIView <UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,MWPhotoBrowserDelegate>
{

    NewCaseScrollew * CTScrollView;
    UIButton * addCTButton;
    float scrollWidth;
    float scrollHeight;
    TimViewController * timViewController;
    MedicalCase *medicalcase;
    CaseFunction * caseFunction;
    //图片浏览器
    MWPhotoBrowser * browser;
    NSMutableArray * photoArray;
    NSMutableArray * ctlibArray;
    NSMutableArray * imageCacheArray;
    NSInteger touchIndex;
}

@property (nonatomic,assign) id <CTViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame WithSuperController:(TimViewController *)controller WithMedicalCase:(MedicalCase *)mCase;

- (BOOL)saveCTLibWithCaseId:(NSString *)caseid;

@end

@protocol CTViewDelegate <NSObject>

- (void)onDeleteButtonAction:(id)sender;

@end