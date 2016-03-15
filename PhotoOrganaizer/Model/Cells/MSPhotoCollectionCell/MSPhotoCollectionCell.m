//
//  MSPhotoCollectionCell.m
//  PhotoOrganaizer
//
//  Created by Maks on 3/14/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import "MSPhotoCollectionCell.h"

@interface MSPhotoCollectionCell()

@property (nonatomic, weak) IBOutlet UIImageView *photo;
@property (nonatomic, weak) IBOutlet UIImageView *checkmark;

@end

@implementation MSPhotoCollectionCell

- (void)awakeFromNib {
    
}

- (void)setupWithImage:(UIImage *)image {
    self.photo.image = image;
    self.checkmark.image = [UIImage smilePic];
    [self.checkmark setHidden:YES];
}

- (void)setCheckmarkHidden:(BOOL)isHidden {
    [self.checkmark setHidden:isHidden];
}



@end
