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
#import "MSAuth.h"
#import "MSDefaultFolderVC.h"
#import "AuthConstants.h"

@interface MSMainNC ()



@end

@implementation MSMainNC {
    NSMutableArray *arrayVC;
    MSDefaultFolderVC *defaultFolderVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushDefaultFolderVC) name:kTokenWasAccepted object:nil];
    MSMainVC *mainVC = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MSMainVC class])];
    arrayVC = [NSMutableArray new];
    defaultFolderVC = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MSDefaultFolderVC class])];
    [arrayVC addObject:mainVC];
    
    if ([MSAuth token] || [MSAuth uid]) {
        defaultFolderVC = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MSDefaultFolderVC class])];
        [arrayVC addObject:defaultFolderVC];
    }
    [self setViewControllers:arrayVC animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushDefaultFolderVC {
    [self pushViewController:defaultFolderVC animated:NO];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
