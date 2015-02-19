//
//  KTPProfilePersonalInfoView.m
//  KTP
//
//  Created by Kate Findlay on 2/17/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPProfilePersonalInfoView.h"

@implementation KTPProfilePersonalInfoView

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
    self.majorLabel = [UILabel new];
    self.majorLabel.font = [UIFont systemFontOfSize:15];
    self.gradLabel = [UILabel new];
    self.gradLabel.font = [UIFont systemFontOfSize:15];
    self.hometownLabel = [UILabel new];
    self.hometownLabel.font = [UIFont systemFontOfSize:15];
    
    [self addSubview:self.majorLabel];
    [self addSubview:self.gradLabel];
    [self addSubview:self.hometownLabel];
}

-(void)autoLayoutSubviews {
    
    // Set translatesAutoresizingMaskIntoConstraints property to NO for all autolayout views
    for (UIView *view in self.subviews) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    
    
    NSDictionary *views = @{
                            @"majorLabel"       :   self.majorLabel,
                            @"gradLabel"        :   self.gradLabel,
                            @"hometownLabel"    :   self.hometownLabel
                            };
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[majorLabel]" options:0 metrics:nil views:views]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.majorLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.gradLabel attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.majorLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.hometownLabel attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self addConstraint: [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.gradLabel attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[majorLabel]-[gradLabel]" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[gradLabel]-[hometownLabel]" options:0 metrics:nil views:views]];
    
}

@end
