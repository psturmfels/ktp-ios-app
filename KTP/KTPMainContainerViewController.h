//
//  KTPMainContainerViewController.h
//  KTP
//
//  Created by Owen Yang on 3/12/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KTPRootViewController;

@interface KTPMainContainerViewController : UIViewController

/**
 * The view controller stored by this container. It is the main
 * view controller of the app (in contrast to the slide menu).
 * This may be any view controller, including a navigation controller,
 * tab bar controller, etc.
 */
@property (nonatomic, strong) UIViewController *mainVC;

/**
 * A boolean flag storing whether or not <code>mainVC</code>
 * is a navigation controller.
 */
@property (nonatomic) BOOL mainIsNavigationController;

/**
 * A boolean flag storing whether or not <code>mainVC</code>
 * is a tab bar controller.
 */
@property (nonatomic) BOOL mainIsTabBarController;

/**
 * The first view controller that is not a navigation controller.
 * If <code>mainVC</code> is a navigation controller, this property 
 * stores the root view controller of the navigation controller.
 * Otherwise, this property simply stores <code>mainVC</code>.
 */
@property (nonatomic, strong) UIViewController *topVC;

@end
