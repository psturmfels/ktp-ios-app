//
//  UIImage+KTPImages.h
//  KTP
//
//  Created by Owen Yang on 1/27/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (KTPImages)

/*!
 Creates a 1pt x 1pt image filled with the given color
 
 @param         color   The fill color
 @returns       An image filled with color
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

@end
