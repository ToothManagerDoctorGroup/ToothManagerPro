//
//  XLSearchDisplayController.m
//  CRM
//
//  Created by Argo Zhang on 16/4/27.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLSearchDisplayController.h"
#import "UITableView+NoResultAlert.h"

@implementation XLSearchDisplayController

- (id)initWithSearchBar:(UISearchBar *)searchBar contentsController:(UIViewController *)viewController
{
    self = [super initWithSearchBar:searchBar contentsController:viewController];
    if (self) {
        // Custom initialization
        _resultsSource = [NSMutableArray array];
        _editingStyle = UITableViewCellEditingStyleDelete;
        
        self.searchResultsDataSource = self;
        self.searchResultsDelegate = self;
        self.delegate = self;
    }
    return self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [tableView createNoResultAlertViewWithImageName:@"searchBar_alert.png" showButton:NO ifNecessaryForRowCount:self.resultsSource.count];
    return [self.resultsSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_cellForRowAtIndexPathCompletion) {
        return _cellForRowAtIndexPathCompletion(tableView, indexPath);
    }
    else{
        static NSString *CellIdentifier = @"ContactListCell";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        return cell;
    }
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    if (_canEditRowAtIndexPath) {
        return _canEditRowAtIndexPath(tableView, indexPath);
    }
    else{
        return NO;
    }
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_commitEditingStyleAtIndexPathCompletion) {
        _commitEditingStyleAtIndexPathCompletion(tableView,indexPath);
    }
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_heightForRowAtIndexPathCompletion) {
        return _heightForRowAtIndexPathCompletion(tableView, indexPath);
    }
    
    return 50;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.editingStyle;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_didSelectRowAtIndexPathCompletion) {
        return _didSelectRowAtIndexPathCompletion(tableView, indexPath);
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_didDeselectRowAtIndexPathCompletion) {
        _didDeselectRowAtIndexPathCompletion(tableView, indexPath);
    }
}

#pragma mark - UISearchDisplayDelegate
- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller NS_DEPRECATED_IOS(3_0,8_0){
    //相对于上面的接口，这个接口可以动画的改变statusBar的前景色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}
- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller NS_DEPRECATED_IOS(3_0,8_0){
    //相对于上面的接口，这个接口可以动画的改变statusBar的前景色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}
- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
}

- (void) keyboardWillHide {
    UITableView *tableView = self.searchResultsTableView;
    [tableView setContentInset:UIEdgeInsetsZero];
    [tableView setScrollIndicatorInsets:UIEdgeInsetsZero];
    
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(nullable NSString *)searchString{
    __weak typeof(self) weakSelf = self;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.001);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        for (UIView *subview in weakSelf.searchResultsTableView.subviews) {
            if ([subview isKindOfClass: [UILabel class]])
            {
                subview.hidden = YES;
            }
        }
    });
    return YES;
}

- (void)setHideNoResult:(BOOL)hideNoResult{
    _hideNoResult = hideNoResult;
    
    for (UIView *subview in self.searchResultsTableView.subviews) {
        if ([subview isKindOfClass: [UIImageView class]])
        {
            subview.hidden = hideNoResult;
        }
    }
}

- (void)setNoResultImage:(NSString *)noResultImage{
    _noResultImage = noResultImage;
    
    for (UIView *subview in self.searchResultsTableView.subviews) {
        if ([subview isKindOfClass: [UIImageView class]])
        {
            UIImageView *imageView = (UIImageView *)subview;
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:noResultImage ofType:@"png"];
            imageView.image = [UIImage imageWithContentsOfFile:imagePath];
        }
    }
}

@end
