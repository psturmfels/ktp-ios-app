//
//  UIImage+KTPImages.m
//  KTP
//
//  Created by Owen Yang on 1/27/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "UIImage+KTPImages.h"

@implementation UIImage (KTPImages)

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
