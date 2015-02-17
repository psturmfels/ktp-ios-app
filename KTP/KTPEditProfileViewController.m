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
#import "KTPEditProfileCell.h"
#import "KTPEditProfileTableItem.h"
#import <ActionSheetPicker-3.0/ActionSheetStringPicker.h>
#import "KTPSUser.h"


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
    
    //personal info
    KTPEditProfileTableItem *firstName = [KTPEditProfileTableItem new];
    firstName.placeholder = @"First Name";
    firstName.text = self.member.firstName;
    KTPEditProfileTableItem *lastName = [KTPEditProfileTableItem new];
    lastName.placeholder = @"Last Name";
    lastName.text = self.member.lastName;
    KTPEditProfileTableItem *gender = [KTPEditProfileTableItem new];
    gender.placeholder = @"Gender";
    gender.text = self.member.gender;
    KTPEditProfileTableItem *uniqname = [KTPEditProfileTableItem new];
    uniqname.placeholder = @"Uniqname";
    uniqname.text = self.member.uniqname;
    KTPEditProfileTableItem *major = [KTPEditProfileTableItem new];
    major.placeholder = @"Major";
    major.text = self.member.major;
    KTPEditProfileTableItem *gradYear = [KTPEditProfileTableItem new];
    gradYear.placeholder = @"Graduation Year";
    gradYear.text = [NSString stringWithFormat:@"%ld", (long)self.member.gradYear];
    KTPEditProfileTableItem *hometown = [KTPEditProfileTableItem new];
    hometown.placeholder = @"Hometown";
    hometown.text = self.member.hometown;
    KTPEditProfileTableItem *bio = [KTPEditProfileTableItem new];
    bio.placeholder = @"Add bio here...";
    bio.text = self.member.biography;
    
    //fraternity info
    KTPEditProfileTableItem *status = [KTPEditProfileTableItem new];
    status.placeholder = @"Status";
    status.text = self.member.status;
    KTPEditProfileTableItem *role = [KTPEditProfileTableItem new];
    role.placeholder = @"Role";
    role.text = self.member.role;
    KTPEditProfileTableItem *pledgeClass = [KTPEditProfileTableItem new];
    pledgeClass.placeholder = @"Pledge Class";
    pledgeClass.text = self.member.pledgeClass;
    KTPEditProfileTableItem *comService = [KTPEditProfileTableItem new];
    comService.placeholder = @"Community Service Hours";
    comService.text = [NSString stringWithFormat:@"%ld", (long)self.member.comServHours];
    KTPEditProfileTableItem *proDev = [KTPEditProfileTableItem new];
    proDev.placeholder = @"Professional Development Events";
    proDev.text = [NSString stringWithFormat:@"%ld", (long)self.member.proDevEvents];
    
    //contact info
    KTPEditProfileTableItem *twitter = [KTPEditProfileTableItem new];
    twitter.placeholder = @"Twitter Handle";
    twitter.text = self.member.twitter;
    KTPEditProfileTableItem *facebook = [KTPEditProfileTableItem new];
    facebook.placeholder = @"Facebook Username";
    facebook.text = self.member.facebook;
    KTPEditProfileTableItem *linkedIn = [KTPEditProfileTableItem new];
    linkedIn.placeholder = @"LinkedIn Username";
    linkedIn.text = self.member.linkedIn;
    KTPEditProfileTableItem *personalSite = [KTPEditProfileTableItem new];
    personalSite.placeholder = @"www.yourpersonalwebsite.com";
    personalSite.text = self.member.personalSite;
    KTPEditProfileTableItem *phoneNumber = [KTPEditProfileTableItem new];
    phoneNumber.placeholder = @"(xxx)-xxx-xxxx";
    phoneNumber.text = self.member.phoneNumber;
    
    self.fields = [@[
                     [@[firstName, lastName, gender, uniqname, major, gradYear, hometown, bio] mutableCopy],
                     [@[status, role, pledgeClass, comService, proDev] mutableCopy],
                     [@[twitter, facebook, linkedIn, personalSite, phoneNumber] mutableCopy]
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
    [self.tableView registerClass:[KTPEditProfileCell class] forCellReuseIdentifier:@"MemberEditCell"];
    self.tableView.allowsSelection = YES;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:self.tableView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0 && indexPath.row == 7) {
        return kStandardTableViewCellHeight * 4;
    } else {
        return kStandardTableViewCellHeight;
    }
}

#pragma mark - UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    KTPEditProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberEditCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(indexPath.section == 0) {
        if(indexPath.row == 3) {
            cell.textField.textColor = [UIColor lightGrayColor];
        } else {
            cell.textField.textColor = [UIColor blackColor];
        }
        
        if (indexPath.row == 7) {
            // bio cell
            cell.isTextField = NO;
        }
    } else if(indexPath.section == 1) {
        if(![[KTPSUser currentUser].member.status isEqualToString:@"Eboard"]) {
            cell.textField.textColor = [UIColor lightGrayColor];
        } else {
            cell.textField.textColor = [UIColor blackColor];
        }
    }
    
    NSMutableArray *sectionFields = [self.fields objectAtIndex:indexPath.section];
    KTPEditProfileTableItem *data = [sectionFields objectAtIndex:indexPath.row];
    cell.textField.placeholder = data.placeholder;
    cell.textView.placeholder = data.placeholder;
    cell.textField.text = data.text;
    cell.textView.text = data.text;
    cell.textField.delegate = self;
    cell.textView.delegate = self;
    cell.textField.enabled = NO; //only set it enabled after being selected, check if it is in a section that should have a keyboard
    cell.textView.userInteractionEnabled = NO;
    
    
    return cell;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch(section) {
        case 0:
            return 8;
        case 1:
            return 5;
        case 2:
            return 5;
    }
    
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
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
    
    NSLog(@"selected row");
    
    self.prevIndexPath = self.curIndexPath ? self.curIndexPath : indexPath;
    self.curIndexPath = indexPath;
    
    KTPEditProfileCell *cell = (KTPEditProfileCell *)[tableView cellForRowAtIndexPath:indexPath];

    if (indexPath.section == 0 && indexPath.row == 2) {
        [self showPicker:indexPath];
    } else if(indexPath.section == 1) {
        if([[KTPSUser currentUser].member.status isEqualToString:@"Eboard"])  {
            [self showPicker:indexPath];
        }
    } else {
        if(!(indexPath.section == 0 && indexPath.row == 3)) {
            if (indexPath.section == 0 && indexPath.row == 7) {
                cell.textView.userInteractionEnabled = YES;
                [cell.textView becomeFirstResponder];
            } else {
                cell.textField.enabled = YES;
                [cell.textField becomeFirstResponder];
            }
        }
    }
}

-(void)showPicker:(NSIndexPath *)indexPath {
    
    KTPEditProfileCell *cell = (KTPEditProfileCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    NSString *title;
    NSArray *data;
    if(indexPath.section == 0 && indexPath.row == 2) {
        title = @"Select Gender";
        data = @[@"Female", @"Male", @"Other"];
    } else {
        title = self.pickerChoices[indexPath.row][0];
        data = self.pickerChoices[indexPath.row][1];
    }
    KTPEditProfileTableItem *item = self.fields[indexPath.section][indexPath.row];
    
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
    if (self.curIndexPath) {
        KTPEditProfileCell *cell = (KTPEditProfileCell *)[self.tableView cellForRowAtIndexPath:self.curIndexPath];
        NSMutableArray *sectionFields = [self.fields objectAtIndex:self.curIndexPath.section];
        KTPEditProfileTableItem *data = [sectionFields objectAtIndex:self.curIndexPath.row];
        data.text = cell.isTextField ? cell.textField.text : cell.textView.text;
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
    
    self.member.twitter = [self.fields[2][0] text];
    self.member.facebook = [self.fields[2][1] text];
    self.member.linkedIn = [self.fields[2][2] text];
    self.member.personalSite = [self.fields[2][3] text];
    self.member.phoneNumber = [self.fields[2][4] text];
    
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
    KTPEditProfileTableItem *data = [sectionFields objectAtIndex:self.prevIndexPath.row];
    data.text = textField.text;
    textField.enabled = NO;
    self.activeField = nil;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.activeField = textView;
    self.userDidMakeChanges = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    NSLog(@"textViewDidEndEditing");
    NSLog(@"saving text: %@", textView.text);
    assert(self.prevIndexPath);
    NSMutableArray *sectionFields = [self.fields objectAtIndex:self.prevIndexPath.section];
    KTPEditProfileTableItem *data = [sectionFields objectAtIndex:self.prevIndexPath.row];
    data.text = textView.text;
    textView.userInteractionEnabled = NO;
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
