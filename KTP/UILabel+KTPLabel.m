//
//  UILabel+KTPLabel.m
//  KTP
//
//  Created by Owen Yang on 1/31/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "UILabel+KTPLabel.h"

@implementation UILabel (KTPLabel)

+ (UILabel*)labelWithText:(NSString*)text {
    UILabel *label = [UILabel new];
    label.text = text;
    return label;
}

@end
