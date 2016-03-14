//
//  MSAuth.m
//  PhotoOrganaizer
//
//  Created by Maks on 1/10/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import "MSAuth.h"
#import "AuthConstants.h"
#import "MSFolder.h"

@implementation MSAuth

+ (void)beginObservingForAuthData {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setToken:) name:kTokenWasAccepted object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setUID:) name:kUIDwasAccepted object:nil];
}

+ (NSString *)token {
    NSLog(@"TOKEN %@", [[NSUserDefaults standardUserDefaults] valueForKey:kToken]);
    return [[NSUserDefaults standardUserDefaults] valueForKey:kToken];
}

+ (NSString *)uid {
    return [[NSUserDefaults standardUserDefaults] valueForKey:kUID];
}

+ (void)setToken:(NSNotification *)notification {
    [[NSUserDefaults standardUserDefaults] setObject:notification.object forKey:kToken];
}

+ (void)setUID:(NSNotification *)notification {
    [[NSUserDefaults standardUserDefaults] setObject:notification.object forKey:kUID];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (NSString *)defaulFolderPath {
    return [[NSUserDefaults standardUserDefaults] valueForKey:kDefaultFolderPath];
}

+ (void)logout {
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kUID];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kToken];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"logout" object:nil];
}





@end
