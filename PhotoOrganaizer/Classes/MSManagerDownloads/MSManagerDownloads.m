//
//  MSManagerDownloads.m
//  PhotoOrganaizer
//
//  Created by Maks on 4/3/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import "MSManagerDownloads.h"
#import "MSRequestManager.h"
#import "MSUploadInfo.h"
#import "MSPhoto.h"

//static NSString * const MANAGER_DOWNLOADS_DID_FINISH_NOTIFICATION = @"MANAGER_DOWNLOADS_DID_FINISH_NOTIFICATION";

@interface MSManagerDownloads() <NSObject, MSRequestManagerDelegate>

@property (nonatomic, strong) MSRequestManager *requestManager;

@end

@implementation MSManagerDownloads {
    NSMutableArray *_uploads;
    MSUploadInfo *_currentUpload;
}

+ (instancetype)sharedManager {
    static MSManagerDownloads *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _uploads = [NSMutableArray new];
    }
    return self;
}

- (void)addNewPath:(NSArray<NSString *> *)path {
    [path enumerateObjectsUsingBlock:^(NSString * _Nonnull objPath, NSUInteger idx, BOOL * _Nonnull stop) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"path LIKE[cd] %@", objPath];
        NSArray *found = [_uploads filteredArrayUsingPredicate:predicate];
        if (!found.count) {
            MSUploadInfo *info = [MSUploadInfo new];
            info.path = objPath;
            info.status = Wait;
            
            [_uploads addObject:info];
        }
    }];
    
    [self startUpload];
}

- (void)startUpload {
    dispatch_sync(dispatch_get_main_queue(), ^{
        if (!_uploads.count && !_currentUpload)
            return;
        
        _currentUpload = _uploads.firstObject;
        _currentUpload.status = InProgress;
        _currentUpload.progress = 0.f;
        
        NSDictionary *parametrs = @{};
        
        [self.requestManager createRequestWithPOSTmethodWithFileUpload:_currentUpload.data stringURL:[NSString stringWithFormat:@""] dictionaryParametrsToJSON:parametrs classForFill:[MSPhoto class]
                                                                upload:^(NSProgress *uploadProgress) {
                                                                    _currentUpload.progress = uploadProgress.fractionCompleted;
                                                                } download:^(NSProgress *downloadProgress) {
                                                                    
                                                                } success:^(NSURLSessionDataTask *task, id responseObject) {
                                                                    _currentUpload.status = Completed;
                                                                    
                                                                    [_uploads removeObject:_currentUpload];
                                                                    
                                                                    
                                                                    
                                                                    _currentUpload = nil;
                                                                    
                                                                    [self startUpload];
                                                                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                                    
                                                                }];
    });
    
}

@end
