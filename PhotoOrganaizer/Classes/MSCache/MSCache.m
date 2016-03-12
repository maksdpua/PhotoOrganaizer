//
//  MSCache.m
//  PhotoOrganaizer
//
//  Created by Maks on 3/5/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import "MSCache.h"
#import "MSRequestManager.h"

@interface MSCache()<MSRequestManagerDelegate>

@property (nonatomic, strong) MSRequestManager *requestManager;

typedef void (^recieveBlock)(NSData *data);

@property (copy) recieveBlock answerBlock;

@end

@implementation MSCache

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)cacheForImageWithKey:(MSPhoto *)photo completeBlock:(void (^)(NSData *responseData))complete errorBlock:(void (^)(NSError *error))fail {
    self.answerBlock = complete;
    self.requestManager = [[MSRequestManager alloc]initWithDelegate:self];
    NSDictionary *parametrs = @{@"path" : photo.idPhoto, @"format" : @"jpeg", @"size" : @"w640h480"};
    [self.requestManager createRequestWithPOSTmethodWithAuthAndJSONbodyAtURL:[NSString stringWithFormat:@"%@%@", kContentURL, kGetThumbnail] dictionaryParametrsToJSON:parametrs classForFill:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
//        dispatch_async(dispatch_get_main_queue(), ^(void){
            MSThumbnail *thumbnail = [MSThumbnail MR_createEntity];
            thumbnail.data = responseObject;
            photo.imageThumbnail = thumbnail;
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
//            complete((NSData *)responseObject);
        self.answerBlock((NSData *)responseObject);
//        });
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error);
    }];
}

@end
