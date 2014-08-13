//
//  KTPAppDelegate.h
//  KTP
//
//  Created by Greg Azevedo on 8/13/14.
//  Copyright (c) 2014 Kappa Theta Pi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KTPTabBarController;

@interface KTPAppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic) UIWindow *window;
@property (nonatomic) KTPTabBarController *tabBarVC;

@end
