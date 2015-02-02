//
//  KTPMembersViewController.m
//  KTP
//
//  Created by Owen Yang on 11/13/14.
//  Copyright (c) 2014 Kappa Theta Pi. All rights reserved.
//

#import "KTPMembersViewController.h"
#import "KTPSMembers.h"
#import "KTPProfileViewController.h"
#import "KTPMembersCell.h"
#import "KTPMember.h"
#import "KTPSUser.h"

@interface KTPMembersViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *membersTableView;

@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation KTPMembersViewController

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        self.navigationItem.title = @"Members";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ProfileIcon"]
                                                                                  style:UIBarButtonItemStylePlain
                                                                                 target:self
                                                                                 action:@selector(showUserProfile)];
        [self initTableView];
        [self initPullToRefresh];
        
        // Register for notification of members updated
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateMembersTableView)
                                                     name:KTPNotificationMembersUpdated
                                                   object:nil];
    }
    return self;
}

- (void)initTableView {
    self.membersTableView = [UITableView new];
    self.membersTableView.delegate = self;
    self.membersTableView.dataSource = self;
    self.membersTableView.separatorInset = UIEdgeInsetsZero;
    [self.membersTableView registerClass:[KTPMembersCell class] forCellReuseIdentifier:@"MemberCell"];
}

- (void)initPullToRefresh {
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(refreshMembers) forControlEvents:UIControlEventValueChanged];
    [self.membersTableView addSubview:self.refreshControl];
}

#pragma mark - Loading Subviews

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Add members TableView as subview
    self.membersTableView.frame = self.view.frame;
    [self.view addSubview:self.membersTableView];
}

#pragma mark - Showing KTPProfileViewController

/*!
 Shows the profile of the logged in user as maintained by KTPSUser
 */
- (void)showUserProfile {
    [self showProfileWithMember:[KTPSUser currentUser].member];
}

/*!
 Initializes a KTPProfileViewController with a member and pushes it onto the navigation stack
 
 @param         member
 */
- (void)showProfileWithMember:(KTPMember*)member {
    // Push a profile VC onto the navigation stack
    [self.navigationController pushViewController:[[KTPProfileViewController alloc] initWithMember:member] animated:YES];
}

#pragma mark - Notification Handling

- (void)updateMembersTableView {
    [self.membersTableView reloadData];
    [self.refreshControl endRefreshing];
}

#pragma mark - Refresh TableView

- (void)refreshMembers {
    [[KTPSMembers members] reloadMembers];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [KTPSMembers members].membersArray.count;
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Get the corresponding cell's member
    KTPMembersCell *cell = (KTPMembersCell*)[tableView cellForRowAtIndexPath:indexPath];
    [self showProfileWithMember:cell.member];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

#pragma mark - UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KTPMembersCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[KTPMembersCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MemberCell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.member = [KTPSMembers members].membersArray[indexPath.row];
    
    return cell;
}

@end
