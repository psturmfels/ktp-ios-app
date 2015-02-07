//
//  KTPPledgeViewController.m
//  KTP
//
//  Created by Owen Yang on 1/26/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPPledgingViewController.h"
#import "KTPSPledgeTasks.h"

@implementation KTPPledgingViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        // Instantiate singleton
        [KTPSPledgeTasks pledgeTasks];
        
        self.navigationItem.title = @"Pledging";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

@end
