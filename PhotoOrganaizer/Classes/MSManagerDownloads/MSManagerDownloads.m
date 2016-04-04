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
        sharedManager = [[MSManagerDownloads alloc] init];
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

- (void)addNewImageInfo:(NSArray <NSDictionary *> *)imageInfo {
    [imageInfo enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull objPath, NSUInteger idx, BOOL * _Nonnull stop) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"path LIKE[cd] %@", [objPath valueForKey:@"path"]];
        NSArray *found = [_uploads filteredArrayUsingPredicate:predicate];
        if (!found.count) {
            MSUploadInfo *info = [MSUploadInfo new];
            info.path = [objPath valueForKey:@"path"];
            info.data = [objPath valueForKey:@"imageData"];
            info.status = Wait;
            
            [_uploads addObject:info];
        }
    }];
    
    [self startUpload];
}

//{


- (void)startUpload {
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (!_uploads.count && !_currentUpload)
            return;
        
        _currentUpload = _uploads.firstObject;
        _currentUpload.status = InProgress;
        _currentUpload.progress = 0.f;
        
        NSDictionary *parametrs = @{@"path" : _currentUpload.path, @"mode" : @"add", @"autorename" : @YES, @"mute" : @NO};
    self.requestManager = [[MSRequestManager alloc]initWithDelegate:self];
        [self.requestManager createRequestWithPOSTmethodWithFileUpload:_currentUpload.data stringURL:urlPath(kContentURL, kUpload) dictionaryParametrsToJSON:parametrs classForFill:[MSPhoto class]
                                                                upload:^(NSProgress *uploadProgress) {
                                                                    _currentUpload.progress = uploadProgress.fractionCompleted;
                                                                } download:^(NSProgress *downloadProgress) {
                                                                    
                                                                } success:^(NSURLSessionDataTask *task, id responseObject) {
                                                                    NSLog(@"Succes %@", responseObject);
                                                                    _currentUpload.status = Completed;
                                                                    
                                                                    [_uploads removeObject:_currentUpload];
                                                                    
                                                                    _currentUpload = nil;
                                                                    
                                                                    [[NSNotificationCenter defaultCenter]postNotificationName:MANAGER_DOWNLOADS_DID_FINISH_NOTIFICATION object:nil];
                                                                    
                                                                    [self startUpload];
                                                                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                                    NSLog(@"Error %@", error);
                                                                    [_uploads removeObject:_currentUpload];
                                                                    
                                                                    _currentUpload = nil;
                                                                }];
    });
    
}

#pragma mark - Download datasource

- (NSUInteger)modelsCount {
    if (_uploads.count) {
        return _uploads.count;
    }
    return 0;
}

- (MSUploadInfo *)uploadModelAtIndex:(NSUInteger)index {
    return [_uploads objectAtIndex:index];
}

@end
