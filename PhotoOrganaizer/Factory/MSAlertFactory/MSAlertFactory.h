//
//  MSAlertFactory.h
//  PhotoOrganaizer
//
//  Created by Maks on 4/15/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSAlertFactory : NSObject

- (void)createAlertWithTitle:(NSString *)title message:(NSString *)text animated:(BOOL)animation;

@end
