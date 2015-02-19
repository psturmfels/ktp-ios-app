//
//  KTPProfileBioView.m
//  KTP
//
//  Created by Kate Findlay on 2/17/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPProfileBioView.h"

@implementation KTPProfileBioView

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
    self.titleLabel = [UILabel labelWithText:@"Personal Bio"];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize] * 1.5];
    [self addSubview:self.titleLabel];
    
    self.textLabel = [UILabel new];
    self.textLabel.numberOfLines = 0;
    [self addSubview:self.textLabel];
    
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
    
    [self.layer insertSublayer:self.baseLayer below:self.titleLabel.layer];
    [self.layer insertSublayer:self.border below:self.baseLayer];
}

-(void)autoLayoutSubviews {
    
    for (UIView *view in self.subviews) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    NSDictionary *views = @{
                            @"titleLabel"   :   self.titleLabel,
                            @"textLabel"    :   self.textLabel,
                            };
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[titleLabel]-10-|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[textLabel]-10-|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[titleLabel]-5-[textLabel]-10-|" options:NSLayoutFormatAlignAllLeft metrics:nil views:views]];
}

@end
