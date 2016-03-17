//
//  MSGalleryRoll.h
//  PhotoOrganaizer
//
//  Created by Maks on 2/11/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSPhotoLayout.h"

@interface MSGalleryRoll : UICollectionViewController

@end

#pragma mark - LayoutDelegate category

@interface MSGalleryRoll (LayoutDelegate) <MSPinterestLayoutAttributesDelegate>

@end


