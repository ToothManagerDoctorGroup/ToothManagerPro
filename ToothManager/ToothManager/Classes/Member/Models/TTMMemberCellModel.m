//
//  TTMMemberCellModel.m
//  ToothManager
//

#import "TTMMemberCellModel.h"

@implementation TTMMemberCellModel

- (instancetype)initWithTitle:(NSString *)title
                      content:(NSString *)content
                  buttonTitle:(NSString *)buttonTitle
                  contenColor:(UIColor *)contenColor
                   messageNum:(NSUInteger)messageNum
                   accessType:(TTMMemberCellModelAccessType)accessType {
    if (self = [super init]) {
        _title = title;
        _content = content;
        _buttonTitle = buttonTitle;
        _contenColor = contenColor;
        _messageNum = messageNum;
        _accessType = accessType;
    }
    return self;
}

@end
