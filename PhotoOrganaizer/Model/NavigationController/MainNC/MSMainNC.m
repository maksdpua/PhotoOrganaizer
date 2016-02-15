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
#import "MSFolderViewer.h"
#import "AuthConstants.h"
#import "MSGalleryRoll.h"

@interface MSMainNC ()



@end

@implementation MSMainNC {
    NSMutableArray *arrayVC;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    MSMainVC *mainVC = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MSMainVC class])];
    arrayVC = [NSMutableArray new];
    [arrayVC addObject:mainVC];
    
    if ([MSAuth token]) {
        MSFolderViewer *folderViewer = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MSFolderViewer class])];
        [arrayVC addObject:folderViewer];
    }
    if ([MSAuth defaulFolderPath]) {
        MSGalleryRoll *galleryRoll = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MSGalleryRoll class])];
        [arrayVC addObject:galleryRoll];
    }
    [self setViewControllers:arrayVC animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
