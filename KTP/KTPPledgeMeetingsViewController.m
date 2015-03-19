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
#import "KTPPledgeMeeting.h"

#import "NSIndexSet+KTPHelpers.h"

@interface KTPPledgeMeetingsViewController ()

@property (nonatomic, weak) NSArray *meetings;
@property (nonatomic) NSMutableIndexSet *completedMeetingIdxes;
@property (nonatomic) NSMutableIndexSet *incompletedMeetingIdxes;

@end

@implementation KTPPledgeMeetingsViewController

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Meetings" image:[UIImage imageNamed:@"MeetingTabBarIcon"] tag:1];
        self.navigationItem.title = @"Pledge Meetings";
        self.completedMeetingIdxes = [NSMutableIndexSet indexSet];
        self.incompletedMeetingIdxes = [NSMutableIndexSet indexSet];
        self.meetings = [KTPSUser currentMember].meetings;
        [self.meetings enumerateObjectsUsingBlock:^(KTPPledgeMeeting *meeting, NSUInteger idx, BOOL *stop) {
            if (meeting.complete) {
                [self.completedMeetingIdxes addIndex:idx];
            } else {
                [self.incompletedMeetingIdxes addIndex:idx];
            }
        }];
    }
    return self;
}

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
    cell.accessoryType = (indexPath.section == 0) ? UITableViewCellAccessoryNone : UITableViewCellAccessoryCheckmark;
    NSIndexSet *meetingIdxs = (indexPath.section == 0) ? self.incompletedMeetingIdxes : self.completedMeetingIdxes;
    KTPPledgeMeeting *meeting = [self.meetings objectAtIndex:[meetingIdxs indexAtIndex:indexPath.row]];
    KTPMember *other = [KTPSUser currentUserIsPledge] ? meeting.active : meeting.pledge;
    [cell setOtherMember:[NSString stringWithFormat:@"%@ %@", other.firstName, other.lastName]];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 0) ? self.incompletedMeetingIdxes.count : self.completedMeetingIdxes.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

#pragma mark - Interaction Handling

-(void)tappedEdit {
    if (self.tableView.editing) {
        [self.tableView setEditing:NO animated:YES];
    } else {
        [self.tableView setEditing:YES animated:YES];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableView.editing) {
        KTPPledgeMeetingsCell *cell = (KTPPledgeMeetingsCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        KTPPledgeMeeting *meeting = [self.meetings objectAtIndex:indexPath.row];
        KTPMember *m = ([[KTPSUser currentMember].status isEqualToString:@"Pledge"]) ? meeting.active : meeting.pledge;
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
