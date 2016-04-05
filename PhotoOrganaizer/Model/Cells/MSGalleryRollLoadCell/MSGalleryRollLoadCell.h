//
//  MSGalleryRollLoadCell.h
//  PhotoOrganaizer
//
//  Created by Maks on 4/4/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSUploadInfo.h"


@interface MSGalleryRollLoadCell : UICollectionViewCell

- (void)setupWithModel:(MSUploadInfo *)model;

- (void)updateProgress:(NSNotification *)notidication;

@end
