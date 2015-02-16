//
//  KTPPledgeViewController.m
//  KTP
//
//  Created by Owen Yang on 1/26/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPPledgingViewController.h"
#import "KTPSPledgeTasks.h"

#import "KTPPledgeTasksViewController.h"
#import "KTPPledgeMeetingsViewController.h"

@implementation KTPPledgingViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        // Instantiate singleton
        [KTPSPledgeTasks pledgeTasks];
        
        self.tabBar.translucent = NO;
        
        UIViewController *pledgeTasksVC = [KTPPledgeTasksViewController new];
        UIViewController *pledgeMeetingsVC = [KTPPledgeMeetingsViewController new];
        self.viewControllers = @[pledgeTasksVC, pledgeMeetingsVC];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}


@end
