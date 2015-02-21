//
//  KTPEditProfileCell.m
//  KTP
//
//  Created by Kate Findlay on 2/15/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPEditProfileCell.h"

@implementation KTPEditProfileCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.textField = [UITextField new];
        self.textView = [KTPTextView new];
        self.textView.frame = CGRectMake(0, 0, 1, 1);
        self.textView.font = [UIFont systemFontOfSize:[UIFont labelFontSize]];
        [self.contentView addSubview:self.textField];
        [self.contentView addSubview:self.textView];
        
        [self autoLayoutSubviews];
        
        self.isTextField = YES; // textfield by default
    }
    return self;
}

- (void)setIsTextField:(BOOL)isTextField {
    _isTextField = isTextField;
    
    self.textField.hidden = !isTextField;
    self.textField.userInteractionEnabled = isTextField;
    self.textView.hidden = isTextField;
    self.textView.userInteractionEnabled = !isTextField;
}

- (void)autoLayoutSubviews {
    self.textField.translatesAutoresizingMaskIntoConstraints = NO;
    self.textView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *views = @{
                            @"textField"    :   self.textField,
                            @"textView"     :   self.textView
                            };
    
    NSDictionary *metrics = @{
                              @"separatorInsetLeft" :   [NSNumber numberWithFloat:self.separatorInset.left]
                              };
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-separatorInsetLeft-[textField]-0-|" options:0 metrics:metrics views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[textField]-0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-separatorInsetLeft-[textView]-0-|" options:0 metrics:metrics views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[textView]-0-|" options:0 metrics:nil views:views]];
}

@end
