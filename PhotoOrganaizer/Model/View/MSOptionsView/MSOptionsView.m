//
//  MSOptionsView.m
//  PhotoOrganaizer
//
//  Created by Maks on 2/16/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import "MSOptionsView.h"
IB_DESIGNABLE

@interface MSOptionsView()

@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable CGFloat radius;
@property (nonatomic) IBInspectable CGSize shOffset;
@property (nonatomic) IBInspectable CGColorRef shColor;
@property (nonatomic) IBInspectable CGFloat shRadius;
@property (nonatomic) IBInspectable float shOpacity;
@property (nonatomic) IBInspectable CGFloat corRadius;
@property (nonatomic) IBInspectable BOOL masks;
@property (nonatomic) IBInspectable UIImage *imageA;

@end



@implementation MSOptionsView

- (void)awakeFromNib {
    [self prepareForInterfaceBuilder];
}

- (void)prepareForInterfaceBuilder {
    

    
    self.layer.borderWidth = self.borderWidth;
    self.layer.borderColor = self.borderColor.CGColor;
    self.layer.cornerRadius = self.radius;
    self.layer.shadowOffset = self.shOffset;
    self.layer.shadowColor = self.shColor;
    self.layer.shadowRadius = self.shRadius;
    self.layer.shadowOpacity = self.shOpacity;
    self.layer.cornerRadius = self.corRadius;
    self.layer.masksToBounds = self.masks;
    
}


@end
