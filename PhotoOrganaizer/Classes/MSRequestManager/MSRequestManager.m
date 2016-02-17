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

typedef void (^recieveBlock)(NSURLSessionDataTask *task, id responseObject);
typedef void (^failBlock)(NSURLSessionDataTask *task, NSError *error);

@end

@implementation MSRequestManager {
    NSString *_urlString;
    NSMutableURLRequest *_request;
    NSDictionary *_jsonDictionary;
    Class _class;
}


- (instancetype)initWithDelegate:(id<MSRequestManagerDelegate>)delegate {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.sessionManager = [AFHTTPSessionManager manager];
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
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        [_request setValue:jsonString forHTTPHeaderField:kDropboxAPIarg];
    } else {
        [_request setHTTPBody:jsonData];
    }
    
}

- (void)setHTTPHeaderFieldForAuth {
    
    [_request setValue: [NSString stringWithFormat:@"%@ %@" ,kBearer,[MSAuth token]] forHTTPHeaderField:kAuthorization];
}

- (void)setHTTPHeaderFieldForJSONandApp {
    [_request setValue:@"application/json" forHTTPHeaderField:kContentType];
}

- (void)setHTTPHeaderFieldForDropboxAPIarg {
    
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

- (void)createTaskWithSuccess:(void(^)(NSURLSessionDataTask *task, id responseObject))successBlock failure: (void(^)(NSURLSessionDataTask *task, NSError *error))failureBlock{
    NSURLSessionDataTask *task = [self.sessionManager dataTaskWithRequest:_request completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
        if (error) {
            failureBlock(task, error);
        } else {
            successBlock(task, _class ? [self fillObjectResponseWithDictionary:responseObject] : responseObject);
        }
    }];
    [task resume];
}

- (void)createRequestWithPOSTmethodWithAuthAndJSONbodyAtURL:(NSString *)urlString dictionaryParametrsToJSON:(NSDictionary *)dictionary classForFill:(Class)class success: (void(^)(NSURLSessionDataTask *task, id responseObject))responseBlock failure: (void(^)(NSURLSessionDataTask *task, NSError *error))errorBlock {
    recieveBlock receiver = responseBlock;
    failBlock blockForError = errorBlock;
    
    [self fillManagerWithURLstring:urlString setParamterDictionary:dictionary setClass:class];
    NSError *error;
    _request = [self.sessionManager.requestSerializer requestWithMethod:@"POST" URLString:urlString parameters:nil error:&error];

    [self setHTTPHeaderFieldForAuth];
    if (![dictionary valueForKey:@"format"]) {
        [self setHTTPHeaderFieldForJSONandApp];
    }
    [self setHTTPbodyWithDictionary];
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self createTaskWithSuccess:receiver failure:blockForError];
    });
    
}


@end
