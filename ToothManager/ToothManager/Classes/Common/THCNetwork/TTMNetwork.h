//
//  THCNetwork.h
//  THCFramework
//

#import <Foundation/Foundation.h>

/**
 *  请求成功的block
 *
 *  @param responseObject 返回的数据
 */
typedef void(^Success)(id responseObject);

/**
 *  请求失败的block
 *
 *  @param error 错误信息
 */
typedef void(^Failure)(NSError *error);

/*!
 @class
 @abstract 封装的网络请求类，封装了AFNetworking的所有请求方法
 */
@interface TTMNetwork : NSObject

/*!
 @method
 @abstract GET请求
 @discussion GET请求
 
 @param url       请求的url
 @param params    请求的参数
 @param success   请求成功的Block
 @param failure   请求失败的Block
 */
+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params success:(Success)success failure:(Failure)failure;


/*!
 @method
 @abstract HEAD请求
 @discussion HEAD请求
 
 @param url       请求的url
 @param params    请求的参数
 @param success   请求成功的Block
 @param failure   请求失败的Block
 */
+ (void)headWithURL:(NSString *)url params:(NSDictionary *)params success:(Success)success failure:(Failure)failure;

/*!
 @method
 @abstract POST请求
 @discussion POST请求
 
 @param url       请求的url
 @param params    请求的参数
 @param success   请求成功的Block
 @param failure   请求失败的Block
 */
+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(Success)success failure:(Failure)failure;

/*!
 @method
 @abstract POST请求，上传文件
 @discussion POST请求，上传文件
 
 @param url              请求的url
 @param params           请求的参数
 @param formDataArray    上传的文件数据数组
 @param success          请求成功的Block
 @param failure          请求失败的Block
 */
+ (void)postDataWithURL:(NSString *)url params:(NSDictionary *)params
                                 formDataArray:(NSArray *)formDataArray
                                       success:(Success)success
                                       failure:(Failure)failure;

/*!
 @method
 @abstract PUT请求
 @discussion PUT请求
 
 @param url       请求的url
 @param params    请求的参数
 @param success   请求成功的Block
 @param failure   请求失败的Block
 */
+ (void)putWithURL:(NSString *)url params:(NSDictionary *)params success:(Success)success failure:(Failure)failure;

/*!
 @method
 @abstract PATCH请求
 @discussion PATCH请求
 
 @param url       请求的url
 @param params    请求的参数
 @param success   请求成功的Block
 @param failure   请求失败的Block
 */
+ (void)patchWithURL:(NSString *)url params:(NSDictionary *)params success:(Success)success failure:(Failure)failure;

/*!
 @method
 @abstract DELETE请求
 @discussion DELETE请求
 
 @param url       请求的url
 @param params    请求的参数
 @param success   请求成功的Block
 @param failure   请求失败的Block
 */
+ (void)deleteWithURL:(NSString *)url params:(NSDictionary *)params success:(Success)success failure:(Failure)failure;

@end


/*!
 @class
 @abstract 上传文件的模型
 */
@interface THCUploadFormData : NSObject
/*!
 @property
 @abstract 文件数据
 */
@property (nonatomic, strong) NSData *data;

/*!
 @property
 @abstract 参数名
 */
@property (nonatomic, copy) NSString *name;

/*!
 @property
 @abstract 文件名
 */
@property (nonatomic, copy) NSString *filename;

/*!
 @property
 @abstract 文件的mimeType类型
 */
@property (nonatomic, copy) NSString *mimeType;


@end
