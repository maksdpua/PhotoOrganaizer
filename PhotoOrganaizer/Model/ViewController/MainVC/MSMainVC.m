//
//  MSMainVC.m
//  PhotoOrganaizer
//
//  Created by Maks on 1/7/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import "MSMainVC.h"
#import "LoginService.h"
#import "MSAuth.h"
#import "MSDefaultFolderVC.h"

@interface MSMainVC ()<POPAnimationDelegate>

@property (nonatomic, weak) IBOutlet UIButton *loginButton;
@property (nonatomic, weak) NSTimer *timer;

@end

@implementation MSMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loginButton];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0f
                                                    target:self
                                                  selector:@selector(loginButtonAnimation)
                                                  userInfo:nil
                                                   repeats:YES];
   
}

- (IBAction)loginAction :(id)sender {
    if ([self.timer isValid]) {
        [self.timer invalidate];
    }
    [self changeButtonBeforeLogin];
    [self performSelector:@selector(login) withObject:nil afterDelay:1.0f];
//    MSMainVCWebView *webViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MSMainVCWebView class])];
//    [self.navigationController pushViewController:webViewController animated:YES];
}

- (void)loginButtonAnimation {
    POPSpringAnimation *sprintAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    
    sprintAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(20, 20)];
    sprintAnimation.springBounciness = 10.f;
    [self.loginButton pop_addAnimation:sprintAnimation forKey:@"sendAnimation"];
}

- (void)changeButtonBeforeLogin {
    POPSpringAnimation *sprintAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    
    sprintAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(50, 50)];
    sprintAnimation.springBounciness = 15.f;
    [self.loginButton pop_addAnimation:sprintAnimation forKey:@"changeButton"];
}

- (void)login {
    [LoginService startLogin];

}

@end
