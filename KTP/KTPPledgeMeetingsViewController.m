//
//  KTPPledgeMeetingsViewController.m
//  KTP
//
//  Created by Owen Yang on 2/6/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPPledgeMeetingsViewController.h"
#import "KTPPledgeMeetingsCell.h"
#import "KTPSUser.h"

#import "KTPSMembers.h"
#import "KTPProfileViewController.h"
#import "KTPMember.h"

@interface KTPPledgeMeetingsViewController ()

@end

@implementation KTPPledgeMeetingsViewController

//get users meetings
//throw the users of the meetings in the cell
//have tap on cell go to other user profile

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Meetings" image:[UIImage imageNamed:@"MeetingTabBarIcon"] tag:1];
    }
    return self;
}

-(void)tappedEdit {
    if (self.tableView.editing) {
        [self.tableView setEditing:NO animated:YES];
    } else {
        [self.tableView setEditing:YES animated:YES];
    }
}

#pragma mark - UIViewController methods

-(void)loadView {
    [super loadView];
    [self.tableView registerClass:[KTPPledgeMeetingsCell class] forCellReuseIdentifier:@"Cell"];
    self.tabBarController.navigationItem.title = @"Pledge Meetings";
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(tappedEdit)];
    [self.tabBarController.navigationItem setRightBarButtonItem:edit];

}

#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KTPPledgeMeetingsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if (indexPath.section == 1) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    KTPMember *m = [[KTPSMembers members].membersArray objectAtIndex:indexPath.row];
    [cell setOtherMember:[NSString stringWithFormat:@"%@ %@", m.firstName, m.lastName]];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [KTPSMembers members].membersArray.count;
    //[KTPSUser curUser].member.meetings.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableView.editing) {
        KTPPledgeMeetingsCell *cell = (KTPPledgeMeetingsCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        //    KTPMember *other = [meetings objectAtIndex:indexPath.row].member;
        KTPMember *m = [[KTPSMembers members].membersArray objectAtIndex:indexPath.row];
        KTPProfileViewController *vc = [[KTPProfileViewController alloc] initWithMember:m];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *moreAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"More" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        // show UIActionSheet
    }];
    moreAction.backgroundColor = [UIColor greenColor];
    
    UITableViewRowAction *flagAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Flag" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        // flag the row
    }];
    flagAction.backgroundColor = [UIColor yellowColor];
    
    return @[moreAction, flagAction];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 100;
//}



@end
