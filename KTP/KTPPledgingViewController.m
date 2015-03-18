//
//  KTPPledgeViewController.m
//  KTP
//
//  Created by Owen Yang on 1/26/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPPledgingViewController.h"
#import "KTPSPledgeTasks.h"

#import "KTPPledgeOverviewViewController.h"
#import "KTPPledgeTasksViewController.h"
#import "KTPPledgeMeetingsViewController.h"

@implementation KTPPledgingViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        // Instantiate singleton
        [KTPSPledgeTasks pledgeTasks];
        
        self.tabBar.translucent = NO;
        
        UINavigationController *pledgeOverviewVC = [[UINavigationController alloc] initWithRootViewController:[KTPPledgeOverviewViewController new]];
        UINavigationController *pledgeTasksVC = [[UINavigationController alloc] initWithRootViewController:[KTPPledgeTasksViewController new]];
        UINavigationController *pledgeMeetingsVC = [[UINavigationController alloc] initWithRootViewController:[KTPPledgeMeetingsViewController new]];
        self.viewControllers = @[pledgeOverviewVC, pledgeTasksVC, pledgeMeetingsVC];
        
        for (UINavigationController *navVC in self.viewControllers) {
            navVC.navigationBar.tintColor = [UIColor KTPNavigationBarTintColor];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

@end
