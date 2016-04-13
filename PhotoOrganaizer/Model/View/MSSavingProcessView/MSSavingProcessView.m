//
//  MSSavingProcessView.m
//  PhotoOrganaizer
//
//  Created by Maks on 4/12/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import "MSSavingProcessView.h"
#import "MSRequestManager.h"
@import Photos;

@interface MSSavingProcessView()<MSRequestManagerDelegate>

@property (nonatomic, strong) MSRequestManager *requestManager;
//@property (nonatomic, strong) IBOutlet UIVisualEffectView *blurView;
@property (nonatomic, strong) IBOutlet UIProgressView *progressView;
@property (nonatomic, strong) IBOutlet UILabel *status;
@end

@implementation MSSavingProcessView

- (instancetype)initOnView:(UIView *)view path:(NSString *)path {
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil]firstObject];
    if (self) {
        self.status.text = @"Saving...";
        self.frame = view.frame;
//        self.blurView.frame = view.frame;
        self.requestManager = [[MSRequestManager alloc] initWithDelegate:self];
        self.effect = nil;
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
        self.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        self.alpha = alpha;
    }];
}

- (void)removeView {
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
        self.effect = nil;
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
        [self.progressView setProgress:1];
        [self.progressView setHidden:YES];
        self.status.text = @"Sucess!";

        [UIView animateWithDuration:1 animations:^{
            self.status.alpha = 0;
        } completion:^(BOOL finished) {
            
            NSData *data = responseObject;
            
            [self savingPhotoToCameraRoll:[UIImage imageWithData:data]];
            [UIView animateWithDuration:0.5 animations:^{
                self.alpha = 0;
            } completion:^(BOOL success) {
                if (success) {
                    [self removeView];
                }
            }];
        }];
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error %@", error);
        
        [self removeFromSuperview];
    }];
}

- (void)savingPhotoToCameraRoll:(UIImage *)image {
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges: ^{
        
        PHAssetChangeRequest *changeRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        changeRequest.creationDate          = [NSDate date];
    }
                                      completionHandler:^(BOOL success, NSError *error) {
                                          if (success) {
                                              NSLog(@"successfully saved");
                                          }
                                          else {
                                              NSLog(@"error saving to photos: %@", error);
                                          }
                                      }];
}

@end
