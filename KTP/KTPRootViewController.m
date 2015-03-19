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
#import "KTPMainContainerViewController.h"

#import "KTPProfileViewController.h"
#import "KTPMembersViewController.h"
#import "KTPPledgingViewController.h"
#import "KTPAnnouncementsViewController.h"
#import "KTPSettingsViewController.h"
#import "KTPPitchesViewController.h"

#import "KTPSlideMenuCell.h"

#import "KTPSUser.h"

@interface KTPRootViewController () <KTPSlideMenuDelegate, UIGestureRecognizerDelegate, UINavigationControllerDelegate, UITabBarControllerDelegate>

@property (nonatomic, strong) KTPLoginViewController *loginVC;
@property (nonatomic, strong) KTPSlideMenuViewController *slideMenuVC;
@property (nonatomic, strong) KTPMainContainerViewController *mainContainerVC;

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
        self.slideMenuVC.menuTableView.scrollsToTop = NO;
        [self addChildViewController:self.slideMenuVC];
        [self.slideMenuVC didMoveToParentViewController:self];
        
        // Init and add main container as child VC
        self.mainContainerVC = [KTPMainContainerViewController new];
        self.mainContainerVC.mainVC
            = [[UINavigationController alloc] initWithRootViewController:[[KTPProfileViewController alloc] initWithMember:[KTPSUser currentMember]]];
        [(UINavigationController*)self.mainContainerVC.mainVC setDelegate:self];
        [self addChildViewController:self.mainContainerVC];
        [self.mainContainerVC didMoveToParentViewController:self];
        
        // Observe logout notifications
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(resetLogin)
                                                     name:KTPNotificationUserLogout
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(memberUpdateFailed)
                                                     name:KTPNotificationMemberUpdateFailed
                                                   object:nil];
    }
    return self;
}

#pragma mark - UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setup shadow for main view
    self.mainContainerVC.view.layer.shadowOpacity = kMainViewShadowOpacity;
    
    [self setupTapRecognizer];
    [self setupPanRecognizer];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self resetLogin];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults boolForKey:KTPSettingsKeyTouchIDPrompted] &&
        ![defaults boolForKey:KTPUserSettingsKeyUseTouchID] &&
        [KTPSUser currentUser].loggedIn) {
//        [defaults setBool:YES forKey:KTPSettingsKeyTouchIDPrompted];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Touch ID"
                                                                       message:@"Enable Touch ID for future logins? You can change this setting later."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"Enable" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [defaults setBool:YES forKey:KTPUserSettingsKeyUseTouchID];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - Loading subviews

/*!
 Loads the subviews of the root VC (the menu and the main view).
 */
- (void)loadSubviews {
    if (![self.view.subviews containsObject:self.slideMenuVC.view]) {
        [self.view addSubview:self.slideMenuVC.view];
    }
    [self.view sendSubviewToBack:self.slideMenuVC.view];
    
    if (![self.view.subviews containsObject:self.mainContainerVC.view]) {
        [self.view addSubview:self.mainContainerVC.view];
    }
    
    [self.view insertSubview:self.mainContainerVC.view aboveSubview:self.slideMenuVC.view];
    
    // Setup menu button
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"MenuIcon"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(toggleMenu)];
    if (self.mainContainerVC.mainIsTabBarController) {
        UIViewController *vc = [(UITabBarController*)self.mainContainerVC.mainVC viewControllers][0];
        if ([vc isKindOfClass:[UINavigationController class]]) {
            [[(UINavigationController*)vc viewControllers][0] navigationItem].leftBarButtonItem = menuButton;
        }
    } else {
        [self.mainContainerVC.topVC navigationItem].leftBarButtonItem = menuButton;
    }
}

#pragma mark - Tap/Gesture

/*!
 Sets up a tap recognizer to close the menu upon tapping the main view.
 */
- (void)setupTapRecognizer {
    if (!self.tapRecognizer) {
        self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleMenu)];
        [self.mainContainerVC.view addGestureRecognizer:self.tapRecognizer];
        self.tapRecognizer.enabled = self.menuIsShowing;
    }
}

- (void)setupPanRecognizer {
    if (!self.panRecognizer) {
        self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveMainViewWithPan:)];
        self.panRecognizer.delegate = self;
        self.panRecognizer.minimumNumberOfTouches = 1;
        [self.mainContainerVC.view addGestureRecognizer:self.panRecognizer];
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
    self.mainContainerVC.topVC.view.userInteractionEnabled = !self.menuIsShowing;
    self.slideMenuVC.menuTableView.scrollsToTop = self.menuIsShowing;
}

- (void)moveMainViewRight {
    [UIView animateWithDuration:kSlideAnimationDuration
                     animations:
    ^{
        CGRect frame = self.view.frame;
        frame.origin.x += kSlideMenuWidth;
        self.mainContainerVC.view.frame = frame;
    }
                     completion:nil];
}

- (void)moveMainViewCenter {
    [UIView animateWithDuration:kSlideAnimationDuration
                     animations:
     ^{
         self.mainContainerVC.view.frame = self.view.frame;
     }
                     completion:nil];
}

//- (void)moveMainViewLeft {
//    [UIView animateWithDuration:kSlideAnimationDuration
//                     animations:
//     ^{
//         CGRect frame = self.view.frame;
//         frame.origin.x -= kSlideMenuWidth;
//         self.mainContainerVC.view.frame = frame;
//     }
//                     completion:nil];
//}

- (void)didSelectSlideMenuCell:(KTPSlideMenuCell *)cell {
    UIViewController *baseVC = self.mainContainerVC.topVC;
    switch (cell.viewType) {
        case KTPViewTypeMyProfile:
            if (![baseVC isKindOfClass:[KTPProfileViewController class]]) {
                self.mainContainerVC.mainVC = [[UINavigationController alloc] initWithRootViewController:[[KTPProfileViewController alloc] initWithMember:[KTPSUser currentMember]]];
            }
            break;
        case KTPViewTypeMembers:
            if (![baseVC isKindOfClass:[KTPMembersViewController class]]) {
                self.mainContainerVC.mainVC = [[UINavigationController alloc] initWithRootViewController:[KTPMembersViewController new]];
            }
            break;
        case KTPViewTypePledging:
            if (![baseVC isKindOfClass:[KTPPledgingViewController class]]) {
                self.mainContainerVC.mainVC = [KTPPledgingViewController new];
            }
            break;
        case KTPViewTypeAnnouncements:
            if (![baseVC isKindOfClass:[KTPAnnouncementsViewController class]]) {
                self.mainContainerVC.mainVC = [[UINavigationController alloc] initWithRootViewController:[KTPAnnouncementsViewController new]];
            }
            break;
        case KTPViewTypeSettings:
            if (![baseVC isKindOfClass:[KTPSettingsViewController class]]) {
                self.mainContainerVC.mainVC = [[UINavigationController alloc] initWithRootViewController:[KTPSettingsViewController new]];
            }
            break;
        case KTPViewTypePitches:
            if (![baseVC isKindOfClass:[KTPPitchesViewController class]]) {
                self.mainContainerVC.mainVC = [[UINavigationController alloc] initWithRootViewController:[KTPPitchesViewController new]];
            }
            break;
        default:
            break;
    }
    if (self.mainContainerVC.mainIsNavigationController) {
        [(UINavigationController*)self.mainContainerVC.mainVC setDelegate:self];
    } else if (self.mainContainerVC.mainIsTabBarController) {
        [(UITabBarController*)self.mainContainerVC.mainVC setDelegate:self];
    }
    
    if (baseVC != self.mainContainerVC.topVC) {
        [self loadSubviews];
    }
    [self toggleMenu];
}

#pragma mark - Notification handling

/**
 * Loads and presents the login view if there is no user logged in.
 */
- (void)resetLogin {
    if (![KTPSUser currentUser].isLoggedIn) {
        [[KTPSUser currentUser] loginWithSession:^(BOOL successful, NSError *error) {
            if (!successful) {
                self.loginVC = [KTPLoginViewController new];
                [self presentViewController:self.loginVC animated:YES completion:^{
                    [self loadSubviews];
                }];
            } else {
                [self loadSubviews];
            }
        }];
    }
}

- (void)memberUpdateFailed {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Update Failed"
                                                                   message:@"Member information was not updated"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UINavigationControllerDelegate methods

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // Only enable pan recognition if viewing bottom of navigation controller
    self.panRecognizer.enabled = (navigationController.viewControllers.count <= 1);
}

#pragma mark - UITabBarControllerDelegate methods

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navVC = (UINavigationController*)viewController;
        [navVC setDelegate:self];
        self.panRecognizer.enabled = [navVC viewControllers].count <= 1;
        
        // Setup menu button if necessary
        if (![navVC.viewControllers[0] navigationItem].leftBarButtonItem) {
            UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"MenuIcon"]
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(toggleMenu)];
            [navVC.viewControllers[0] navigationItem].leftBarButtonItem = menuButton;
        }
    }
}

@end
