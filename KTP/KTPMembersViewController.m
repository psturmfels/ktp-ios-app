//
//  KTPMembersViewController.m
//  KTP
//
//  Created by Owen Yang on 11/13/14.
//  Copyright (c) 2014 Kappa Theta Pi. All rights reserved.
//

#import "KTPMembersViewController.h"
#import "KTPMembersDataSource.h"
#import "KTPSMembers.h"
#import "KTPProfileViewController.h"
#import "KTPMembersCell.h"
#import "KTPMember.h"
#import "KTPSUser.h"

@interface KTPMembersViewController () <UITableViewDelegate>

@property (nonatomic, strong) UITableView *membersTableView;
@property (nonatomic, strong) KTPMembersDataSource *dataSource;

@end

@implementation KTPMembersViewController

- (void)updateMembersTableView:(NSNotification*)notification {
    [self.membersTableView reloadData];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateMembersTableView:)
                                                     name:KTPNotificationMembersUpdated
                                                   object:nil];
        self.membersTableView = [UITableView new];
        self.membersTableView.delegate = self;
        
        self.dataSource = [KTPMembersDataSource new];
        self.membersTableView.dataSource = self.dataSource;
        [self.membersTableView registerClass:[KTPMembersCell class] forCellReuseIdentifier:@"MemberCell"];
        
        self.navigationItem.title = @"Members";
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ProfileIcon"]
                                                                                  style:UIBarButtonItemStylePlain
                                                                                 target:self
                                                                                 action:@selector(showUserProfile)];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Add members TableView as subview
    self.membersTableView.frame = self.view.frame;
    [self.view addSubview:self.membersTableView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Get the corresponding cell's member
    KTPMembersCell *cell = (KTPMembersCell*)[tableView cellForRowAtIndexPath:indexPath];
    [self showProfileWithMember:cell.member];
}

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
    NSLog(@"name: %@\nid: %@", member.firstName, member._id);
    
    KTPProfileViewController *profileVC = [[KTPProfileViewController alloc] initWithMember:member];
    
    // Push profileVC onto the navigation stack
    [self.navigationController pushViewController:profileVC animated:YES];
}

@end
