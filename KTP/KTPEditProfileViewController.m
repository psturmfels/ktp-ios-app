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


@interface KTPEditProfileViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

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

@end

@implementation KTPEditProfileViewController

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        self.navigationItem.title = @"Edit Profile";
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTapped)];
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
    self.bioField.text = self.member.biography;
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
        if(indexPath.row == 8) {
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

#pragma mark - UI action selectors

- (void)cancelButtonTapped {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*!
 Called when the done button is tapped. Makes a request to the KTP API to update the member's profile information. Displays an alert if there was an error when updating. Otherwise, dismisses the view controller after the request is complete.
 */
- (void)doneButtonTapped {
    
    for(int i = 0; i < [self.textFields count]; i++) {
        UITextField *textField = [self.textFields objectAtIndex:i];
        if(![textField.text isNotNilOrEmpty]){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Missing Fields" message:@"One or more sections were not completed" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
    }
    
    NSDictionary *memberInfo = @{
                                 @"first_name"  :   self.firstName.text,
                                 @"last_name"   :   self.lastName.text,
                                 @"year"        :   self.gradYear.text,
                                 @"major"       :   self.major.text,
                                 @"gender"      :   self.gender.text,
                                 @"hometown"    :   self.hometown.text,
                                 @"biography"   :   self.bioField.text
                                 };
    
    [KTPNetworking sendAsynchronousRequestType:KTPRequestTypePUT toRoute:KTPRequestRouteAPIMembers appending:self.member._id parameters:nil withBody:memberInfo block:^(NSURLResponse *response, NSData *data, NSError *error) {
        if(error) {
            NSLog(@"Error updating member");
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Member update failed" message:@"Your info was not added or updated" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            [self.view endEditing:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    
    NSLog(@"done button tapped");
}

@end
