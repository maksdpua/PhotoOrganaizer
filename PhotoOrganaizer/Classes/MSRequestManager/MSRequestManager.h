//
//  MSRequestManager.h
//  PhotoOrganaizer
//
//  Created by Maks on 1/14/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MSRequestManagerDelegate;

@interface MSRequestManager : NSObject

@property (nonatomic, weak) id<MSRequestManagerDelegate>delegate;

- (instancetype)initWithDelegate:(id<MSRequestManagerDelegate>)delegate;

- (void)createRequestWithPOSTmethodWithAuthAndJSONbodyAtURL:(NSString *)urlString dictionaryParametrsToJSON:(NSDictionary *)dictionary classForFill:(Class)class success: (void(^)(NSURLSessionDataTask *task, id responseObject))successBlock failure: (void(^)(NSURLSessionDataTask *task, NSError *error))failureBlock;

@end

@protocol MSRequestManagerDelegate <NSObject>

@optional



@end
