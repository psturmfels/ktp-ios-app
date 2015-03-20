//
//  KTPPledgeMeetingsViewController.m
//  KTP
//
//  Created by Owen Yang on 2/6/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPPledgeMeetingsViewController.h"
#import "KTP-Swift.h"
#import "KTPSUser.h"

#import "KTPSMembers.h"
#import "KTPProfileViewController.h"
#import "KTPMember.h"
#import "KTPPledgeMeeting.h"

#import "NSIndexSet+KTPHelpers.h"

@interface KTPPledgeMeetingsViewController ()

@property (nonatomic, weak) NSArray *meetings;
@property (nonatomic, strong) NSMutableArray *selected; // array containing BOOLs whether each row is selected

@end

@implementation KTPPledgeMeetingsViewController

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Meetings" image:[UIImage imageNamed:@"MeetingIcon"] tag:2];
        self.navigationItem.title = @"Pledge Meetings";
        
        // Initialize arrays
        self.meetings = [KTPSUser currentMember].meetings;
        self.selected = [NSMutableArray arrayWithCapacity:self.meetings.count];
        [self.meetings enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [self.selected insertObject:@([(KTPPledgeMeeting*)obj complete]) atIndex:idx];
        }];
        
        if ([KTPSUser currentUserIsAdmin] || [KTPSUser currentUserIsActive]) {
            [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editButtonTapped)]];
        }
    }
    return self;
}

#pragma mark - Overridden setters/getters

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    
    self.navigationItem.rightBarButtonItem.title = editing ? @"Done" : @"Edit";
    
    // Save the menu button
    static UIBarButtonItem *menuButton;
    if (!menuButton) {
        menuButton = self.navigationItem.leftBarButtonItem;
    }
    
    // Create the cancel button, and set it as the left bar button item when in editing mode
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped)];
    self.navigationItem.leftBarButtonItem = editing ? cancelButton : menuButton;
    
    // If entering editing mode, record which meetings are currently complete and preselect those cells
    // If exiting editing mode, deselect all of the cells
    if (editing) {
        [self.selected enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj boolValue]) {
                [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
            }
        }];
    } else {
        [self.meetings enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0] animated:YES];
        }];
    }
    
}

#pragma mark - UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[KTPPledgeMeetingsCell class] forCellReuseIdentifier:@"MeetingCell"];
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
}

#pragma mark - UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KTPPledgeMeetingsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeetingCell" forIndexPath:indexPath];
    cell.meeting = self.meetings[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.meetings.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kStandardTableViewCellHeight;
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.editing) {
        self.selected[indexPath.row] = @YES;
    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        KTPPledgeMeeting *meeting = [self.meetings objectAtIndex:indexPath.row];
        KTPMember *m = ([[KTPSUser currentMember].status isEqualToString:@"Pledge"]) ? meeting.active : meeting.pledge;
        KTPProfileViewController *vc = [[KTPProfileViewController alloc] initWithMember:m];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.editing) {
        self.selected[indexPath.row] = @NO;
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

#pragma mark - UI action selectors

- (void)editButtonTapped {
    [self setEditing:!self.editing animated:YES];
    
    // Exiting editing mode with done
    // Save changes, and update all meetings
    if (!self.editing) {
        [self.meetings enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [self.meetings[idx] setComplete:[self.selected[idx] boolValue]];
            
            // Reload the cell's values
            [(KTPPledgeMeetingsCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]] loadLabelValues];
            [self.meetings[idx] update:^(BOOL successful) {
                if (!successful) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Meeting Update Failed"
                                                                                   message:@"Pledge meeting(s) could not be updated."
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
                    [self presentViewController:alert animated:YES completion:nil];
                }
            }];
        }];
    }
}

- (void)cancelButtonTapped {
    [self setEditing:NO animated:YES];
    
    [self.meetings enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        self.selected[idx] = @([obj complete]);
    }];
}

@end
