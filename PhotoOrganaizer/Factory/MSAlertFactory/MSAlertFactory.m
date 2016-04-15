//
//  MSAlertFactory.m
//  PhotoOrganaizer
//
//  Created by Maks on 4/15/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import "MSAlertFactory.h"

@interface MSAlertFactory ()

@end

@implementation MSAlertFactory {
    UIAlertController *_alertController;
}

- (void)createAlertWithTitle:(NSString *)title message:(NSString *)text animated:(BOOL)animation {
    
    _alertController = [UIAlertController alertControllerWithTitle:title message:text preferredStyle:UIAlertControllerStyleAlert];
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:_alertController animated:animation completion:^{
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(dismissAlert) userInfo:nil repeats:NO];
    }];
}

- (void)dismissAlert {
    [_alertController dismissViewControllerAnimated:NO completion:nil];
}

@end
