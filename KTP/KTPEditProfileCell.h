//
//  KTPEditProfileCell.h
//  KTP
//
//  Created by Kate Findlay on 2/15/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTPTextView.h"

@interface KTPEditProfileCell : UITableViewCell

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) KTPTextView *textView;

@property (nonatomic) BOOL isTextField; // if YES, the textField will be visible, otherwise, the textView will be visible

@end
