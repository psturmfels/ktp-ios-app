//
//  KTPAnnouncementsViewController.m
//  KTP
//
//  Created by Greg Azevedo on 8/27/14.
//  Copyright (c) 2014 Kappa Theta Pi. All rights reserved.
//

#import "KTPAnnouncementsViewController.h"

@interface KTPAnnouncementsViewController ()

@end

@implementation KTPAnnouncementsViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.navigationItem.title = @"Announcements";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}


@end
