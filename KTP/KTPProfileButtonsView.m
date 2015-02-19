//
//  KTPProfileButtonsView.m
//  KTP
//
//  Created by Kate Findlay on 2/17/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPProfileButtonsView.h"

#define kLinkButtonCornerRadius 5

@implementation KTPProfileButtonsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = NO;
        [self loadButtons];
        [self setupFrames];
    }
    return self;
}

-(void)loadButtons {
    self.phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.emailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.facebookButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.twitterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.linkedInButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.personalSiteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self setupButton:self.phoneButton];
    [self setupButton:self.emailButton];
    [self setupButton:self.facebookButton];
    [self setupButton:self.twitterButton];
    [self setupButton:self.linkedInButton];
    [self setupButton:self.personalSiteButton];
}

-(void)setupButton:(UIButton *)button {
    button.layer.cornerRadius = kLinkButtonCornerRadius;
    button.layer.masksToBounds = YES;
    button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    button.layer.borderWidth = 1;
    [self addSubview:button];
}

-(void)setupFrames {
    double size = self.frame.size.width/7;
    double fromTop = (self.frame.size.height - size)/2;
    double originSide = self.frame.size.width/49;
    double additButton = originSide + size;
    
    CGRect frame1 = CGRectMake(originSide, fromTop, size, size);
    self.phoneButton.frame = frame1;
    
    CGRect frame2 = CGRectMake(originSide + additButton, fromTop, size, size);
    self.emailButton.frame = frame2;
    
    CGRect frame3 = CGRectMake(originSide + 2*additButton, fromTop, size, size);
    self.facebookButton.frame = frame3;
    
    CGRect frame4 = CGRectMake(originSide + 3*additButton, fromTop, size, size);
    self.twitterButton.frame = frame4;
    
    CGRect frame5 = CGRectMake(originSide + 4*additButton, fromTop, size, size);
    self.linkedInButton.frame = frame5;
    
    CGRect frame6 = CGRectMake(originSide + 5*additButton, fromTop, size, size);
    self.personalSiteButton.frame = frame6;
}

@end
