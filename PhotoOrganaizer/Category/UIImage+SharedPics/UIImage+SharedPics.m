//
//  UIImage+SharedPics.m
//  PhotoOrganaizer
//
//  Created by Maks on 1/20/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import "UIImage+SharedPics.h"

@implementation UIImage (SharedPics)

+ (UIImage *)folderPic {
    return [UIImage imageNamed:@"folder-generic"];
}
+ (UIImage *)smilePic {
    return [UIImage imageNamed:@"glossy_emoticon_button"];
}

+ (UIImage *)imageWithImage:(UIImage *)sourceImage scaledToWidth:(float) i_width {
    
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
