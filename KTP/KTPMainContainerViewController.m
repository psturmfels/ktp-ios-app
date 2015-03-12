//
//  KTPMainContainerViewController.m
//  KTP
//
//  Created by Owen Yang on 3/12/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPMainContainerViewController.h"

@interface KTPMainContainerViewController ()
@end

@implementation KTPMainContainerViewController

#pragma mark - Overridden setters/getters

- (void)setMainVC:(UIViewController *)mainVC {
    if (_mainVC != mainVC) {
        [_mainVC removeFromParentViewController];
        
        _mainVC = mainVC;
        
        [self addChildViewController:self.mainVC];
        [self.mainVC didMoveToParentViewController:self];
        
        self.mainIsNavigationController = [mainVC isKindOfClass:[UINavigationController class]];
        self.mainIsTabBarController = [mainVC isKindOfClass:[UITabBarController class]];
        self.topVC = self.mainIsNavigationController ? [(UINavigationController*)self.mainVC viewControllers][0] : self.mainVC;
        if (self.mainIsNavigationController) {
            [[(UINavigationController*)self.mainVC navigationBar] setTintColor:[UIColor KTPNavigationBarTintColor]];
        }
        
        [self loadSubviews];
    }
}

#pragma mark - UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadSubviews];
}

#pragma mark - Loading subviews

- (void)loadSubviews {
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
    
    [self.view addSubview:self.mainVC.view];
    self.mainVC.view.frame = self.view.bounds;
}

@end
