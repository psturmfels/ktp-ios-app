//
//  KTPProfileBioView.m
//  KTP
//
//  Created by Kate Findlay on 2/17/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPProfileBioView.h"

@implementation KTPProfileBioView

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
    self.titleLabel = [UILabel labelWithText:@"Personal Bio:"];
    self.titleLabel.font = [UIFont systemFontOfSize:19];
    [self addSubview:self.titleLabel];
    
    self.textLabel = [UILabel new];
    self.textLabel.numberOfLines = 0;
    self.textLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.textLabel];
    
}

-(void)autoLayoutSubviews {
    
    // Set translatesAutoresizingMaskIntoConstraints property to NO for all autolayout views
    for (UIView *view in self.subviews) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    NSDictionary *views = @{
                            @"titleLabel"   :   self.titleLabel,
                            @"textLabel"    :   self.textLabel,
                            };
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.textLabel attribute:NSLayoutAttributeWidth multiplier:1.1 constant:0]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[titleLabel]" options:0 metrics:nil views:views]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.textLabel attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[titleLabel]-5-[textLabel]" options:0 metrics:nil views:views]];

}

@end
