//
//  MSMainVCWebView.m
//  PhotoOrganaizer
//
//  Created by Maks on 1/10/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import "MSMainVCWebView.h"
#import "LoginService.h"

@interface MSMainVCWebView()<UIWebViewDelegate,NSURLSessionDelegate, NSURLSessionDataDelegate>

@end

@implementation MSMainVCWebView {
    IBOutlet UIWebView *webView;
    BOOL isauth;
}

- (void)viewDidLoad {
    [webView loadRequest:[NSURLRequest requestWithURL:[LoginService startLogin]]];
    isauth = NO;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
    
    if (!isauth) {
        isauth = NO;
        NSURLSession *session = [[NSURLSession alloc] init];
        [session dataTaskWithRequest:request];
        return NO;
    }
    return YES;
}


//in nsurlconnections delegate. This one deals with the authentication challenge. this time set isauth to YES

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * __nullable credential))completionHandler {
    if ([challenge previousFailureCount] == 0) {
        isauth = YES;
        [[challenge sender] useCredential:[NSURLCredential credentialWithUser:@"username" password:@"password"  persistence:NSURLCredentialPersistencePermanent] forAuthenticationChallenge:challenge];
    }
    else
        [[challenge sender] cancelAuthenticationChallenge:challenge];
}

//- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
//{
//    
//    if ([challenge previousFailureCount] == 0) {
//        isauth = YES;
//        [[challenge sender] useCredential:[NSURLCredential credentialWithUser:@"username" password:@"password"  persistence:NSURLCredentialPersistencePermanent] forAuthenticationChallenge:challenge];
//    }
//    else
//        [[challenge sender] cancelAuthenticationChallenge:challenge];
//}

// if the authentication is successfully handled than you will get data in this method in which you can reload web view with same request again.

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    NSLog(@"received response via nsurlconnection");
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[LoginService startLogin]];
    
    [webView loadRequest:urlRequest];
}


//- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
//{
//    NSLog(@"received response via nsurlconnection");
//    
//    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[LoginService startLogin]];
//    
//    [webView loadRequest:urlRequest];
//}

- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection;
{
    return NO;
}



@end
