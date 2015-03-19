//
//  KTPSettingsViewController.m
//  KTP
//
//  Created by Owen Yang on 1/27/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPSettingsViewController.h"
#import "KTPSUser.h"

#import "KTPChangePasswordViewController.h"

@interface KTPSettingsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIButton *logoutButton;

@property (nonatomic, strong) UISwitch *touchIDSwitch;
@end

@implementation KTPSettingsViewController

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        self.navigationItem.title = @"Settings";
        
        [self initTouchIDSwitch];
        
        [self initLogoutButton];
    }
    return self;
}

- (void)initTouchIDSwitch {
    self.touchIDSwitch = [UISwitch new];
    self.touchIDSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:KTPUserSettingsKeyUseTouchID];
    [self.touchIDSwitch addTarget:self action:@selector(touchIDSwitchSelected) forControlEvents:UIControlEventValueChanged];
}

- (void)initLogoutButton {
    self.logoutButton = [UIButton new];
    [self.logoutButton setTitle:@"Logout" forState:UIControlStateNormal];
    [self.logoutButton addTarget:[KTPSUser currentUser] action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    
    UIColor *normalColor = [UIColor colorWithRed:0xff/255.0 green:0x69/255.0 blue:0x69/255.0 alpha:1];
    [self.logoutButton setBackgroundImage:[UIImage imageWithColor:normalColor] forState:UIControlStateNormal];
    [self.logoutButton setBackgroundImage:[UIImage imageWithColor:[normalColor colorWithAlphaComponent:0.5]] forState:UIControlStateHighlighted];
    self.logoutButton.titleLabel.textColor = [UIColor whiteColor];
}

#pragma mark - Loading Subviews

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadTableView];
}

- (void)loadTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.delaysContentTouches = NO;
    [self.view addSubview:self.tableView];
    
    [self loadFooterView];
}

- (void)loadFooterView {
    self.footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 100)];
    [self.footerView addSubview:self.logoutButton];
    [self autoLayoutFooterView];
    self.tableView.tableFooterView = self.footerView;
}

- (void)autoLayoutFooterView {
    self.logoutButton.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = @{
                            @"logoutButton"     :   self.logoutButton
                            };
    
    NSDictionary *metrics = @{
                              @"logoutButtonHeight"     :   [NSNumber numberWithFloat:kLargeButtonHeight]
                              };
    
    [self.footerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[logoutButton]-10-|" options:0 metrics:nil views:views]];
    [self.footerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[logoutButton(logoutButtonHeight)]" options:0 metrics:metrics views:views]];
    [self.footerView addConstraint:[NSLayoutConstraint constraintWithItem:self.logoutButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.footerView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:     // change password
                    [self.navigationController pushViewController:[KTPChangePasswordViewController new] animated:YES];
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
        case 1:
            return 1;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [UITableViewCell new];
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"Change Password";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"Use Touch ID";
                    cell.accessoryView = self.touchIDSwitch;
                    break;
                default:
                    break;
            }
        default:
            break;
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Account Setup";
        case 1:
            return @"Device Settings";
        default:
            return nil;
    }
}

#pragma mark - UI action selectors

- (void)touchIDSwitchSelected {
    [[NSUserDefaults standardUserDefaults] setBool:self.touchIDSwitch.on forKey:KTPUserSettingsKeyUseTouchID];
}

@end
