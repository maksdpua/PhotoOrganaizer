//
//  LoginService.h
//  PhotoOrganaizer
//
//  Created by Maks on 1/8/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginService : NSObject

+ (void)loginWithURL:(NSURL*)url;

+ (NSURL *)startLogin;



@end
