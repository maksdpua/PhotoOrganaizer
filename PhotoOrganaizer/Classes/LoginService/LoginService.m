//
//  LoginService.m
//  PhotoOrganaizer
//
//  Created by Maks on 1/8/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import "LoginService.h"
#import "MSAPIRequestManager.h"
#import <AFNetworking.h>

static NSString *const kAuthRequestURL  = @"https://www.dropbox.com/1/oauth2/authorize";
static NSString *const kRedirectURI = @"datarecevier://https";
static NSString *const kResponseType = @"token";
static NSString *const kClientID = @"lgfw6aan5s7raaj";
static NSString *const kClientSecret = @"39tw5d52v977l3v";
static NSString *const kState = @"phorg";

//https://www.dropbox.com/1/oauth2/authorize?client_id=lgfw6aan5s7raaj&response_type=token&redirect_uri=https://datarecevier&state=test/dropbox-auth-finish
//oauth/request_token
@implementation LoginService

+ (void)loginWithURL:(NSURL*)url {
    NSString *code = [url absoluteString];
//    code = [code stringByReplacingOccurrencesOfString:@"walkingmaks:?code=" withString:@""];
    
}

+ (void)startLogin {
//    NSDictionary *parametrs = @{@"response_type": kResponseType,
//                                @"client_id" : kClientID,
//                                @"redirect_uri" : kRedirectURI,
//                                @"state" : kState
//                                };
//    
//    
////    NSString *urlString = [NSString stringWithFormat:@"%@?client_id=%@&response_type=%@&redirect_uri=%@&state=%@", kAuthRequestURL, kClientID, kResponseType, kRedirectURI, kState];
////    NSString *urlString = [NSString stringWithFormat:kAuthRequestURL];
////    [[MSAPIRequestManager sharedInstance] GETConnectionWithURLString:urlString parameters:parametrs classMapping:nil requestSerializer:YES showProgressOnView:nil response:^(NSURLSessionDataTask *task, id responseObject) {
////        NSLog(@"%@", responseObject);
////    } fail:^(NSURLSessionDataTask *task, NSError *error) {
////        NSLog(@"%@", error);
////    }];
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@?client_id=%@&response_type=%@&redirect_uri=%@&state=%@", kAuthRequestURL, kClientID, kResponseType, kRedirectURI, kState];
    NSURL *authUrl = [NSURL URLWithString:urlString];
    
    [[UIApplication sharedApplication] openURL:authUrl];
    
}


@end
