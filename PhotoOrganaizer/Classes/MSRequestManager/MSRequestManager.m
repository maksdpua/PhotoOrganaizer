//
//  MSRequestManager.m
//  PhotoOrganaizer
//
//  Created by Maks on 1/14/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import "MSRequestManager.h"
#import <AFNetworking.h>
#import "MSAuth.h"

static NSString *const kBearer = @"Bearer";
static NSString *const kAuthorization = @"Authorization";
static NSString *const kContentType = @"Content-Type";
static NSString *const kDropboxAPIarg = @"Dropbox-API-Arg";

@interface MSRequestManager()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@property (nonatomic, strong) NSMutableURLRequest *urlRequest;

typedef void (^recieveBlock)(NSURLSessionDataTask *task, id responseObject);
typedef void (^failBlock)(NSURLSessionDataTask *task, NSError *error);
typedef void (^uploadProgressBlock)(NSProgress*  uploadProgress);
typedef void (^downloadProgressBlock)(NSProgress*  downloadProgress);

@end

@implementation MSRequestManager {
    NSString *_urlString;
    NSDictionary *_jsonDictionary;
    Class _class;
}


- (instancetype)initWithDelegate:(id<MSRequestManagerDelegate>)delegate {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.sessionManager = [AFHTTPSessionManager manager];
        self.urlRequest = [[NSMutableURLRequest alloc]init];
    }
    return self;
}

- (void)setURLstring:(NSString *)string {
    _urlString = string;
}

- (void)setJSONdictionary:(NSDictionary *)dictionary {
    _jsonDictionary = dictionary;
}

- (void)setClass:(Class)theClass {
    _class = theClass;
}

- (void)setHTTPbodyWithDictionary {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_jsonDictionary
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if ([_jsonDictionary valueForKey:@"format"]) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_jsonDictionary
                                                           options:0
                                                             error:&error];
        NSString* jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [self.urlRequest setValue:jsonString forHTTPHeaderField:kDropboxAPIarg];
        self.sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    } else {
        [self.urlRequest setHTTPBody:jsonData];
    }
    
}

- (void)setHTTPHeaderFieldForAuth {
    
    [self.urlRequest setValue: [NSString stringWithFormat:@"%@ %@" ,kBearer,[MSAuth token]] forHTTPHeaderField:kAuthorization];
}

- (void)setHTTPHeaderFieldForJSONandApp {
    [self.urlRequest setValue:@"application/json" forHTTPHeaderField:kContentType];
}

- (void)fillMutableURLrequestWithMethod:(NSString *)method {
    [self.urlRequest setHTTPMethod:method];
    [self.urlRequest setURL:[NSURL URLWithString:_urlString]];
}

- (void)fillManagerWithURLstring:(NSString *)urlString setParamterDictionary:(NSDictionary *)paramtersDictionary setClass:(Class)class {
    [self setURLstring:urlString];
    [self setJSONdictionary:paramtersDictionary];
    [self setClass:class];
}

- (id)fillObjectResponseWithDictionary:(NSDictionary *)dictionary {
    id obj = [_class alloc];
    if ([obj respondsToSelector:@selector(initClassWithDictionary:)]) {
        obj = [obj initClassWithDictionary:dictionary];
    }
    return obj;
}

- (void)createTaskWithSuccess:(void(^)(NSURLSessionDataTask *task, id responseObject))successBlock failure: (void(^)(NSURLSessionDataTask *task, NSError *error))failureBlock upload:(void(^)(NSProgress *uploadProgress))uploadBlock download:(void(^)(NSProgress *downloadProgress))downloadBlock {
    
//    [self.sessionManager setTaskDidSendBodyDataBlock:^(NSURLSession *session, NSURLSessionTask *task, int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        //during the progress
//    }];
    NSURLSessionDataTask *task = [self.sessionManager dataTaskWithRequest:self.urlRequest uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        uploadBlock(uploadProgress);
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        downloadBlock(downloadProgress);
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            failureBlock(task, error);
        } else {
            successBlock(task, _class ? [self fillObjectResponseWithDictionary:responseObject] : responseObject);
        }
    }];
    
    
//    NSURLSessionDataTask *task = [self.sessionManager dataTaskWithRequest:self.urlRequest completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
//        if (error) {
//            failureBlock(task, error);
//        } else {
//            successBlock(task, _class ? [self fillObjectResponseWithDictionary:responseObject] : responseObject);
//        }
//        
//    }];
    
    [task resume];
}

- (void)createRequestWithPOSTmethodWithAuthAndJSONbodyAtURL:(NSString *)urlString dictionaryParametrsToJSON:(NSDictionary *)dictionary classForFill:(Class)class upload:(void (^)(NSProgress * uploadProgress))uploadBlock download:(void (^)(NSProgress *downloadProgress))downloadBlock  success: (void(^)(NSURLSessionDataTask *task, id responseObject))responseBlock failure: (void(^)(NSURLSessionDataTask *task, NSError *error))errorBlock {
    recieveBlock receiver = responseBlock;
    failBlock blockForError = errorBlock;
    uploadProgressBlock upload = uploadBlock;
    downloadProgressBlock donwload = downloadBlock;
    
    [self fillManagerWithURLstring:urlString setParamterDictionary:dictionary setClass:class];

    [self fillMutableURLrequestWithMethod:@"POST"];

    [self setHTTPHeaderFieldForAuth];
    if (![dictionary valueForKey:@"format"]) {
        [self setHTTPHeaderFieldForJSONandApp];
    }
    [self setHTTPbodyWithDictionary];

    [self createTaskWithSuccess:receiver failure:blockForError upload:upload download:donwload];

    
}

- (void)createRequestWithPOSTmethodWithFileUpload:(NSData *)data stringURL:(NSString *)urlString dictionaryParametrsToJSON:(NSDictionary *)dictionary classForFill:(Class)class upload:(void (^)(NSProgress * uploadProgress))uploadBlock download:(void (^)(NSProgress *downloadProgress))downloadBlock success:(void (^)(NSURLSessionDataTask *task, id responseObject))successBlock failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failureBlock {
    recieveBlock receiver = successBlock;
    failBlock blockForError = failureBlock;
    uploadProgressBlock upload = uploadBlock;
    downloadProgressBlock donwload = downloadBlock;
    
    [self fillManagerWithURLstring:urlString setParamterDictionary:dictionary setClass:class];
    [self fillMutableURLrequestWithMethod:@"POST"];
    [self setHTTPHeaderFieldForAuth];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_jsonDictionary
                                                       options:0
                                                         error:&error];
    NSString* jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [self.urlRequest setValue:jsonString forHTTPHeaderField:kDropboxAPIarg];

    
    [self.urlRequest setValue:@"application/octet-stream" forHTTPHeaderField:kContentType];
    
    
    [self.urlRequest setHTTPBody:data];
    
    [self createTaskWithSuccess:receiver failure:blockForError upload:upload download:donwload];
    
}


@end
