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



- (void)cacheForImageWithKey:(MSPhoto *)photo completeBlock:(void (^)(NSData *responseData))complete errorBlock:(void (^)(NSError *error))fail {
    self.answerBlock = complete;
    self.requestManager = [[MSRequestManager alloc]initWithDelegate:self];
    NSDictionary *parametrs = @{@"path" : photo.path, @"format" : @"jpeg", @"size" : @"w640h480"};
    
    [self.requestManager createRequestWithPOSTmethodWithAuthAndJSONbodyAtURL:[NSString stringWithFormat:@"%@%@", kContentURL, kGetThumbnail] dictionaryParametrsToJSON:parametrs classForFill:nil upload:^(NSProgress *uploadProgress) {
        
    } download:^(NSProgress *downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        MSThumbnail *thumbnail = [MSThumbnail MR_createEntity];
        thumbnail.data = responseObject;
        photo.imageThumbnail = thumbnail;
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        
        self.answerBlock((NSData *)responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error);
    }];
}

+ (NSData *)imageWithImage:(NSData *)data
              scaledToSize:(CGSize)newSize {
    UIImage *image = [UIImage imageWithData:data];
    UIGraphicsBeginImageContext( newSize );

    if (image.size.width>image.size.height) {
        
        [image drawInRect:CGRectMake(0,0,[@240 floatValue],[@480 floatValue])];
    }
    
//    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImageJPEGRepresentation(newImage, 1);
}

@end
