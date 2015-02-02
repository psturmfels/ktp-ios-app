//
//  KTPPitchAddViewController.m
//  KTP
//
//  Created by Owen Yang on 1/29/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPPitchAddViewController.h"
#import "KTPNetworking.h"
#import "KTPSUser.h"
#import "KTPMember.h"
#import "KTPTextView.h"

@interface KTPPitchAddViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UITextField *titleField;
@property (nonatomic, strong) KTPTextView *descriptionField;

@end

@implementation KTPPitchAddViewController

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        self.navigationItem.title = @"New Pitch";
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTapped)];
        
        [self initTitleField];
        [self initDescriptionField];
    }
    return self;
}

- (void)initTitleField {
    self.titleField = [UITextField new];
    self.titleField.placeholder = @"Pitch Title";
}

- (void)initDescriptionField {
    self.descriptionField = [[KTPTextView alloc] initWithPlaceholder:@"Add a description..."];
    self.descriptionField.font = [UIFont systemFontOfSize:[UIFont labelFontSize]];
}

#pragma mark - Loading Subviews

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadTableView];
}

- (void)loadTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"PitchAddCell"];
    self.tableView.allowsSelection = NO;
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        return kStandardTableViewCellHeight * 4;
    } else {
        return kStandardTableViewCellHeight;
    }
}

#pragma mark - UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PitchAddCell" forIndexPath:indexPath];
    
    // Align frame of content with beginning of cell separator inset
    CGRect frame = cell.contentView.bounds;
    frame.origin.x += cell.separatorInset.left + cell.indentationLevel * cell.indentationWidth;
    frame.size.width -= frame.origin.x;
    
    switch (indexPath.row) {
        case 0:
            self.titleField.frame = frame;
            [cell.contentView addSubview:self.titleField];
            break;
        case 1:
            self.descriptionField.frame = frame;
            [cell.contentView addSubview:self.descriptionField];
            break;
        default:
            break;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - UI action selectors

/*!
 Adds a pitch. Updates the KTP database.
 
 @param         pitch   The pitch to add
 */
- (void)doneButtonTapped {
    
    // Check if pitch was filled out completely
    if (!([self.titleField.text isNotNilOrEmpty] && [self.descriptionField.text isNotNilOrEmpty])) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Missing Fields" message:@"One or more sections were not completed" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    NSDictionary *pitch = @{
                            @"member"       :   [KTPSUser currentUser].member._id,
                            @"title"        :   self.titleField.text,
                            @"description"  :   self.descriptionField.text
                            };

    [KTPNetworking sendAsynchronousRequestType:KTPRequestTypePOST
                                       toRoute:KTPRequestRouteAPIPitches
                                     appending:nil
                                    parameters:nil
                                      withBody:pitch
                                         block:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"Error adding pitch");
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Pitch Update Failed" message:@"Your pitch was not added or updated" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            [self.view endEditing:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (void)cancelButtonTapped {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
