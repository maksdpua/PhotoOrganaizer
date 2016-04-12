//
//  MSSavingProcessView.m
//  PhotoOrganaizer
//
//  Created by Maks on 4/12/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import "MSSavingProcessView.h"
#import "MSRequestManager.h"

@interface MSSavingProcessView()<MSRequestManagerDelegate>

@property (nonatomic, strong) MSRequestManager *requestManager;
@property (nonatomic, strong) IBOutlet UIVisualEffectView *blurView;
@property (nonatomic, strong) IBOutlet UIProgressView *progressView;
@end

@implementation MSSavingProcessView

- (instancetype)initOnView:(UIView *)view path:(NSString *)path {
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil]firstObject];
    if (self = [super init]) {
        self.frame = view.frame;
        self.requestManager = [[MSRequestManager alloc] initWithDelegate:self];
        self.blurView.effect = nil;
        self.alpha = 0;
        self.progressView.progress = 0.f;
        [view addSubview:self];
        [self showWithDuration:0.25 withAlpha:1];
        [self downloadPhoto: path];
    }
    return self;
}

- (void)showWithDuration:(CGFloat)duration withAlpha:(CGFloat)alpha {
    [UIView animateWithDuration:duration animations:^{
        self.blurView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        self.alpha = alpha;
    }];
}

- (void)removeView {
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
        self.blurView.effect = nil;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
    }];
}

- (void)downloadPhoto:(NSString *)path {
    [self.requestManager createRequestWithPOSTmethodWithAuthAndJSONbodyAtURL:urlPath(kContentURL, kDownload) dictionaryParametrsToJSON:@{@"path" : path} classForFill:nil upload:^(NSProgress *uploadProgress) {
        
    } download:^(NSProgress *downloadProgress) {
        NSLog(@"Progress %f", downloadProgress.fractionCompleted);
        dispatch_sync(dispatch_get_main_queue(), ^{

            [self.progressView setProgress: downloadProgress.fractionCompleted animated:YES];
        });
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"success %@", responseObject);
        [self removeFromSuperview];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error %@", error);
        
        [self removeFromSuperview];
    }];
}

@end
