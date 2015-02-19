//
//  KTPProfileButtonsView.m
//  KTP
//
//  Created by Kate Findlay on 2/17/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPProfileButtonsView.h"

#define kLinkButtonCornerRadius 5

@interface KTPProfileButtonsView ()

@property (nonatomic, strong) NSArray *buttons;

@end

@implementation KTPProfileButtonsView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = NO;
        [self loadButtons];
        [self autoLayoutSubviews];
    }
    return self;
}

- (void)loadButtons {
    self.phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.emailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.facebookButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.twitterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.linkedInButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.personalSiteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.buttons = @[self.phoneButton, self.emailButton, self.facebookButton, self.twitterButton, self.linkedInButton, self.personalSiteButton];
    for (UIButton *button in self.buttons) {
        [self setupButton:button];
    }
}

-(void)setupButton:(UIButton *)button {
    button.layer.cornerRadius = kLinkButtonCornerRadius;
    button.layer.masksToBounds = YES;
    button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    button.layer.borderWidth = 1;
    [self addSubview:button];
}

- (void)autoLayoutSubviews {
    for (UIView *view in self.subviews) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    NSDictionary *views = @{
                            @"phoneButton"      :   self.phoneButton,
                            @"emailButton"      :   self.emailButton,
                            @"facebookButton"   :   self.facebookButton,
                            @"twitterButton"    :   self.twitterButton,
                            @"linkedInButton"   :   self.linkedInButton,
                            @"personalButton"   :   self.personalSiteButton
                            };

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[phoneButton]-5-[emailButton]-5-[facebookButton]-5-[twitterButton]-5-[linkedInButton]-5-[personalButton]-0-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[phoneButton]-5-|" options:0 metrics:nil views:views]];
    
    for (UIButton *button in self.buttons) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    }
    for (int i = 1; i < self.buttons.count; ++i) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.buttons[i] attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.buttons[i-1] attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    }
}

@end
