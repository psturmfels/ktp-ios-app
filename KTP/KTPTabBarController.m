//
//  KTPTabBarController.m
//  KTP
//
//  Created by Greg Azevedo on 8/13/14.
//  Copyright (c) 2014 Kappa Theta Pi. All rights reserved.
//

#import "KTPTabBarController.h"
//views
#import "KTPMembersViewController.h"
#import "KTPAnnouncementsViewController.h"
#import "KTPRequirementsViewController.h"
#import "KTPLoginViewController.h"

#import "KTPUser.h"

@interface KTPTabBarController ()

@property (nonatomic) KTPLoginViewController *loginVC;
@property (nonatomic) KTPMembersViewController *membersVC;
@property (nonatomic) UINavigationController *membersNavigationVC;
@property (nonatomic) KTPAnnouncementsViewController *announcementsVC;
@property (nonatomic) KTPRequirementsViewController *requirementsVC;
@property (nonatomic) UINavigationController *requirementsNavigationVC;

@end


@implementation KTPTabBarController

-(void)loadView
{
    [super loadView];
    [self loadMembersVC];
    [self loadRequirementsVC];
    [self loadMainVC];
    NSArray *VCs = @[self.membersNavigationVC, self.announcementsVC, self.requirementsNavigationVC];
    [self setViewControllers:VCs];
    [self.view setTintColor:[UIColor KTPDarkGray]];
}

-(void)loadMembersVC
{
    self.membersVC = [KTPMembersViewController new];
    self.membersNavigationVC = [[UINavigationController alloc] initWithRootViewController:self.membersVC];
    self.membersNavigationVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Members" image:nil tag:0];
    [self.membersNavigationVC.navigationBar setTintColor:[UIColor KTPBlue136]];
}

-(void)loadMainVC
{
    self.announcementsVC = [KTPAnnouncementsViewController new];
    self.announcementsVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Announcements" image:nil tag:1];
}

-(void)loadRequirementsVC
{
    self.requirementsVC = [KTPRequirementsViewController new];
    self.requirementsNavigationVC = [[UINavigationController alloc] initWithRootViewController:self.requirementsVC];
    self.requirementsNavigationVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Requirements" image:nil tag:2];
    [self.requirementsNavigationVC.navigationBar setTintColor:[UIColor KTPBlue136]];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (![KTPUser currentUser].isLoggedIn) {
        self.loginVC = [KTPLoginViewController new];
        [self presentViewController:self.loginVC animated:YES completion:nil];
    }
}

@end
