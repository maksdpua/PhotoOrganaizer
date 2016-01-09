//
//  MSAPIRequestManager.m
//  PhotoOrganaizer
//
//  Created by Maks on 1/7/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import "MSAPIRequestManager.h"

@interface MSAPIRequestManager()

@property (nonatomic, strong) AFHTTPSessionManager *managerRequest;

typedef void (^responseBlock)(NSURLSessionDataTask *operation, id responseObject);
typedef void (^failBlock)(NSURLSessionDataTask *operation, NSError *error);
typedef void (^multipartBlock)(id<AFMultipartFormData> formData);

@end

@implementation MSAPIRequestManager {
    NSDictionary *_parameters;
    NSString *_urlString;
    UIView *_view;
    Class _class;
    UIImage *_image;
    NSData *_dataWithImage;
    
}

+ (instancetype)sharedInstance {
    static MSAPIRequestManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MSAPIRequestManager alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.managerRequest = [AFHTTPSessionManager manager];
        self.managerRequest.requestSerializer = [AFHTTPRequestSerializer serializer];
        
    }
    return self;
}

- (NSDictionary *)dictionaryInstructionManager {
    return @{@"user_id" : @"userID", @"user_session_hash" : @"sessionHash"};
}

#pragma mark - POST & GET Methods

//- (void)manager {
//    _manager = [AFHTTPRequestOperationManager manager];
//}

- (void)setParameters:(NSDictionary *)dictionary {
    _parameters = dictionary;
}

- (void)setURLString:(NSString *)urlString {
    _urlString = urlString;
}

- (void)setView:(UIView *)view {
    _view = view;
}

- (void)setClass:(Class)theClass {
    _class = theClass;
}

- (void)setImage:(UIImage*)image{
    _image = image;
    _dataWithImage = UIImageJPEGRepresentation(_image, 0.5);
}

- (void)requestSerializer {
//    [self.managerRequest.requestSerializer setValue:[AuthorizeManager userID] forHTTPHeaderField:userIDKey];
//    [self.managerRequest.requestSerializer setValue:[AuthorizeManager sessionHash] forHTTPHeaderField:sessionHashKey];
}

- (void)connectionStartPOSTresponse:(void (^)(NSURLSessionDataTask *task, id responseObject))response fail:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure {
    
    responseBlock compl = response;
    failBlock fail = failure;
    
    [self.managerRequest POST:_urlString parameters:_parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self hiddenProgressOnView:_view];
            compl(task, _class ? [self fillObjectResponseWithDictionary:responseObject] : responseObject);
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hiddenProgressOnView:_view];
        fail(task, error);
    }];
    
}

- (void)connectionStartGETresponse:(void (^)(NSURLSessionDataTask *task, id responseObject))response fail:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    responseBlock compl = response;
    failBlock fail = failure;
    
    [self.managerRequest GET:_urlString parameters:_parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self hiddenProgressOnView:_view];
            compl(task, _class ? [self fillObjectResponseWithDictionary:responseObject] : responseObject);
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hiddenProgressOnView:_view];
        fail(task, error);
    }];
}

- (void)connectionStartPOSTresponseWithData:(void (^)(NSURLSessionDataTask *task, id responseObject))response fail:(void (^)(NSURLSessionDataTask *task, NSError *error))failure key:(NSString *)key{
    
    responseBlock compl = response;
    failBlock fail = failure;
    
    [self.managerRequest POST:_urlString parameters:_parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (_dataWithImage) {
            [formData appendPartWithFileData:_dataWithImage name:key fileName:@"testImage.jpeg" mimeType:@"image/jpeg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self hiddenProgressOnView:_view];
            compl(task, _class ? [self fillObjectResponseWithDictionary:responseObject] : responseObject);
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            [self hiddenProgressOnView:_view];
            fail(task, error);
        });
    }];
    
}

- (void)connectionStartPUTresponse:(void (^)(NSURLSessionDataTask *task, id responseObject))response fail:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    responseBlock compl = response;
    failBlock fail = failure;
    
    [self.managerRequest PUT:_urlString parameters:_parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self hiddenProgressOnView:_view];
            compl(task, _class ? [self fillObjectResponseWithDictionary:responseObject] : responseObject);
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hiddenProgressOnView:_view];
        fail(task, error);
    }];
    
}

- (id)fillObjectResponseWithDictionary:(NSDictionary *)dictionary {
    
    //    SEL selector = sel_registerName(SELECTOR_NAME);
    id obj = [_class alloc];
    if ([obj respondsToSelector:@selector(initClassWithDictionary:)]) {
        obj = [obj initClassWithDictionary:dictionary];
    }
    return obj;
}

- (void)showProgressOnView:(UIView *)view {
    if (!view) return;
    [MBProgressHUD showHUDAddedTo:view animated:YES];
}

- (void)hiddenProgressOnView:(UIView *)view {
    if (!view) return;
    [MBProgressHUD hideHUDForView:view animated:YES];
}

- (void)fillManagerURLString:(NSString *)urlString parameters:(NSDictionary *)parameters classMapping:(__unsafe_unretained Class)classMapping showProgressOnView:(UIView *)view {
    //    [self manager];
    
    [self setURLString:urlString];
    [self setParameters:parameters];
    [self setClass:classMapping];
    [self setView:view];
    
    [self showProgressOnView:view];
}

- (void)POSTConnectionWithURLStringAndData:(NSString *)urlString parameters:(NSDictionary *)parameters key:(NSString*)key image:(UIImage *)image classMapping:(Class)classMapping requestSerializer:(BOOL)withSerializer showProgressOnView:(UIView *)view response:(void (^)(NSURLSessionDataTask *operation, id responseObject))response fail:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure {
    
    [self fillManagerURLString:urlString parameters:parameters classMapping:classMapping showProgressOnView:view];
    
    [self setImage:image];
    
    if (withSerializer) {
        [self requestSerializer];
    }
    [self connectionStartPOSTresponseWithData:response fail:failure key:key];
}


- (void)POSTConnectionWithURLString:(NSString *)urlString parameters:(NSDictionary *)parameters classMapping:(Class)classMapping requestSerializer:(BOOL)withSerializer showProgressOnView:(UIView *)view response:(void (^)(NSURLSessionDataTask *task, id responseObject))response fail:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    [self fillManagerURLString:urlString parameters:parameters classMapping:classMapping showProgressOnView:view];
    
    if (withSerializer) {
        [self requestSerializer];
    }
    [self connectionStartPOSTresponse:response fail:failure];
}

- (void)GETConnectionWithURLString:(NSString *)urlString parameters:(NSDictionary *)parameters classMapping:(Class)classMapping requestSerializer:(BOOL)withSerializer showProgressOnView:(UIView *)view response:(void (^)(NSURLSessionDataTask *task, id responseObject))response fail:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    
    [self fillManagerURLString:urlString parameters:parameters classMapping:classMapping showProgressOnView:view];
    
    if (withSerializer) {
        [self requestSerializer];
    }
    [self connectionStartGETresponse:response fail:failure];
}

- (void)PUTConnectionWithURLString:(NSString *)urlString classMapping:(Class)classMapping requestSerializer:(BOOL)withSerializer showProgressOnView:(UIView *)view response:(void (^)(NSURLSessionDataTask *task, id responseObject))response fail:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    [self fillManagerURLString:urlString parameters:nil classMapping:classMapping showProgressOnView:view];
    
    if (withSerializer) {
        [self requestSerializer];
    }
    [self connectionStartPUTresponse:response fail:failure];
}




@end
