//
//  KTPPledgeViewController.m
//  KTP
//
//  Created by Owen Yang on 1/26/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPPledgeViewController.h"

@implementation KTPPledgeViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.navigationItem.title = @"Pledge";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

@end
