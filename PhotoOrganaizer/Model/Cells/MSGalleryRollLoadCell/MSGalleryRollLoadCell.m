//
//  MSGalleryRollLoadCell.m
//  PhotoOrganaizer
//
//  Created by Maks on 4/4/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import "MSGalleryRollLoadCell.h"

@interface MSGalleryRollLoadCell()

@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@property (nonatomic, weak) IBOutlet UIProgressView *progress;

@end

@implementation MSGalleryRollLoadCell

- (void)setupWithModel:(MSUploadInfo *)model {
    self.progress.progress = 0.f;
    if (model.progress) {
        self.progress.progress = model.progress;
    }
    self.imageView.image = [UIImage imageWithData:model.data];
}

@end
