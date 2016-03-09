//
//  XLGroupMembersView.m
//  CRM
//
//  Created by Argo Zhang on 16/3/7.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLGroupMembersView.h"
#import "XLAvatarView.h"
#import "XLDoctorSelectViewController.h"
#import "UIView+WXViewController.h"
#import "XLTeamMemberModel.h"
#import "UIColor+Extension.h"

@interface XLGroupMembersView ()<XLAvatarViewDelegate>

@property (nonatomic, strong)NSMutableArray *targetList;

@end

@implementation XLGroupMembersView

- (NSMutableArray *)targetList{
    if (!_targetList) {
        _targetList = [NSMutableArray array];
    }
    return _targetList;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setMembers:(NSArray *)members{
    _members = members;
    
    //首先移除原有视图
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    
    NSInteger count = 5;
    CGFloat avatarW = 50;
    CGFloat avatarH = 75;
    CGFloat avatarX = 0;
    CGFloat avatarY = 0;
    
    CGFloat margin = (kScreenWidth - count * avatarW) / 6;
    CGFloat marginY = 20;
    
    [self.targetList removeLastObject];
    [self.targetList removeLastObject];
    [self.targetList addObjectsFromArray:members];
    [self.targetList addObject:[UIImage imageNamed:@"team_add_head"]];
    [self.targetList addObject:[UIImage imageNamed:@"team_del_head"]];
    
    for (int i = 0; i < self.targetList.count; i++) {
        //计算当前的图片的坐标，固定5列
        int index_x = i / count;
        int index_y = i % count;
        
        avatarX = margin + (margin + avatarW) * index_y;
        avatarY = marginY + (marginY + avatarH) * index_x;
        
        XLAvatarView *avatarView = [[XLAvatarView alloc] initWithFrame:CGRectMake(avatarX, avatarY, avatarW, avatarH)];
        avatarView.tag = 100 + i;
        [avatarView addTarget:self action:@selector(avatarAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:avatarView];
        
        if (i > self.targetList.count - 3) {
            avatarView.image = self.targetList[i];
        }else{
            XLTeamMemberModel *model = self.targetList[i];
            avatarView.urlStr = model.doctor_image;
            avatarView.title = model.member_name;
        }
    }
    
    for (int i = 0; i < 2; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, i * (self.height - .5), kScreenWidth, .5)];
        view.backgroundColor = [UIColor colorWithHex:0xCCCCCC];
        [self addSubview:view];
    }
}

- (CGFloat)getHeight{
    NSInteger count = self.targetList.count / 5 == 0 ? self.targetList.count / 5 : self.targetList.count / 5 + 1;
    return count * 75 + 20 * (count + 1);
}

#pragma mark - 头像点击事件
- (void)avatarAction:(UIButton *)view{
    NSInteger tag = view.superview.tag;
    if (tag == self.targetList.count - 1 + 100) {
        XLDoctorSelectViewController *selectVc = [[XLDoctorSelectViewController alloc] init];
        selectVc.type = DoctorSelectTypeRemove;
        selectVc.mCase = self.mCase;
        [self.viewController.navigationController pushViewController:selectVc animated:YES];
        NSLog(@"删除成员");
    }else if (tag == self.targetList.count - 2 + 100){
        NSLog(@"添加成员");
        XLDoctorSelectViewController *selectVc = [[XLDoctorSelectViewController alloc] init];
        selectVc.type = DoctorSelectTypeAdd;
        selectVc.mCase = self.mCase;
        [self.viewController.navigationController pushViewController:selectVc animated:YES];
    }
}


@end