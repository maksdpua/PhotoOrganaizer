//
//  UINavigationController+CompletionHandler.m
//  PhotoOrganaizer
//
//  Created by Maks on 2/15/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import "UINavigationController+CompletionHandler.h"

@implementation UINavigationController (CompletionHandler)

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion {
    [CATransaction begin];
    [CATransaction setCompletionBlock:completion];
    [self pushViewController:viewController animated:animated];
    [CATransaction commit];
}

@end
