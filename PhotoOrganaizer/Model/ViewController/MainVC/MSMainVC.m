//
//  MSMainVC.m
//  PhotoOrganaizer
//
//  Created by Maks on 1/7/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import "MSMainVC.h"
#import "LoginService.h"
#import "MSMainVCWebView.h"

@interface MSMainVC ()<POPAnimationDelegate>

@property (nonatomic, weak) IBOutlet UIButton *loginButton;

@end

@implementation MSMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)loginAction :(id)sender {
    
    POPSpringAnimation *sprintAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    
    sprintAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(20, 20)];
    sprintAnimation.springBounciness = 10.f;
    [self.loginButton pop_addAnimation:sprintAnimation forKey:@"sendAnimation"];
    
    MSMainVCWebView *webViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MSMainVCWebView class])];
    [self.navigationController pushViewController:webViewController animated:YES];
}

@end
