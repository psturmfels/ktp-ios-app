//
//  UIColor+KTPColors.h
//  KTP
//
//  Created by Greg Azevedo on 2/17/14.
//  Copyright (c) 2014 Kappa Theta Pi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (KTPColors)

+ (UIColor*)colorWithHex:(NSInteger)hex alpha:(CGFloat)alpha;

+(UIColor *)KTPGreen363;
+(UIColor *)KTPGreen1F1;
+(UIColor *)KTPGreen9F9;
+(UIColor *)KTPBlue25F;
+(UIColor *)KTPBlue136;
+(UIColor *)KTPDarkGray;
+(UIColor *)KTPOpenGreen;
+(UIColor *)KTPLightGray;

+(UIColor *)KTPGreenNew;

+ (UIColor*)KTPNavigationBarTintColor;

@end
