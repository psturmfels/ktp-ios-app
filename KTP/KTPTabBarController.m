//
//  KTPTabBarController.m
//  KTP
//
//  Created by Greg Azevedo on 8/13/14.
//  Copyright (c) 2014 Kappa Theta Pi. All rights reserved.
//

#import "KTPTabBarController.h"
#import "KTPViewController.h"
#import "KTPRequirementsViewController.h"

@interface KTPTabBarController ()

@property (nonatomic) KTPViewController *mainVC;
@property (nonatomic) KTPRequirementsViewController *requirementsVC;
@property (nonatomic) UINavigationController *requirementsNavigationVC;

@end

@implementation KTPTabBarController

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


-(void)loadView
{
    [super loadView];
    [self loadRequirementsVC];
    [self loadMainVC];
    NSArray *VCs = @[self.mainVC, self.requirementsNavigationVC];
    [self setViewControllers:VCs];
    [self.view setTintColor:[UIColor KTPDarkGray]];
}

-(void)loadRequirementsVC
{
    self.requirementsVC = [KTPRequirementsViewController new];
    self.requirementsNavigationVC = [[UINavigationController alloc] initWithRootViewController:self.requirementsVC];
    self.requirementsNavigationVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Requirements" image:nil tag:2];
    [self.requirementsNavigationVC.navigationBar setTintColor:[UIColor KTPBlue136]];
}

-(void)loadMainVC
{
    self.mainVC = [KTPViewController new];
    self.mainVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Home" image:nil tag:1];
}


@end
