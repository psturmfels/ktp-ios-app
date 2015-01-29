//
//  NSString+KTPStrings.h
//  KTP
//
//  Created by Owen Yang on 1/28/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (KTPStrings)

/*!
 Returns whether the string is empty (whitespace will cause this to return false)
 
 @returns       YES if the string is empty, NO otherwise
 */
- (BOOL)isEmpty;

/*!
 Returns whether the string is not nil or empty (after trimming whitespace and newlines).
 
 @returns       NO if the string is nil or empty, YES otherwise
 */
- (BOOL)isNotNilOrEmpty;

@end
