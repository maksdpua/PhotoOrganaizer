//
//  MSMainNC.m
//  PhotoOrganaizer
//
//  Created by Maks on 1/7/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import "MSMainNC.h"
#import "LoginService.h"

@interface MSMainNC ()

@end

@implementation MSMainNC

- (void)viewDidLoad {
    [super viewDidLoad];
    [LoginService startLogin];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
