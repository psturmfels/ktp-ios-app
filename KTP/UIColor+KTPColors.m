//
//  UIColor+KTPColors.m
//  KTP
//
//  Created by Greg Azevedo on 2/17/14.
//  Copyright (c) 2014 Kappa Theta Pi. All rights reserved.
//

#import "UIColor+KTPColors.h"

@implementation UIColor (KTPColors)

+ (UIColor*)colorWithHex:(NSInteger)hex alpha:(CGFloat)alpha {
    CGFloat red     = ((hex >> 16) & 0xFF) / 255.0;
    CGFloat green   = ((hex >>  8) & 0xFF) / 255.0;
    CGFloat blue    = ((hex      ) & 0xFF) / 255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (UIColor *)KTPGreen363 {
    return [UIColor colorWithRed:0.3 green:0.6 blue:0.3 alpha:1];
}

+ (UIColor *)KTPGreen1F1 {
    return [UIColor colorWithRed:0.1 green:1.0 blue:0.1 alpha:1.0];
}

+ (UIColor *)KTPGreen9F9 {
    return [UIColor colorWithRed:0.7 green:1.0 blue:0.7 alpha:1.0];
}

+ (UIColor *)KTPBlue25F {
    return [UIColor colorWithRed:0.2 green:0.5 blue:1.0 alpha:1.0];
}

+ (UIColor *)KTPOpenGreen {
    return [UIColor colorWithRed:0.5 green:0.8 blue:0.6 alpha:1.0];
}

+ (UIColor *)KTPGreenNew {
    return [UIColor colorWithRed:0.4 green:0.7 blue:0.5 alpha:1.0];
}

+ (UIColor *)KTPBlue136 {
    return [UIColor colorWithRed:0.1 green:0.3 blue:0.6 alpha:1.0];
}

+ (UIColor *)KTPDarkGray {
    return [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
}

+ (UIColor *)KTPLightGray {
    return [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
}

+ (UIColor*)KTPNavigationBarTintColor {
    return [UIColor blackColor];
}

@end
