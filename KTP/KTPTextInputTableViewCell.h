//
//  KTPTextInputTableViewCell.h
//  KTP
//
//  Created by Owen Yang on 2/25/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KTPInputType) {
    KTPInputTypeString,     // input is NSString
    KTPInputTypeInteger,    // input is an integer number
    KTPInputTypeDecimal,    // input is a decimal number
    KTPInputTypeSelect      // input is a selectable option
};

/*!
 The KTPTextInputTableViewCell is a subclass of a UITableViewCell that provides a UITextField or KTPTextView for user input.
 */
@interface KTPTextInputTableViewCell : UITableViewCell

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic) BOOL isTextField; // default is true

@property (nonatomic) KTPInputType inputType; // default is KTPInputTypeString

- (instancetype)initWithText:(NSString*)text placeholder:(NSString*)placeholder isTextField:(BOOL)isTextField;

@end