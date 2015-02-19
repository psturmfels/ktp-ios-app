//
//  KTPProfilePersonalInfoView.m
//  KTP
//
//  Created by Kate Findlay on 2/17/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPProfilePersonalInfoView.h"

@implementation KTPProfilePersonalInfoView

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

-(void)loadLabels {
    self.majorLabel = [UILabel new];
    self.gradLabel = [UILabel new];
    self.hometownLabel = [UILabel new];
    self.majorLabel.font = self.gradLabel.font = self.hometownLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-SemiBold" size:[UIFont systemFontSize]];
    self.majorLabel.textColor = self.gradLabel.textColor = self.hometownLabel.textColor = [UIColor KTPDarkGray];
    self.majorLabel.numberOfLines = 0;
    
    [self addSubview:self.majorLabel];
    [self addSubview:self.gradLabel];
    [self addSubview:self.hometownLabel];
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
    
    [self.layer insertSublayer:self.baseLayer below:self.majorLabel.layer];
    [self.layer insertSublayer:self.border below:self.baseLayer];
}

-(void)autoLayoutSubviews {
    
    for (UIView *view in self.subviews) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    NSDictionary *views = @{
                            @"majorLabel"       :   self.majorLabel,
                            @"gradLabel"        :   self.gradLabel,
                            @"hometownLabel"    :   self.hometownLabel
                            };
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[majorLabel]-20-|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[majorLabel]-[gradLabel]-[hometownLabel]-10-|" options:NSLayoutFormatAlignAllLeft metrics:nil views:views]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.majorLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.gradLabel attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.gradLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.hometownLabel attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
}

@end
