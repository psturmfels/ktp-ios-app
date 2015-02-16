//
//  KTPEditProfileViewController.m
//  KTP
//
//  Created by Owen Yang on 2/2/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPEditProfileViewController.h"
#import "KTPMember.h"
#import "KTPNetworking.h"
#import "KTPSMembers.h"
#import "KTPTextView.h"
#import "NSString+KTPStrings.h"
#import "KTPTableViewCell.h"
#import "TableItem.h"
#import <ActionSheetPicker-3.0/ActionSheetStringPicker.h>


@interface KTPEditProfileViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic) NSMutableArray *fields;
@property (nonatomic) NSArray *pickerChoices;
@property (nonatomic) NSIndexPath *prevIndexPath;
@property (nonatomic) NSIndexPath *curIndexPath;
@property (nonatomic) UIView *activeField;

@property (nonatomic) BOOL userDidMakeChanges; // flag to determine whether member update is necessary

@end

@implementation KTPEditProfileViewController

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        self.navigationItem.title = @"Edit Profile";
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTapped)];
        [self registerKeyboardNotifications];
        self.userDidMakeChanges = NO;
    }
    return self;
}

- (instancetype)initWithMember:(KTPMember*)member {
    self = [self init];
    if (self) {
        self.member = member;
        [self initFields];
        [self initArrays];
    }
    return self;
}



-(void)initFields {
    
    TableItem *firstName = [TableItem new];
    firstName.placeholder = @"First Name";
    firstName.text = self.member.firstName;
    TableItem *lastName = [TableItem new];
    lastName.placeholder = @"Last Name";
    lastName.text = self.member.lastName;
    TableItem *gender = [TableItem new];
    gender.placeholder = @"Gender";
    gender.text = self.member.gender;
    TableItem *uniqname = [TableItem new];
    uniqname.placeholder = @"Uniqname";
    uniqname.text = self.member.uniqname;
    TableItem *major = [TableItem new];
    major.placeholder = @"Major";
    major.text = self.member.major;
    TableItem *gradYear = [TableItem new];
    gradYear.placeholder = @"Graduation Year";
    gradYear.text = [NSString stringWithFormat:@"%ld", (long)self.member.gradYear];
    TableItem *hometown = [TableItem new];
    hometown.placeholder = @"Hometown";
    hometown.text = self.member.hometown;
    TableItem *bio = [TableItem new];
    bio.placeholder = @"Add bio here...";
    bio.text = self.member.biography;
    
    TableItem *status = [TableItem new];
    status.placeholder = @"Status";
    status.text = self.member.status;
    TableItem *role = [TableItem new];
    role.placeholder = @"Role";
    role.text = self.member.role;
    TableItem *pledgeClass = [TableItem new];
    pledgeClass.placeholder = @"Pledge Class";
    pledgeClass.text = self.member.pledgeClass;
    TableItem *comService = [TableItem new];
    comService.placeholder = @"Community Service Hours";
    comService.text = [NSString stringWithFormat:@"%ld", (long)self.member.comServHours];
    TableItem *proDev = [TableItem new];
    proDev.placeholder = @"Professional Development Events";
    proDev.text = [NSString stringWithFormat:@"%ld", (long)self.member.proDevEvents];
    
    //contact info
    
    self.fields = [@[
                     [@[firstName, lastName, gender, uniqname, major, gradYear, hometown, bio] mutableCopy],
                     [@[status, role, pledgeClass, comService, proDev] mutableCopy]
                     ] mutableCopy];
}

-(void)initArrays {
    NSArray *statusChoices = @[@"Active", @"Eboard", @"Probation", @"Inactive", @"Pledge"];
    NSArray *roleChoices = @[@"Member", @"Pledge", @"President", @"Vice President", @"Secretary",
                             @"Treasurer", @"Director of Engagement", @"Director of Marketing",
                             @"Director of Technology", @"Director of Professional Development",
                             @"Director of Membership"];
    NSArray *pledgeClassChoices = @[@"Alpha", @"Beta", @"Gamma", @"Delta", @"Epsilon", @"Zeta", @"Eta"];
    NSArray *hoursChoices = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10"];
    NSArray *proDevChoices = @[@"0", @"1", @"2", @"3"];
    
    self.pickerChoices = @[@[@"Select Status", statusChoices], @[@"Select Role", roleChoices],
                           @[@"Select Pledge Class", pledgeClassChoices],
                           @[@"Select Volunteer Hours", hoursChoices],
                           @[@"Select Pro Dev Events", proDevChoices]];
}

- (void)registerKeyboardNotifications {
    // We use change notification (instead of show/hide) in case the user changes
    // the height of the keyboard by adding/removing the autofill bar
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    [self.tableView registerClass:[KTPTableViewCell class] forCellReuseIdentifier:@"MemberEditCell"];
    self.tableView.allowsSelection = YES;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:self.tableView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 7) {
        return kStandardTableViewCellHeight * 4;
    } else {
        return kStandardTableViewCellHeight;
    }
}

#pragma mark - UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    KTPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberEditCell" forIndexPath:indexPath];
    
    if(indexPath.section == 0) {
        if(indexPath.row == 3) {
            cell.textField.textColor = [UIColor lightGrayColor];
        } else {
            cell.textField.textColor = [UIColor blackColor];
        }
    } else if(indexPath.section == 1) {
        if(![self.member.status isEqualToString:@"Eboard"]) {
            cell.textField.textColor = [UIColor lightGrayColor];
        } else {
            cell.textField.textColor = [UIColor blackColor];
        }
    }
    
    NSMutableArray *sectionFields = [self.fields objectAtIndex:indexPath.section];
    TableItem *data = [sectionFields objectAtIndex:indexPath.row];
    cell.textField.placeholder = data.placeholder;
    cell.textField.text = data.text;
    cell.textField.delegate = self;
    cell.textField.enabled = NO; //only set it enabled after being selected, check if it is in a section that should have a keyboard
    
    
    return cell;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch(section) {
        case 0:
            return 8;
        case 1:
            return 5;
        case 2:
            return 2;
    }
    
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Personal";
        case 1:
            return @"Fraternity";
        case 2:
            return @"Contact";
        default:
            return nil;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.prevIndexPath = self.curIndexPath ? self.curIndexPath : indexPath;
    self.curIndexPath = indexPath;
    
    KTPTableViewCell *cell = (KTPTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];

    if (indexPath.section == 0) {
        //manually passing the touch through to the text field, instead of textFieldDidBeginEditing
        cell.textField.enabled = YES;
        [cell.textField becomeFirstResponder];
    } else if(indexPath.section == 1) {
        [self showPicker:indexPath];
    }
}

-(void)showPicker:(NSIndexPath *)indexPath {
    
    KTPTableViewCell *cell = (KTPTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    NSString *title = self.pickerChoices[indexPath.row][0];
    NSArray *data = self.pickerChoices[indexPath.row][1];
    TableItem *item = self.fields[indexPath.section][indexPath.row];
    
    ActionSheetStringPicker *picker = [[ActionSheetStringPicker alloc]
                                       initWithTitle:title
                                       rows:data
                                       initialSelection:0
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           
                                           if (![cell.textField.text isEqualToString:selectedValue]) {
                                               self.userDidMakeChanges = YES;
                                           }
                                            item.text = selectedValue;
                                           [self.tableView reloadData];
                                       }
                                       cancelBlock:nil
                                       origin:cell];
    [picker showActionSheetPicker];
    
}


#pragma mark - UI action selectors

- (void)cancelButtonTapped {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*!
 Called when the done button is tapped. Makes a request to the KTP API to update the member's profile information. Displays an alert if there was an error when updating. Otherwise, dismisses the view controller after the request is complete.
 */
- (void)doneButtonTapped {
//    [self.view endEditing:YES];
    if (self.curIndexPath) {
        KTPTableViewCell *cell = (KTPTableViewCell *)[self.tableView cellForRowAtIndexPath:self.curIndexPath];
        NSMutableArray *sectionFields = [self.fields objectAtIndex:self.curIndexPath.section];
        TableItem *data = [sectionFields objectAtIndex:self.curIndexPath.row];
        data.text = cell.textField.text;
    }
    NSLog(@"done tapped, self.fields should be updated to pass back to parent view controller fields: %@", self.fields);
    
    // Don't bother saving anything if the user didn't make changes
    if (!self.userDidMakeChanges) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    // Check if all fields have been completed
//    for(int i = 0; i < [self.textFields count]; i++) {
//        UITextField *textField = [self.textFields objectAtIndex:i];
//        
//        // If a field was left empty, alert the user
//        if(![textField.text isNotNilOrEmpty]){
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Missing Fields" message:@"One or more sections were not completed" preferredStyle:UIAlertControllerStyleAlert];
//            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
//            [self presentViewController:alert animated:YES completion:nil];
//            return;
//        }
//    }
    
    // Update member object
    self.member.firstName = [self.fields[0][0] text];
    self.member.lastName = [self.fields[0][1] text];
    self.member.gender = [self.fields[0][2] text];
    self.member.major = [self.fields[0][4] text];
    self.member.gradYear = [[self.fields[0][5] text] integerValue];
    self.member.hometown = [self.fields[0][6] text];
    self.member.biography = [self.fields[0][7] text];
    
    self.member.status = [self.fields[1][0] text];
    self.member.role = [self.fields[1][1] text];
    self.member.pledgeClass = [self.fields[1][2] text];
    self.member.comServHours = [[self.fields[1][3] text] integerValue];
    self.member.proDevEvents = [[self.fields[1][4] text] integerValue];
    
    // Update member in database
    [self.member update:^(BOOL successful) {
        if (successful) {
            NSLog(@"Member successfully updated");
            [self.view endEditing:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            NSLog(@"Error updating member");
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Member update failed" message:@"Your info was not added or updated" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}

#pragma mark - Handling Keyboard Show/Hide

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activeField = textField;
    self.userDidMakeChanges = YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"textFieldDidEndEditing");
    NSLog(@"saving text: %@", textField.text);
    assert(self.prevIndexPath);
    NSMutableArray *sectionFields = [self.fields objectAtIndex:self.prevIndexPath.section];
    TableItem *data = [sectionFields objectAtIndex:self.prevIndexPath.row];
    data.text = textField.text;
    textField.enabled = NO;
    self.activeField = nil;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.activeField = textView;
    self.userDidMakeChanges = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.activeField = nil;

}

- (void)keyboardDidChangeFrame:(NSNotification*)notification {
    
    // Determine the change in keyboard position/height
    CGRect beginFrame = [notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat frameChangeY = endFrame.origin.y - beginFrame.origin.y;
    
    // Change the tableview's insets in accordance with the change in keyboard position
    UIEdgeInsets insets = self.tableView.scrollIndicatorInsets;
    insets.bottom -= frameChangeY;
    self.tableView.scrollIndicatorInsets = insets;
    self.tableView.contentInset = insets;
    
    // Get the visible frame (bottom of navigation bar to top of keyboard)
    CGRect visibleFrame = self.tableView.frame;
    visibleFrame.size.height -= endFrame.size.height;
    
    // Get the active field's tableview cell
    UIView *view = self.activeField.superview;
    if (!view) return;
    while (![view.class isSubclassOfClass:[UITableViewCell class]]) {
        view = view.superview;
    }
    
    // If active field is not visible, scroll the tableview so it is visible + some padding
    CGRect activeFrame = view.frame;
    activeFrame.size.height += 10;
    CGPoint point = activeFrame.origin;
    point.y += activeFrame.size.height;
    if (!CGRectContainsPoint(visibleFrame, point)) {
        [self.tableView scrollRectToVisible:activeFrame animated:YES];
    }
}

- (void)keyboardWillHide:(NSNotification*)notification {
    self.tableView.contentInset = UIEdgeInsetsZero;
}

@end
