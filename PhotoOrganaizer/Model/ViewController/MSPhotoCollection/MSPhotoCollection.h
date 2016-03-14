//
//  MSPhotoCollection.h
//  PhotoOrganaizer
//
//  Created by Maks on 3/14/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import <UIKit/UIKit.h>

@import Photos;

@interface MSPhotoCollection : UICollectionViewController

@property (nonatomic, strong) PHFetchResult *assetsFetchResults;
@property (nonatomic, strong) PHAssetCollection *assetCollection;

@end
