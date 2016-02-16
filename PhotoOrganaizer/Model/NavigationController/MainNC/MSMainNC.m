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
#import "MSGalleryRollNavigation.h"

@interface MSMainNC ()



@end

@implementation MSMainNC {
    NSMutableArray *arrayVC;
    MSFolderViewer *folderViewer;
}

- (void)viewDidAppear:(BOOL)animated {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushViewFolder) name:kTokenWasAccepted object:nil];
    MSMainVC *mainVC = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MSMainVC class])];
    arrayVC = [NSMutableArray new];
    [arrayVC addObject:mainVC];
    folderViewer = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MSFolderViewer class])];
    if ([MSAuth token]) {
        [arrayVC addObject:folderViewer];
    }
    if ([MSAuth defaulFolderPath]) {
        MSGalleryRoll *galleryRoll = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MSGalleryRoll class])];
        [arrayVC addObject:galleryRoll];
    }
    [self setViewControllers:arrayVC animated:NO];
    [self presentViewController:self.navigationController animated:YES completion:^{
        
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    
}

- (void)pushViewFolder {
    [arrayVC addObject:folderViewer];
    [self setViewControllers:arrayVC animated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
