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

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.masksToBounds = NO;
        [self loadLayers];
        [self loadLabels];
        [self autoLayoutSubviews];
    }
    return self;
}


-(void)loadLayers {
    
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
    
    [self.layer addSublayer:self.border];
    [self.layer addSublayer:self.baseLayer];
}

-(void)loadLabels {
    self.statusLabel = [UILabel new];
    self.statusLabel.font = [UIFont systemFontOfSize:15];
    self.roleLabel = [UILabel new];
    self.roleLabel.font = [UIFont systemFontOfSize:15];
    self.pledgeClassLabel = [UILabel new];
    self.pledgeClassLabel.font = [UIFont systemFontOfSize:15];
    
    [self addSubview:self.statusLabel];
    [self addSubview:self.roleLabel];
    [self addSubview:self.pledgeClassLabel];
}


-(void)autoLayoutSubviews {
    
    // Set translatesAutoresizingMaskIntoConstraints property to NO for all autolayout views
    for (UIView *view in self.subviews) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    
    
    NSDictionary *views = @{
                            @"statusLabel"          :   self.statusLabel,
                            @"roleLabel"            :   self.roleLabel,
                            @"pledgeClassLabel"     :   self.pledgeClassLabel
                            };
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[statusLabel]" options:0 metrics:nil views:views]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.statusLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.roleLabel attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.statusLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.pledgeClassLabel attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self addConstraint: [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.roleLabel attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[statusLabel]-[roleLabel]" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[roleLabel]-[pledgeClassLabel]" options:0 metrics:nil views:views]];
    
}

@end
