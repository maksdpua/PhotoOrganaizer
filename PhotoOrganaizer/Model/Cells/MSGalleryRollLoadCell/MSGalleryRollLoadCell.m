//
//  MSGalleryRollLoadCell.m
//  PhotoOrganaizer
//
//  Created by Maks on 4/4/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import "MSGalleryRollLoadCell.h"
#import "UCZProgressView.h"

@interface MSGalleryRollLoadCell()



@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@property (nonatomic, weak) IBOutlet UCZProgressView *progressView;

@end

@implementation MSGalleryRollLoadCell


- (void)awakeFromNib {
//    self.progressView = [[UCZProgressView alloc] initWithFrame:self.imageView.frame];
//    self.progressView.translatesAutoresizingMaskIntoConstraints = NO;
//    self.progressView.backgroundColor = [UIColor clearColor];
    self.progressView.showsText = YES;
    self.progressView.indeterminate = NO;
    self.progressView.tintColor = [UIColor blueColor];
    self.progressView.textColor = [UIColor redColor];

//    self.progressView.tintColor = [UIColor redColor];
//    self.progressView.radius = 5.0;
//    self.progressView.blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
//    [self.imageView addSubview:self.progressView];
    
    
//    NSDictionary *views = NSDictionaryOfVariableBindings(_progressView);
//    [self.imageView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_progressView]-0-|" options:0 metrics:nil views:views]];
//    [self.imageView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_progressView]-0-|" options:0 metrics:nil views:views]];
    
}

- (void)setupWithModel:(MSUploadInfo *)model {
    self.imageView.image = [UIImage imageWithData:model.data];
}

- (void)updateProgress:(NSNotification *)notification {
    NSNumber *progress = notification.object;
    [self.progressView setProgress:progress.floatValue animated:YES];
}



@end
