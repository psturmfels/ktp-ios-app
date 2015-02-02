//
//  KTPTextView.h
//  KTP
//
//  Created by Owen Yang on 1/31/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 @class         KTPTextView
 @description   A KTPTextView is a subclass of UITextView and adds the ability to use a placeholder in the textview (similar to a UITextField placeholder)
 */
@interface KTPTextView : UITextView

@property (nonatomic, strong) NSString *placeholder;

- (instancetype)initWithPlaceholder:(NSString*)placeholder;

@end
