//
//  XLSearchDisplayController.h
//  CRM
//
//  Created by Argo Zhang on 16/4/27.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLSearchDisplayController : UISearchDisplayController<UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate>

@property (strong, nonatomic) NSMutableArray *resultsSource;

@property (nonatomic, assign)BOOL hideNoResult;

@property (nonatomic, copy)NSString *noResultImage;

//编辑cell时显示的风格，默认为UITableViewCellEditingStyleDelete；会将值付给[tableView:editingStyleForRowAtIndexPath:]
@property (nonatomic) UITableViewCellEditingStyle editingStyle;

@property (copy) UITableViewCell * (^cellForRowAtIndexPathCompletion)(UITableView *tableView, NSIndexPath *indexPath);

@property (copy) BOOL (^canEditRowAtIndexPath)(UITableView *tableView, NSIndexPath *indexPath);
@property (copy) CGFloat (^heightForRowAtIndexPathCompletion)(UITableView *tableView, NSIndexPath *indexPath);
@property (copy) void (^didSelectRowAtIndexPathCompletion)(UITableView *tableView, NSIndexPath *indexPath);
@property (copy) void (^didDeselectRowAtIndexPathCompletion)(UITableView *tableView, NSIndexPath *indexPath);

//编辑风格
@property (copy) void (^commitEditingStyleAtIndexPathCompletion)(UITableView *tableView, NSIndexPath *indexPath);

@end
