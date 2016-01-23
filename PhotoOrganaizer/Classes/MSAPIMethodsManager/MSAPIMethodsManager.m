//
//  MSAPIMethodsManager.m
//  PhotoOrganaizer
//
//  Created by Maks on 1/20/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import "MSAPIMethodsManager.h"
#import "MSFolder.h"

@interface MSAPIMethodsManager()<MSRequestManagerDelegate>

@property (nonatomic, strong) MSRequestManager *requestManager;

@end

@implementation MSAPIMethodsManager {
    NSDictionary *_parameters;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestManager = [[MSRequestManager alloc]initWithDelegate:self];
    }
    return self;
}

- (void)setParametersForFolderWithPath:(NSString *)pathString {
    _parameters = @{@"path" : pathString, @"recursive": @NO, @"include_media_info" : @NO, @"include_deleted" :@YES};
}

- (void)createFolderWithPath:(NSString *)path {
    [self setParametersForFolderWithPath:path];
    
    [self.requestManager createRequestWithPOSTmethodWithAuthAndJSONbodyAtURL:[NSString stringWithFormat:@"%@%@", KMainURL, kCreateFolder] dictionaryParametrsToJSON:_parameters classForFill:[MSFolder class] success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)getFolderContentWithPath:(NSString *)path {
    [self setParametersForFolderWithPath:path];
    [self.requestManager createRequestWithPOSTmethodWithAuthAndJSONbodyAtURL:[NSString stringWithFormat:@"%@%@", KMainURL, kListFolder] dictionaryParametrsToJSON:_parameters classForFill:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
    }];
}



@end
