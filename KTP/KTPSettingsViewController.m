//
//  KTPSettingsViewController.m
//  KTP
//
//  Created by Owen Yang on 1/27/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPSettingsViewController.h"
#import "KTPSUser.h"

@interface KTPSettingsViewController ()

//@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIButton *logoutButton;
@end

@implementation KTPSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
//    self.scrollView.alwaysBounceVertical = YES;
//    [self.view addSubview:self.scrollView];
    
    self.navigationItem.title = @"Settings";
    
    [self loadSubviews];
    [self autoLayoutSubviews];
}

- (void)loadSubviews {
    [self loadLogoutButton];
}

- (void)loadLogoutButton {
    self.logoutButton = [[UIButton alloc] init];
    [self.logoutButton setTitle:@"Logout" forState:UIControlStateNormal];
    [self.logoutButton addTarget:[KTPSUser currentUser] action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    
    UIColor *normalColor = [UIColor colorWithRed:0xff/255.0 green:0x69/255.0 blue:0x69/255.0 alpha:1];
    [self.logoutButton setBackgroundImage:[UIImage imageWithColor:normalColor] forState:UIControlStateNormal];
    [self.logoutButton setBackgroundImage:[UIImage imageWithColor:[normalColor colorWithAlphaComponent:0.5]] forState:UIControlStateHighlighted];
    self.logoutButton.titleLabel.textColor = [UIColor whiteColor];
    
    [self.view addSubview:self.logoutButton];
}

- (void)autoLayoutSubviews {
    self.logoutButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *views = @{
                            @"logoutButton"     :   self.logoutButton
                            };
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[logoutButton]-20-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[logoutButton(50)]-20-|" options:0 metrics:nil views:views]];
}

@end
