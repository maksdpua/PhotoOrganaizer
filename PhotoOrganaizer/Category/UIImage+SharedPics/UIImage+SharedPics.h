//
//  UIImage+SharedPics.h
//  PhotoOrganaizer
//
//  Created by Maks on 1/20/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SharedPics)

+ (UIImage *)folderPic;

+ (UIImage *)smilePic;

+ (UIImage *)imageWithImage:(UIImage *)image scaledToWidth:(float) i_width;
@end
