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

@interface KTPMembersViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic, strong) UITableView *membersTableView;
@property (nonatomic, strong) NSMutableArray *filteredMembers;

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation KTPMembersViewController

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        self.navigationItem.title = @"Members";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ProfileIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(showUserProfile)];

        [self initTableView];
        [self initPullToRefresh];
        
        self.filteredMembers = [KTPSMembers members].membersArray;
        
        // Register for notification of members updated
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMembersTableView) name:KTPNotificationMembersUpdated object:nil];
    }
    return self;
}

- (void)initTableView {
    self.membersTableView = [UITableView new];
    self.membersTableView.delegate = self;
    self.membersTableView.dataSource = self;
    self.membersTableView.separatorInset = UIEdgeInsetsZero;
    [self.membersTableView registerClass:[KTPMembersCell class] forCellReuseIdentifier:@"MemberCell"];
    
    self.membersTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}

- (void)initPullToRefresh {
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(refreshMembers) forControlEvents:UIControlEventValueChanged];
    [self.membersTableView addSubview:self.refreshControl];
}

- (void)initSearchBar {
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.membersTableView.tableHeaderView.frame.size.width, kStandardTableViewCellHeight)];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"Search for members";
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchBar.tintColor = [UIColor blackColor];
    
    self.membersTableView.tableHeaderView = self.searchBar;
    self.membersTableView.contentOffset = CGPointMake(0, self.searchBar.frame.size.height);
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Add members TableView as subview
    self.membersTableView.frame = self.view.frame;
    [self.view addSubview:self.membersTableView];
    
    [self initSearchBar];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self resetSearchBar:self.searchBar];
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
    self.filteredMembers = [KTPSMembers members].membersArray;
    [self.membersTableView reloadData];
    [self.refreshControl endRefreshing];
}

#pragma mark - Refresh TableView

- (void)refreshMembers {
    [[KTPSMembers members] reloadMembers];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredMembers.count;
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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.member = self.filteredMembers[indexPath.row];
    return cell;
}

#pragma mark - UISearchBarDelegate methods

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [self.searchBar setShowsCancelButton:NO animated:YES];
    searchBar.text = @"";
    [self searchBar:searchBar textDidChange:searchBar.text];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText isNotNilOrEmpty]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstName contains[c] %@ OR lastName contains[c] %@", searchText, searchText];
        self.filteredMembers = (NSMutableArray*)[[KTPSMembers members].membersArray filteredArrayUsingPredicate:predicate];
    } else {
        self.filteredMembers = [KTPSMembers members].membersArray;
    }
    [self.membersTableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self resetSearchBar:searchBar];
    
    // Haven't decided if we should hide searchbar on cancel
//    [self.membersTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)resetSearchBar:(UISearchBar*)searchBar {
    searchBar.text = @"";
    [searchBar resignFirstResponder];
}

@end
