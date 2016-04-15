//
//  MSReachabilityManager.m
//  PhotoOrganaizer
//
//  Created by Maks on 4/15/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import "MSReachabilityManager.h"
#import <AFNetworking/AFNetworking.h>
#import "MSAlertFactory.h"

//static NSNumber *const kAnimationDeur = ;

@implementation MSReachabilityManager

+ (instancetype)sharedManager {
    static MSReachabilityManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[MSReachabilityManager alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
            if (status == AFNetworkReachabilityStatusNotReachable) {
                [[MSAlertFactory new]createAlertWithTitle:@"Warning" message:@"Internet connection problem.." animated:YES];
            }
        }];
        
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    }
    return self;
}



@end
