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


@interface KTPEditProfileViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *textFields;
@property (nonatomic, strong) KTPTextView *bioField;
@property (nonatomic, strong) UITextField *firstName;
@property (nonatomic, strong) UITextField *lastName;
@property (nonatomic, strong) UITextField *gender;
@property (nonatomic, strong) UITextField *major;
@property (nonatomic, strong) UITextField *hometown;
@property (nonatomic, strong) UITextField *gradYear;
@property (nonatomic, strong) UITextField *uniqname;

@property (nonatomic, strong) UIView *activeField;

@property (nonatomic)         BOOL userDidMakeChanges; // flag to determine whether member update is necessary

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
        [self initTextFields];
        [self initBioField];
    }
    return self;
}

-(void)initBioField {
    self.bioField = [[KTPTextView alloc] initWithPlaceholder:@"Add bio here..."];
    self.bioField.frame = CGRectMake(0, 0, 1, 1);
    self.bioField.text = self.member.biography;
    self.bioField.font = [UIFont systemFontOfSize:[UIFont labelFontSize]];
    self.bioField.delegate = self;
}

-(void)initTextFields {
    self.firstName = [UITextField new];
    self.firstName.placeholder = @"First Name";
    self.firstName.text = self.member.firstName;
    self.lastName = [UITextField new];
    self.lastName.placeholder = @"Last Name";
    self.lastName.text = self.member.lastName;
    self.gender = [UITextField new];
    self.gender.placeholder = @"Gender";
    self.gender.text = self.member.gender;
    self.uniqname = [UITextField new];
    self.uniqname.placeholder = @"Uniqname";
    self.uniqname.text = self.member.uniqname;
    self.uniqname.enabled = NO;
    self.uniqname.textColor = [UIColor lightGrayColor];
    self.major = [UITextField new];
    self.major.placeholder = @"Major";
    self.major.text = self.member.major;
    self.gradYear = [UITextField new];
    self.gradYear.placeholder = @"Graduation Year";
    self.gradYear.text = [NSString stringWithFormat:@"%ld", (long)self.member.gradYear];
    self.hometown = [UITextField new];
    self.hometown.placeholder = @"Hometown";
    self.hometown.text = self.member.hometown;
    
    self.textFields = @[self.firstName,
                        self.lastName,
                        self.gender,
                        self.uniqname,
                        self.major,
                        self.gradYear,
                        self.hometown
                        ];
    for (UITextField *textField in self.textFields) {
        textField.delegate = self;
    }
}

- (void)registerKeyboardNotifications {
    // We use change notification (instead of show/hide) in case the user changes
    // the height of the keyboard by adding/removing the autofill bar
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)deregisterKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)dealloc {
    [self deregisterKeyboardNotifications];
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
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MemberEditCell"];
    self.tableView.allowsSelection = NO;
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberEditCell" forIndexPath:indexPath];
    
    CGRect frame = cell.contentView.bounds;
    frame.origin.x += cell.separatorInset.left;
    frame.size.width -= cell.separatorInset.left;
    
    if(indexPath.section == 0) {
        if(indexPath.row < 7) {
            UITextField *textField =[self.textFields objectAtIndex:indexPath.row];
            textField.frame = frame;
            [cell.contentView addSubview:textField];
        }
        if(indexPath.row == 7) {
            self.bioField.frame = frame;
            [cell.contentView addSubview:self.bioField];
        }
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch(section) {
        case 0:
            return 8;
        case 1:
            return 2;
        case 2:
            return 2;
    }
    
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
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

#pragma mark - UI action selectors

- (void)cancelButtonTapped {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*!
 Called when the done button is tapped. Makes a request to the KTP API to update the member's profile information. Displays an alert if there was an error when updating. Otherwise, dismisses the view controller after the request is complete.
 */
- (void)doneButtonTapped {
    NSLog(@"done button tapped");
    
    // Don't bother saving anything if the user didn't make changes
    if (!self.userDidMakeChanges) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    // Check if all fields have been completed
    for(int i = 0; i < [self.textFields count]; i++) {
        UITextField *textField = [self.textFields objectAtIndex:i];
        
        // If a field was left empty, alert the user
        if(![textField.text isNotNilOrEmpty]){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Missing Fields" message:@"One or more sections were not completed" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
    }
    
    // Update member object
    self.member.firstName = self.firstName.text;
    self.member.lastName = self.lastName.text;
    self.member.gradYear = [self.gradYear.text integerValue];
    self.member.major = self.major.text;
    self.member.gender = self.gender.text;
    self.member.hometown = self.hometown.text;
    self.member.biography = self.bioField.text;
    
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
