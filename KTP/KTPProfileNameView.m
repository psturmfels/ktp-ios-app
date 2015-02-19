//
//  KTPProfileNameView.m
//  KTP
//
//  Created by Kate Findlay on 2/17/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPProfileNameView.h"

#define PROFILE_IMAGE_RADIUS 10

@implementation KTPProfileNameView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor KTPDarkGray];
        self.layer.masksToBounds = YES;
        [self loadLabel];
        [self loadProfileImageView];
        [self setFrames];
        [self loadLine];
    }
    return self;
}

-(void)loadLabel {
    self.nameLabel = [UILabel new];
    self.nameLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:30];
    self.nameLabel.numberOfLines = 2;
    [self addSubview:self.nameLabel];
}

- (void)loadProfileImageView {
    self.profileImageView = [UIImageView new];
    self.profileImageView.layer.cornerRadius = PROFILE_IMAGE_RADIUS;
    self.profileImageView.backgroundColor = [UIColor whiteColor];
    self.profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.profileImageView.layer.borderWidth = 5;
    self.profileImageView.layer.masksToBounds = YES;
    self.profileImageView.userInteractionEnabled = YES;
    [self addSubview:self.profileImageView];
}

-(void)setFrames{
    CGFloat size = self.frame.size.width * 0.3;
    CGRect imageFrame = CGRectMake(20, 20, size, size);
    self.profileImageView.frame = imageFrame;
    
    CGRect labelFrame = CGRectMake(size+40, 20, self.frame.size.width - size+30, 60+10);
    self.nameLabel.frame = labelFrame;
}

-(void)loadLine {
    self.line = [CAShapeLayer new];
    self.line.fillColor = [UIColor whiteColor].CGColor;
    CGRect rect = CGRectMake(0, self.nameLabel.frame.size.height + self.nameLabel.frame.origin.y+10, self.frame.size.width, 5);
    self.line.path = [UIBezierPath bezierPathWithRect:rect].CGPath;
    [self.layer insertSublayer:self.line below:self.profileImageView.layer];
    
    self.colorBlock = [CAShapeLayer new];
    self.colorBlock.fillColor = [UIColor KTPGreenNew].CGColor;
    CGRect blockFrame = CGRectMake(0, 0, self.frame.size.width, self.nameLabel.frame.size.height+30);
    self.colorBlock.path = [UIBezierPath bezierPathWithRect:blockFrame].CGPath;
    [self.layer insertSublayer:self.colorBlock below:self.nameLabel.layer];
    
}

//
//-(void)autoLayoutSubviews {
//    
//    // Set translatesAutoresizingMaskIntoConstraints property to NO for all autolayout views
//    for (UIView *view in self.subviews) {
//        view.translatesAutoresizingMaskIntoConstraints = NO;
//    }
//    
//    NSDictionary *views = @{
//                            @"nameLabel"        :   self.nameLabel,
//                            @"profileImageView" :   self.profileImageView,
//                            };
//    
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.profileImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.profileImageView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.profileImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.3 constant:0]];
//    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[profileImageView]" options:0 metrics:nil views:views]];
//    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[profileImageView]" options:0 metrics:nil views:views]];
//    
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.profileImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.nameLabel attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
//    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[profileImageView]-20-[nameLabel]" options:0 metrics:nil views:views]];
//    
//    
//    
//    
//}

@end
