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

@property (nonatomic, strong) NSMutableArray *filteredMembers;
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
        [self initSearchBar];
        self.filteredMembers = [KTPSMembers members].membersArray;
        
        // Register for notification of members updated
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTableView) name:KTPNotificationMembersUpdated object:nil];
    }
    return self;
}

- (void)initTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    [self.tableView registerClass:[KTPMembersCell class] forCellReuseIdentifier:@"MemberCell"];
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}

- (void)initPullToRefresh {
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(refreshMembers) forControlEvents:UIControlEventValueChanged];
}

- (void)initSearchBar {
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, kStandardTableViewCellHeight)];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"Search for members";
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchBar.tintColor = [UIColor blackColor];
    
    self.tableView.tableHeaderView = self.searchBar;
    
    /*
     This is a workaround to set the tableview to the correct offset
     I'm not sure why, but it does not work without the dispatch_async call,
     even though it is just dispatched back to the main queue
     */
    dispatch_async(dispatch_get_main_queue(), ^{
        CGPoint offset = self.tableView.contentOffset;
        offset.y += self.tableView.tableHeaderView.frame.size.height;
        [self.tableView setContentOffset:offset animated:NO];
    });
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UIViewController methods

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    /*
     Haven't decided if we should clear the search upon tapping on a member
     
     [self resetSearchBar:self.searchBar];
     [self filterMembersWithText:@""];
     */
}

#pragma mark - Showing KTPProfileViewController

/*!
 Shows the profile of the logged in user as maintained by KTPSUser
 */
- (void)showUserProfile {
    [self showProfileWithMember:[KTPSUser currentMember]];
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

- (void)updateTableView {
    self.filteredMembers = [KTPSMembers members].membersArray;
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

#pragma mark - UI action selectors

- (void)refreshMembers {
    [[KTPSMembers members] reloadMembers];
    [self resetSearchBar:self.searchBar];
}

#pragma mark - TableView

- (void)resetTableViewPosition {
    if ([self.tableView numberOfRowsInSection:0]) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Get the corresponding cell's member
    KTPMembersCell *cell = (KTPMembersCell*)[tableView cellForRowAtIndexPath:indexPath];
    [self showProfileWithMember:cell.member];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kStandardTableViewCellHeight;
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredMembers.count;
}

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
    if (![searchBar.text isNotNilOrEmpty]) {
        [self.searchBar setShowsCancelButton:NO animated:YES];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self filterMembersWithText:searchText];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self resetSearchBar:searchBar];
    [self filterMembersWithText:@""];
    
    /*
     Haven't decided if we should hide searchbar on cancel
     
     [self resetTableViewPosition];
     */
}

- (void)filterMembersWithText:(NSString*)text {
    if ([text isNotNilOrEmpty]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstName contains[c] %@ OR lastName contains[c] %@", text, text];
        self.filteredMembers = (NSMutableArray*)[[KTPSMembers members].membersArray filteredArrayUsingPredicate:predicate];
    } else {
        self.filteredMembers = [KTPSMembers members].membersArray;
    }
    [self.tableView reloadData];
}

- (void)resetSearchBar:(UISearchBar*)searchBar {
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    
    /*
     Force cancel button away if this is called before text has gotten a chance to clear
     Especially useful when user pulls-to-refresh during a search. The scroll causes
     the keyboard to disappear before the refresh action is triggered. Thus at first, the text
     is not empty, and the cancel button is not cleared, even though the text is empty later.
     */
    [self searchBarTextDidEndEditing:searchBar];
}

@end
