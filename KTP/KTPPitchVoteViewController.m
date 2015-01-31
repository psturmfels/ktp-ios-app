//
//  KTPPitchVoteViewController.m
//  KTP
//
//  Created by Owen Yang on 1/29/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPPitchVoteViewController.h"
#import "KTPPitch.h"
#import "KTPMember.h"

#import <ActionSheetPicker-3.0/ActionSheetStringPicker.h>

@interface KTPPitchVoteViewController () <UITableViewDelegate, UITableViewDataSource>

// Container views
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;

// Content views
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *memberLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UILabel *descriptionDataLabel;
@property (nonatomic, strong) UILabel *voteLabel;
@property (nonatomic, strong) UITableView *voteTableView;
@property (nonatomic, strong) UIButton *voteButton;

@property (nonatomic, strong) UILabel *innovationScoreLabel;
@property (nonatomic, strong) UILabel *usefulnessScoreLabel;
@property (nonatomic, strong) UILabel *coolnessScoreLabel;
@end

@implementation KTPPitchVoteViewController

#pragma mark - Initialization

- (instancetype)initWithPitch:(KTPPitch*)pitch {
    self = [super init];
    if (self) {
        self.pitch = pitch;
        self.navigationItem.title = @"Pitch";
    }
    return self;
}

#pragma mark - Loading Subviews

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadSubviews];
    [self autoLayoutSubviews];
}

- (void)loadSubviews {
    // Container views
    [self loadScrollView];
    [self loadContentView];
    
    // Content views
    [self loadTitleLabel];
    [self loadMemberLabel];
    [self loadDescriptionLabel];
    [self loadVoteLabel];
    [self loadVoteTableVew];
    [self loadVoteButton];
}

- (void)loadScrollView {
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    self.scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:self.scrollView];
}

- (void)loadContentView {
    self.contentView = [[UIView alloc] initWithFrame:self.view.frame];
    [self.scrollView addSubview:self.contentView];
}

- (void)loadTitleLabel {
    self.titleLabel = [UILabel labelWithText:self.pitch.pitchTitle];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentView addSubview:self.titleLabel];
}

- (void)loadMemberLabel {
    self.memberLabel = [UILabel labelWithText:[NSString stringWithFormat:@"By %@ %@", self.pitch.member.firstName, self.pitch.member.lastName]];
    self.memberLabel.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
    [self.contentView addSubview:self.memberLabel];
}

- (void)loadDescriptionLabel {
    self.descriptionLabel = [UILabel labelWithText:@"Description:"];
    self.descriptionLabel.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
    [self.contentView addSubview:self.descriptionLabel];
    
    self.descriptionDataLabel = [UILabel labelWithText:self.pitch.pitchDescription];
    self.descriptionDataLabel.numberOfLines = 0;
    self.descriptionDataLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentView addSubview:self.descriptionDataLabel];
}

- (void)loadVoteLabel {
    self.voteLabel = [UILabel labelWithText:@"Vote:"];
    self.voteLabel.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
    [self.contentView addSubview:self.voteLabel];
}

- (void)loadVoteTableVew {
    self.voteTableView = [UITableView new];
    self.voteTableView.delegate = self;
    self.voteTableView.dataSource = self;
    self.voteTableView.scrollEnabled = NO;
    [self.voteTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"PitchVoteCell"];
    [self.contentView addSubview:self.voteTableView];
}

- (void)loadVoteButton {
    self.voteButton = [UIButton new];
    [self.voteButton addTarget:self action:@selector(submitVote) forControlEvents:UIControlEventTouchUpInside];
    [self.voteButton setTitle:@"Vote" forState:UIControlStateNormal];
    [self.voteButton setBackgroundImage:[UIImage imageWithColor:[UIColor KTPGreen363]] forState:UIControlStateNormal];
    [self.voteButton setBackgroundImage:[UIImage imageWithColor:[[UIColor KTPGreen363] colorWithAlphaComponent:0.5]] forState:UIControlStateHighlighted];
    // highlight lags probably due to passing down the touch to the button view layer
    [self.contentView addSubview:self.voteButton];
}

- (void)submitVote {
    NSLog(@"vote");
}

- (void)autoLayoutSubviews {
    
    for (UIView *view in self.contentView.subviews) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    NSDictionary *views = @{
                            @"titleLabel"           :   self.titleLabel,
                            @"memberLabel"          :   self.memberLabel,
                            @"descriptionLabel"     :   self.descriptionLabel,
                            @"descriptionDataLabel" :   self.descriptionDataLabel,
                            @"voteLabel"            :   self.voteLabel,
                            @"voteTableView"        :   self.voteTableView,
                            @"voteButton"           :   self.voteButton
                            };
    
    NSDictionary *metrics = @{
                              @"voteTableViewHeight"    :  [NSNumber numberWithFloat:[self.voteTableView numberOfRowsInSection:0] * kStandardTableViewCellHeight]
                              };
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[titleLabel]-10-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[titleLabel]-[memberLabel]-30-[descriptionLabel]-[descriptionDataLabel]-30-[voteLabel]" options:NSLayoutFormatAlignAllLeft metrics:nil views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[memberLabel]-10-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[descriptionLabel]-10-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[descriptionDataLabel]-10-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[voteLabel]-10-|" options:0 metrics:nil views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[voteTableView]-0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[voteLabel]-5-[voteTableView(voteTableViewHeight)]" options:0 metrics:metrics views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[voteButton]-10-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[voteTableView]-10-[voteButton(50)]" options:0 metrics:nil views:views]];
    
}

#pragma mark - Vote TableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;   // 3 categories to vote in
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PitchVoteCell" forIndexPath:indexPath];
    
    UILabel *label = [UILabel labelWithText:@"5"];
    [label sizeToFit];
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Innovation Score";
            if (!self.innovationScoreLabel) {
                self.innovationScoreLabel = label;
            }
            cell.accessoryView = self.innovationScoreLabel;
            break;
        case 1:
            cell.textLabel.text = @"Usefulness Score";
            if (!self.usefulnessScoreLabel) {
                self.usefulnessScoreLabel = label;
            }
            cell.accessoryView = self.usefulnessScoreLabel;
            break;
        case 2:
            cell.textLabel.text = @"Coolness Score";
            if (!self.coolnessScoreLabel) {
                self.coolnessScoreLabel = label;
            }
            cell.accessoryView = self.coolnessScoreLabel;
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            [self showPickerForScoreLabel:self.innovationScoreLabel];
            break;
        case 1:
            [self showPickerForScoreLabel:self.usefulnessScoreLabel];
            break;
        case 2:
            [self showPickerForScoreLabel:self.coolnessScoreLabel];
            break;
        default:
            break;
    }
}

- (void)showPickerForScoreLabel:(UILabel*)label {
    NSArray *scoreChoices = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10"];
    
    ActionSheetStringPicker *picker = [[ActionSheetStringPicker alloc]
                                       initWithTitle:@"Select Score"
                                       rows:scoreChoices
                                       initialSelection:[scoreChoices indexOfObject:label.text]
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           label.text = selectedValue;
                                       }
                                       cancelBlock:nil
                                       origin:label];
    [picker showActionSheetPicker];
    
    CGFloat pickerHeight = picker.toolbar.frame.size.height + picker.pickerView.frame.size.height;

    CGRect labelFrame = [label convertRect:label.frame toCoordinateSpace:self.view];
    if (self.view.frame.size.height - pickerHeight < labelFrame.origin.y + labelFrame.size.height) {
        // picker is covering the selected label
    }
}

@end
