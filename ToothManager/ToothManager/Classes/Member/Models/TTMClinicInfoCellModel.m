
#import "TTMClinicInfoCellModel.h"

@implementation TTMClinicInfoCellModel


+ (instancetype)modelWithTitle:(NSString *)title
                       content:(NSString *)content
                      imageURL:(NSString *)imageURL
                          type:(TTMClinicCellModelType)type
               controllerClass:(Class)controllerClass {
    TTMClinicInfoCellModel *model = [TTMClinicInfoCellModel new];
    model.title = title;
    model.content = content;
    model.imageURL = imageURL;
    model.type = type;
    model.controllerClass = controllerClass;
    return model;
}
@end
