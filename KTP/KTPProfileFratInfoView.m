//
//  KTPProfileFratInfoView.m
//  KTP
//
//  Created by Kate Findlay on 2/17/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPProfileFratInfoView.h"
#define PROFILE_IMAGE_RADIUS 10

@implementation KTPProfileFratInfoView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.masksToBounds = NO;
        [self loadLabels];
        [self autoLayoutSubviews];
    }
    return self;
}

- (void)loadLabels {
    self.statusLabel = [UILabel new];
    self.roleLabel = [UILabel new];
    self.pledgeClassLabel = [UILabel new];
    self.statusLabel.font = self.roleLabel.font = self.pledgeClassLabel.font = [UIFont systemFontOfSize:15];
    
    [self addSubview:self.statusLabel];
    [self addSubview:self.roleLabel];
    [self addSubview:self.pledgeClassLabel];
}

- (void)layoutSubviews {
    self.baseLayer = [CALayer new];
    self.baseLayer.frame = self.bounds;
    self.baseLayer.backgroundColor = [UIColor whiteColor].CGColor;
    self.baseLayer.borderColor = [UIColor KTPDarkGray].CGColor;
    self.baseLayer.borderWidth = 0.5;
    self.baseLayer.cornerRadius = 10;
    self.baseLayer.masksToBounds = YES;
    
    self.border = [CALayer new];
    self.border.frame = CGRectOffset(self.bounds, 0, 3);
    self.border.backgroundColor = [UIColor KTPGreenNew].CGColor;
    self.border.cornerRadius = 10;
    self.border.masksToBounds = YES;
    
    [self.layer insertSublayer:self.baseLayer below:self.statusLabel.layer];
    [self.layer insertSublayer:self.border below:self.baseLayer];
}

- (void)autoLayoutSubviews {
    
    for (UIView *view in self.subviews) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    NSDictionary *views = @{
                            @"statusLabel"          :   self.statusLabel,
                            @"roleLabel"            :   self.roleLabel,
                            @"pledgeClassLabel"     :   self.pledgeClassLabel
                            };
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[statusLabel]-20-|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[statusLabel]-[roleLabel]-[pledgeClassLabel]-10-|" options:NSLayoutFormatAlignAllLeft metrics:nil views:views]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.statusLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.roleLabel attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.roleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.pledgeClassLabel attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
}

@end
