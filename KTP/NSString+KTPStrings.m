//
//  NSString+KTPStrings.m
//  KTP
//
//  Created by Owen Yang on 1/28/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "NSString+KTPStrings.h"

@implementation NSString (KTPStrings)

- (BOOL)isEmpty {
    return ([self length] == 0);
}

- (BOOL)isNotNilOrEmpty {
    return [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length];
}

@end
