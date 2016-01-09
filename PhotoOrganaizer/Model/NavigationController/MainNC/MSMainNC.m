//
//  MSMainNC.m
//  PhotoOrganaizer
//
//  Created by Maks on 1/7/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import "MSMainNC.h"
#import "LoginService.h"
#import "MSMainVC.h"

@interface MSMainNC ()



@end

@implementation MSMainNC

- (void)viewDidLoad {
    [super viewDidLoad];
//    [LoginService startLogin];
    MSMainVC *mainVC = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MSMainVC class])];
    NSMutableArray *arrayVC = [NSMutableArray new];
    [arrayVC addObject:mainVC];
    
//    if ([AuthorizeManager userID] && [AuthorizeManager sessionHash]) {
//        MenuVC *menuVC = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MenuVC class])];
//        [arrayVC addObject:menuVC];
//    }
    [self setViewControllers:arrayVC animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
