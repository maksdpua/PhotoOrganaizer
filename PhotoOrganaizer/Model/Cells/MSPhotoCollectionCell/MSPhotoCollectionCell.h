//
//  MSPhotoCollectionCell.h
//  PhotoOrganaizer
//
//  Created by Maks on 3/14/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSPhotoCollectionCell : UICollectionViewCell

- (void)setupWithImage:(UIImage *)image;

- (void)setCheckmarkHidden:(BOOL)isHidden;

@end
