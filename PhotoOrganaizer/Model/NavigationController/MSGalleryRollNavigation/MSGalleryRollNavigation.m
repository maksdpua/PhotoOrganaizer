//
//  MSGalleryRollNavigation.m
//  PhotoOrganaizer
//
//  Created by Maks on 2/15/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import "MSGalleryRollNavigation.h"
#import "MSFolderViewNavigation.h"

@interface MSGalleryRollNavigation()

@property (nonatomic ,strong) UIGestureRecognizer *pan;

@end


@implementation MSGalleryRollNavigation

- (void)viewDidLoad {
    [super viewDidLoad];
    UISwipeGestureRecognizer *gestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeRight)];
    gestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:gestureRecognizer];
    self.pan = [[UIGestureRecognizer alloc]init];
}

- (void)didSwipeRight {
    NSLog(@"SWIPE %@", NSStringFromCGPoint([self.pan locationInView:self.view]));

    MSFolderViewNavigation *folderViewNavigation = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MSFolderViewNavigation class])];
    
    folderViewNavigation.view.frame = CGRectMake (folderViewNavigation.view.frame.origin.x - self.view.frame.size.width, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"swipeDidBegin" object:nil];
    
    [UIView animateWithDuration:0.7 animations:^{
        [self.view addSubview:folderViewNavigation.view];
        self.view.frame = CGRectMake (self.view.frame.origin.x + self.view.frame.size.width, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
        NSLog(@"SWIPE %@", NSStringFromCGPoint([self.pan locationInView:self.view]));
    } completion:^(BOOL finished) {
        
        [self dismissViewControllerAnimated:NO completion:^{
            [folderViewNavigation.view removeFromSuperview];
        }];
    }];
    
    
}








@end
