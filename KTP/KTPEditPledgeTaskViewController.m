//
//  KTPEditPledgeTaskViewController.m
//  KTP
//
//  Created by Owen Yang on 2/21/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPEditPledgeTaskViewController.h"
#import "KTPTextInputTableViewCell.h"
#import "KTPPledgeTask.h"
#import <ActionSheetPicker-3.0/ActionSheetStringPicker.h>

@interface KTPEditPledgeTaskViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation KTPEditPledgeTaskViewController

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        
        self.navigationItem.title = @"Edit Task";
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTapped)];
    }
    return self;
}

- (instancetype)initWithPledgeTask:(KTPPledgeTask*)pledgeTask {
    self = [self init];
    if (self) {
        self.pledgeTask = pledgeTask;
    }
    return self;
}

#pragma mark - Overridden Setters/Getters

- (void)setPledgeTask:(KTPPledgeTask *)pledgeTask {
    if (_pledgeTask != pledgeTask) {
        _pledgeTask = pledgeTask;
        
//        [self.tableView reloadData];
    }
}

#pragma mark - UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return kStandardTableViewCellHeight;
        case 1:
            return kStandardTableViewCellHeight * 4;
        default:
            return kStandardTableViewCellHeight;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 6) {
        KTPTextInputTableViewCell *cell = (KTPTextInputTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        ActionSheetStringPicker *picker = [[ActionSheetStringPicker alloc] initWithTitle:@"Repeatable"
                                                                                    rows:@[@"Yes", @"No"]
                                                                        initialSelection:([cell.text isEqualToString:@"Yes"] ? 0 : 1)
                                                                               doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                                                                   [tableView deselectRowAtIndexPath:indexPath animated:YES];
                                                                                   cell.text = selectedValue;
                                                                               }
                                                                             cancelBlock:^(ActionSheetStringPicker *picker) {
                                                                                 [tableView deselectRowAtIndexPath:indexPath animated:YES];
                                                                             }
                                                                                  origin:[tableView cellForRowAtIndexPath:indexPath]];
        [picker showActionSheetPicker];
    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;   // PLACEHOLDER TO ALLOW COMPILATION
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KTPTextInputTableViewCell *cell = (KTPTextInputTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        switch (indexPath.row) {
            case 0:     // title
                cell = [[KTPTextInputTableViewCell alloc] initWithText:self.pledgeTask.taskTitle placeholder:@"Title" isTextField:YES];
                break;
            case 1:     // description
                cell = [[KTPTextInputTableViewCell alloc] initWithText:self.pledgeTask.taskDescription placeholder:@"Description" isTextField:NO];
                break;
            case 2:     // proof
                cell = [[KTPTextInputTableViewCell alloc] initWithText:self.pledgeTask.proof placeholder:@"Proof" isTextField:YES];
                break;
            case 3:     // points earned
                cell = [[KTPTextInputTableViewCell alloc] initWithText:[NSString stringWithFormat:@"%.0f", self.pledgeTask.pointsEarned] placeholder:@"Points Earned" isTextField:YES];
                cell.inputType = KTPInputTypeDecimal;
                break;
            case 4:     // points worth
                cell = [[KTPTextInputTableViewCell alloc] initWithText:[NSString stringWithFormat:@"%.0f", self.pledgeTask.points] placeholder:@"Points Worth" isTextField:YES];
                cell.inputType = KTPInputTypeDecimal;
                break;
            case 5:     // points worth
                cell = [[KTPTextInputTableViewCell alloc] initWithText:[NSString stringWithFormat:@"%lu", (unsigned long)self.pledgeTask.minimumPledges] placeholder:@"Minimum Pledges" isTextField:YES];
                cell.inputType = KTPInputTypeInteger;
                break;
            case 6:     // repeatable
                cell = [[KTPTextInputTableViewCell alloc] initWithText:(self.pledgeTask.repeatable ? @"Yes" : @"No") placeholder:nil isTextField:YES];
                cell.inputType = KTPInputTypeSelect;
                break;
            default:
                break;
        }
    }
    return cell;
}

#pragma mark - UI action selectors

- (void)cancelButtonTapped {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doneButtonTapped {
    [self.view endEditing:YES];
    
    // Update the task
    self.pledgeTask.taskTitle = [(KTPTextInputTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] text];
    self.pledgeTask.taskDescription = [(KTPTextInputTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]] text];
    self.pledgeTask.proof = [(KTPTextInputTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]] text];
    self.pledgeTask.pointsEarned = [[(KTPTextInputTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]] text] floatValue];
    self.pledgeTask.points = [[(KTPTextInputTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]] text] floatValue];
    self.pledgeTask.minimumPledges = [[(KTPTextInputTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]] text] integerValue];
    self.pledgeTask.repeatable = [[(KTPTextInputTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]] text] boolValue];
    
    [self.pledgeTask update:^(BOOL successful) {
        if (successful) {
            NSLog(@"pledge task updated successfully");
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            NSLog(@"error updating pledge task");
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Update failed" message:@"The pledge task was not added or updated" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}

@end
