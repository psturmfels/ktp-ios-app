//
//  KTPSettingsViewController.m
//  KTP
//
//  Created by Owen Yang on 1/27/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPSettingsViewController.h"
#import "KTPSettingsDataSource.h"
#import "KTPSUser.h"

#import "KTPChangePasswordViewController.h"

@interface KTPSettingsViewController () <UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) KTPSettingsDataSource *dataSource;

@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIButton *logoutButton;
@end

@implementation KTPSettingsViewController

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        self.navigationItem.title = @"Settings";
        [self initLogoutButton];
    }
    return self;
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
    self.dataSource = [KTPSettingsDataSource new];
    self.tableView.dataSource = self.dataSource;
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
    [self.footerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[logoutButton]-10-|" options:0 metrics:nil views:views]];
    [self.footerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[logoutButton(50)]|" options:0 metrics:nil views:views]];
}

#pragma mark - UITableView Delegate Methods

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

@end
