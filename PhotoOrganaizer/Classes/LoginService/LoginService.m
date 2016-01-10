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


@implementation LoginService

+ (void)loginWithURL:(NSURL*)url {
    NSString *code = [url absoluteString];
    code = [code stringByReplacingOccurrencesOfString:@"datarecevier://https#access_token=" withString:@""];
    NSString *token = [[code componentsSeparatedByString:@"&"]objectAtIndex:0];
    NSString *uid = [[code componentsSeparatedByString:@"uid="]lastObject];
    [[NSUserDefaults standardUserDefaults]setObject:token forKey:kToken];
    [[NSUserDefaults standardUserDefaults]setObject:uid forKey:kUID];
}

+ (NSURL *)startLogin {
    NSString *urlString = [NSString stringWithFormat:@"%@?client_id=%@&response_type=%@&redirect_uri=%@&state=%@", kAuthRequestURL, kClientID, kResponseType, kRedirectURI, kState];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    return [NSURL URLWithString:urlString];
}


@end
