//
//  KTPTextView.m
//  KTP
//
//  Created by Owen Yang on 1/31/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPTextView.h"

@interface KTPTextView ()

@property (nonatomic, strong) UILabel *placeholderLabel;

@end

@implementation KTPTextView

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
        
        UIEdgeInsets textEdgeInsets = self.textContainerInset;
        textEdgeInsets.left = -5;   // removes the space between the left edge of the view and the beginning of the text
        self.textContainerInset = textEdgeInsets;
    }
    return self;
}

- (instancetype)initWithPlaceholder:(NSString*)placeholder {
    self = [self init];
    if (self) {
        self.placeholder = placeholder;
    }
    return self;
}

- (void)setPlaceholder:(NSString *)placeholder {
    if (_placeholder != placeholder) {
        _placeholder = placeholder;
        if (!self.placeholderLabel) {
            [self loadPlaceholderLabel];
        }
    }
}

- (void)loadPlaceholderLabel {
    self.placeholderLabel = [UILabel new];
    self.placeholderLabel.text = self.placeholder;
    self.placeholderLabel.textColor = [UIColor colorWithWhite:0.8 alpha:1];
    self.placeholderLabel.numberOfLines = 0;
    self.placeholderLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:self.placeholderLabel];
    
    [self autoLayoutPlaceholderLabel];
}

- (void)autoLayoutPlaceholderLabel {
    self.placeholderLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.placeholderLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.placeholderLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.placeholderLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:self.textContainerInset.top]];
}

#pragma mark - Notification Handling

/*!
 Called after the textview's text has changed.
 */
- (void)textDidChange {
    self.placeholderLabel.hidden = ![self.text isEmpty];
    NSLog(@"%f", self.contentSize.height);
}

@end