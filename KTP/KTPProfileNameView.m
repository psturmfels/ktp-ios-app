//
//  KTPProfileNameView.m
//  KTP
//
//  Created by Kate Findlay on 2/17/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPProfileNameView.h"

#import "FLAnimatedImage.h"

#define PROFILE_IMAGE_RADIUS 10

@implementation KTPProfileNameView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor KTPDarkGray];
        self.layer.masksToBounds = YES;
        [self loadLabel];
        [self loadProfileImageView];
        [self autoLayoutSubviews];
    }
    return self;
}

- (void)loadLabel {
    self.nameLabel = [UILabel new];
    self.nameLabel.font = [UIFont fontWithName:@"Avenir-Heavy" size:[UIFont systemFontSize] * 2];
    self.nameLabel.textColor = [UIColor KTPDarkGray];
    self.nameLabel.layer.shadowColor = [UIColor whiteColor].CGColor;
    self.nameLabel.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.nameLabel.layer.shadowOpacity = 1.0f;
    self.nameLabel.layer.shadowRadius = 1.0f;
    self.nameLabel.numberOfLines = 2;
    [self addSubview:self.nameLabel];
}

- (void)loadProfileImageView {
    self.profileImageView = [FLAnimatedImageView new];
    self.profileImageView.layer.cornerRadius = PROFILE_IMAGE_RADIUS;
    self.profileImageView.backgroundColor = [UIColor whiteColor];
    self.profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.profileImageView.layer.borderWidth = 5;
    self.profileImageView.layer.masksToBounds = YES;
    self.profileImageView.userInteractionEnabled = YES;
    [self addSubview:self.profileImageView];
}

- (void)layoutSubviews {
    
    self.baseLayer = [CALayer new];
    CGRect frame = self.bounds;
    frame.size.height = self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height + 10;
    self.baseLayer.frame = frame;
    self.baseLayer.backgroundColor = [UIColor KTPGreenNew].CGColor;
    [self.layer insertSublayer:self.baseLayer below:self.nameLabel.layer];
    
    self.border = [CALayer new];
    self.border.frame = CGRectOffset(self.baseLayer.bounds, 0, 5);
    self.border.backgroundColor = [UIColor whiteColor].CGColor;
    [self.layer insertSublayer:self.border below:self.baseLayer];
}


- (void)autoLayoutSubviews {
    
    for (UIView *view in self.subviews) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    NSDictionary *views = @{
                            @"nameLabel"        :   self.nameLabel,
                            @"profileImageView" :   self.profileImageView,
                            };
    
    /* profileImageView */
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[profileImageView]" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[profileImageView]" options:0 metrics:nil views:views]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.profileImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.3 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.profileImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.profileImageView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    
    /* nameLabel */
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[profileImageView]-20-[nameLabel]-20-|" options:NSLayoutFormatAlignAllTop metrics:nil views:views]];
}

@end
