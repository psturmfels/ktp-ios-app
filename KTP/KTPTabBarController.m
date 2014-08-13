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
    self.mainVC = [KTPViewController new];
    self.requirementsVC = [KTPRequirementsViewController new];
    NSArray *VCs = @[self.mainVC, self.requirementsVC];
    [self setViewControllers:VCs];
    self.mainVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Home" image:nil tag:1];
    self.requirementsVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Reuirements" image:nil tag:2];
}


@end
