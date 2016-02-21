//
//  MSFolderViewNavigation.m
//  PhotoOrganaizer
//
//  Created by Maks on 2/17/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import "MSFolderViewNavigation.h"
#import "MSGalleryRoll.h"
#import "MSGalleryRollNavigation.h"

@interface MSFolderViewNavigation ()
@property (nonatomic ,strong) UIGestureRecognizer *pan;

@end

@implementation MSFolderViewNavigation

- (void)viewDidLoad {
    [super viewDidLoad];
    UISwipeGestureRecognizer *gestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeLeft)];
    gestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:gestureRecognizer];
    self.pan = [[UIGestureRecognizer alloc]init];
}

- (void)didSwipeLeft {
    MSGalleryRollNavigation *galleryRollNavigation = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MSGalleryRollNavigation class])];
    
    galleryRollNavigation.view.frame = CGRectMake (self.view.frame.size.width, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"swipeDidBegin" object:nil];
    
    [UIView animateWithDuration:0.7 animations:^{
        [self.view addSubview:galleryRollNavigation.view];
        self.view.frame = CGRectMake (self.view.frame.origin.x - self.view.frame.size.width, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
        NSLog(@"SWIPE %@", NSStringFromCGPoint([self.pan locationInView:self.view]));
            } completion:^(BOOL finished) {
        [galleryRollNavigation.view removeFromSuperview];
        [self presentViewController:galleryRollNavigation animated:NO completion:^{
            
        }];
    }];

    
}



@end
