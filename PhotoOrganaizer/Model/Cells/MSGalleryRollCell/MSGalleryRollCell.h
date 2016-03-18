//
//  MSGalleryRollCell.h
//  PhotoOrganaizer
//
//  Created by Maks on 2/12/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSPhoto.h"

@interface MSGalleryRollCell : UICollectionViewCell

- (void)setupWithImage:(UIImage *)image;

- (void)resizeCellView;

@end
