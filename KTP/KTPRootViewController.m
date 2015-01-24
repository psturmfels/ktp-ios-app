//
//  KTPRootViewController.m
//  KTP
//
//  Created by Owen Yang on 1/20/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPRootViewController.h"
#import "KTPLoginViewController.h"
#import "KTPSlideMenuViewController.h"
#import "KTPMembersViewController.h"

#import "KTPRequirementsViewController.h"
#import "KTPAnnouncementsViewController.h"

#import "KTPSlideMenuCell.h"

#import "KTPUser.h"

@interface KTPRootViewController () <KTPSlideMenuDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) KTPLoginViewController *loginVC;
@property (nonatomic, strong) KTPSlideMenuViewController *slideMenuVC;
@property (nonatomic, strong) UINavigationController *navVC;

@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;

@property (nonatomic) BOOL menuIsShowing;

@end

@implementation KTPRootViewController

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        // Init and add menu as child VC
        self.slideMenuVC = [KTPSlideMenuViewController new];
        self.slideMenuVC.delegate = self;
        [self addChildViewController:self.slideMenuVC];
        [self.slideMenuVC didMoveToParentViewController:self];
        
        // Init and add main nav as child VC
        self.navVC = [[UINavigationController alloc] initWithRootViewController:[KTPMembersViewController new]];
        [self addChildViewController:self.navVC];
        [self.navVC didMoveToParentViewController:self];
    }
    return self;
}

#pragma mark - View Setup

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navVC.navigationBar.tintColor = [UIColor blackColor];
    
    // Setup shadow for main view
    self.navVC.view.layer.shadowOpacity = kMainViewShadowOpacity;
    
    [self setupTapRecognizer];
    [self setupPanRecognizer];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (![KTPUser currentUser].isLoggedIn) {
        self.loginVC = [KTPLoginViewController new];
        [self presentViewController:self.loginVC animated:YES completion:^{
            [self loadSubviews];
        }];
    } else {
        [self loadSubviews];
    }
}

/*!
 Loads the subviews of the root VC (the menu and the default view).
 */
- (void)loadSubviews {
    if (![self.view.subviews containsObject:self.slideMenuVC.view]) {
        [self.view addSubview:self.slideMenuVC.view];
    }
    [self.view sendSubviewToBack:self.slideMenuVC.view];
    
    if (![self.view.subviews containsObject:self.navVC.view]) {
        [self.view addSubview:self.navVC.view];
    }
    
    [self.view insertSubview:self.navVC.view aboveSubview:self.slideMenuVC.view];
    
    // Setup menu button
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"MenuIcon"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(toggleMenu)];
    [self.navVC.viewControllers[0] navigationItem].leftBarButtonItem = menuButton;
}

#pragma mark - Tap/Gesture

/*!
 Sets up a tap recognizer to close the menu upon tapping the main view.
 */
- (void)setupTapRecognizer {
    if (!self.tapRecognizer) {
        self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleMenu)];
        [self.navVC.view addGestureRecognizer:self.tapRecognizer];
        self.tapRecognizer.enabled = self.menuIsShowing;
    }
}

- (void)setupPanRecognizer {
    if (!self.panRecognizer) {
        self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveMainViewWithPan:)];
        self.panRecognizer.delegate = self;
        self.panRecognizer.minimumNumberOfTouches = 1;
        [self.navVC.view addGestureRecognizer:self.panRecognizer];
    }
}

- (void)moveMainViewWithPan:(UIPanGestureRecognizer*)panRecognizer {
    CGPoint panTranslation = [panRecognizer translationInView:self.view];
    CGPoint panVelocity = [panRecognizer velocityInView:self.view];
    
    static CGRect startFrame;       // panRecognizer.view's starting frame
    static BOOL showMenuAfterPan;   // whether or not to show the menu after pan has ended
    
    switch (panRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            startFrame = panRecognizer.view.frame;
            showMenuAfterPan = self.menuIsShowing;
            break;
        case UIGestureRecognizerStateChanged:
            // determines whether or not to show the menu after the pan, based on how much of the panRecognizer's view is showing
            if (panVelocity.x > 200) {
                showMenuAfterPan = YES;
            } else if (panVelocity.x < -200) {
                showMenuAfterPan = NO;
            } else {
                showMenuAfterPan = panRecognizer.view.frame.origin.x > self.view.center.x;
            }
            
            // do not allow panned view to move too far to the right
            if (startFrame.origin.x + panTranslation.x <= kSlideMenuWidth) {
                
                CGRect newFrame = panRecognizer.view.frame;
                CGFloat newOriginX = startFrame.origin.x + panTranslation.x;
                
                // do not allow panned view to move too far to the left
                newFrame.origin.x = MAX(newOriginX, self.view.frame.origin.x);
                
                panRecognizer.view.frame = newFrame;
            }
            break;
        case UIGestureRecognizerStateCancelled: // fallthrough to UIGestureRecognizerStateEnded
        case UIGestureRecognizerStateEnded:
            if (showMenuAfterPan) {
                // check if menu was showing before pan
                if (!self.menuIsShowing) {
                    [self toggleMenu];
                } else {
                    [self moveMainViewRight];
                }
            } else {
                // check if menu was showing before pan
                if (self.menuIsShowing) {
                    [self toggleMenu];
                } else {
                    [self moveMainViewCenter];
                }
            }
            break;
        default:
            break;
    }
}

#pragma mark - Slide Menu

- (void)toggleMenu {
    if (self.menuIsShowing) {
        // close menu
        [self moveMainViewCenter];
    } else {
        // open menu
        [self moveMainViewRight];
    }
    self.menuIsShowing = !self.menuIsShowing;
    
    // after menu has been opened or closed
    self.tapRecognizer.enabled = self.menuIsShowing;
    self.navVC.topViewController.view.userInteractionEnabled = !self.menuIsShowing;
}

- (void)moveMainViewRight {
    [UIView animateWithDuration:kSlideAnimationDuration
                     animations:
    ^{
        CGRect frame = self.view.frame;
        frame.origin.x += kSlideMenuWidth;
        self.navVC.view.frame = frame;
    }
                     completion:nil];
}

- (void)moveMainViewCenter {
    [UIView animateWithDuration:kSlideAnimationDuration
                     animations:
     ^{
         self.navVC.view.frame = self.view.frame;
     }
                     completion:nil];
}

//- (void)moveMainViewLeft {
//    [UIView animateWithDuration:kSlideAnimationDuration
//                     animations:
//     ^{
//         CGRect frame = self.view.frame;
//         frame.origin.x -= kSlideMenuWidth;
//         self.navVC.view.frame = frame;
//     }
//                     completion:nil];
//}

- (void)didSelectSlideMenuCell:(KTPSlideMenuCell *)cell {
    UIViewController *baseVC = self.navVC.viewControllers[0];
    switch (cell.viewType) {
        case KTPViewTypeMembers:
            if (![baseVC isKindOfClass:[KTPMembersViewController class]]) {
                [self.navVC setViewControllers:@[[KTPMembersViewController new]]];
                [self loadSubviews];
            }
            break;
        case KTPViewTypeAnnouncements:
            if (![baseVC isKindOfClass:[KTPAnnouncementsViewController class]]) {
                [self.navVC setViewControllers:@[[KTPAnnouncementsViewController new]]];
                [self loadSubviews];
            }
            break;
        default:
            break;
    }
    [self toggleMenu];
}

@end