//
//  MSAPIRequestManager.h
//  PhotoOrganaizer
//
//  Created by Maks on 1/7/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

@interface MSAPIRequestManager : NSObject

- (void)POSTConnectionWithURLString:(NSString *)urlString parameters:(NSDictionary *)parameters classMapping:(Class)classMapping requestSerializer:(BOOL)withSerializer showProgressOnView:(UIView *)view response:(void (^)(NSURLSessionDataTask *task, id responseObject))response fail:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void)POSTConnectionWithURLStringAndData:(NSString *)urlString parameters:(NSDictionary *)parameters key:(NSString *)key image:(UIImage *)image classMapping:(Class)classMapping requestSerializer:(BOOL)withSerializer showProgressOnView:(UIView *)view response:(void (^)(NSURLSessionDataTask *task, id responseObject))response fail:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void)GETConnectionWithURLString:(NSString *)urlString classMapping:(Class)classMapping requestSerializer:(BOOL)withSerializer showProgressOnView:(UIView *)view response:(void (^)(NSURLSessionDataTask *task, id responseObject))response fail:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void)PUTConnectionWithURLString:(NSString *)urlString classMapping:(Class)classMapping requestSerializer:(BOOL)withSerializer showProgressOnView:(UIView *)view response:(void (^)(NSURLSessionDataTask *task, id responseObject))response fail:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

@end
