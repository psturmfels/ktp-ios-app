//
//  KTPPledgeMeetingsViewController.m
//  KTP
//
//  Created by Owen Yang on 2/6/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPPledgeMeetingsViewController.h"

@interface KTPPledgeMeetingsViewController ()

@end

@implementation KTPPledgeMeetingsViewController

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Meetings" image:[UIImage imageNamed:@"MeetingTabBarIcon"] tag:1];
    }
    return self;
}

#pragma mark - UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.navigationItem.title = @"Pledge Meetings";
    
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
    if (self.tableView.frame.origin.y < statusBarHeight + navBarHeight) {
        CGRect frame = self.tableView.frame;
        frame.origin.y += statusBarHeight + navBarHeight;
        frame.size.height -= frame.origin.y;
        self.tableView.frame = frame;
    }
}

@end
