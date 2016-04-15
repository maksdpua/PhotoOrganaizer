//
//  MSGalleryRollLoadCell.m
//  PhotoOrganaizer
//
//  Created by Maks on 4/4/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import "MSGalleryRollLoadCell.h"
#import "MSUploadInfo.h"
#import "MSBlurEffect.h"

@interface MSGalleryRollLoadCell()



@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@property (nonatomic, weak) IBOutlet UIProgressView *progressView;
@property (nonatomic, weak) IBOutlet UIVisualEffectView *blurView;

@end

@implementation MSGalleryRollLoadCell


- (void)awakeFromNib {
    [super awakeFromNib];
}



- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
}

- (void)setupWithModel:(MSUploadInfo *)model {
    self.imageView.image = [UIImage imageWithData:model.data];
    self.progressView.progress = 0.f;
}

- (void)updateProgress:(NSNotification *)notification {
    dispatch_sync(dispatch_get_main_queue(), ^{
        MSUploadInfo *info = notification.object;
        NSLog(@"%f", info.progress);
        [self.progressView setProgress: info.progress animated:YES];
    });
    
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.imageView.image = nil;
}



@end
