//
//  TTMIncomeCellModel.m
//  ToothManager
//

#import "TTMIncomeCellModel.h"
#import "TTMIncomeModel.h"

#define kLineViewH 35.f
#define kMargin 10.f

@implementation TTMIncomeCellModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.infoList = [NSMutableArray array];
    }
    return self;
}

+ (void)initialize {
    if (self == [TTMIncomeCellModel class]) {
        [self setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"keyId": @"KeyId"};
        }];
    }
}

- (CGFloat)cellHeight {
    if (!_cellHeight) {
        _cellHeight = self.infoList.count * kLineViewH + 6 * kMargin;
    }
    return _cellHeight;
}

+ (void)queryIncomeListWithComplete:(CompleteBlock)complete {
    TTMUser *user = [TTMUser unArchiveUser];
    // 必填项
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:user.keyId forKey:@"clinicid"];
    [param setObject:user.accessToken forKey:@"accessToken"];
    [param setObject:@"getList" forKey:@"action"];
    
    [TTMNetwork getWithURL:QueryIncomeListURL params:param success:^(id responseObject) {
        TTMResponseModel *response = [TTMResponseModel objectWithKeyValues:responseObject];
        if (response.code == kSuccessCode) {
            NSArray *resultArray = response.result;
            NSMutableArray *mutArray = [NSMutableArray array];
            for (NSDictionary *dict in resultArray) {
                TTMIncomeModel *model = [TTMIncomeModel objectWithKeyValues:dict];
                [mutArray addObject:model];
            }
            complete(mutArray);
        } else {
            complete(response.result);
        }
    } failure:^(NSError *error) {
        complete(NetError);
    }];
}
@end
