//
//  KTPPitchVoteViewController.m
//  KTP
//
//  Created by Owen Yang on 1/29/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPPitchVoteViewController.h"
#import "KTPPitch.h"
#import "KTPPitchVote.h"
#import "KTPMember.h"
#import "KTPSUser.h"

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
@property (nonatomic, strong) UIView *voteTableViewMask;
@property (nonatomic, strong) UIButton *voteButton;

@property (nonatomic, strong) UILabel *innovationScoreLabel;
@property (nonatomic, strong) UILabel *usefulnessScoreLabel;
@property (nonatomic, strong) UILabel *coolnessScoreLabel;

@property (nonatomic, strong) KTPPitchVote *userVote;
@end

@implementation KTPPitchVoteViewController

#pragma mark - Initialization

- (instancetype)initWithPitch:(KTPPitch*)pitch {
    self = [super init];
    if (self) {
        self.pitch = pitch;
        self.navigationItem.title = @"Pitch";

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userVotedSuccess:) name:KTPNotificationPitchVotedSuccess object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userVotedFailure) name:KTPNotificationPitchVotedFailure object:nil];
    }
    return self;
}

#pragma mark - Custom Setters/Getters

- (void)setPitch:(KTPPitch *)pitch {
    if (_pitch != pitch) {
        _pitch = pitch;
        for (KTPPitchVote *vote in pitch.votes) {
            if (vote.member == [KTPSUser currentMember]) {
                self.userVote = vote;
                break;
            }
        }
    }
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
    [self loadVoteTableView];
    [self loadVoteButton];
}

- (void)loadScrollView {
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.delaysContentTouches = NO;
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

- (void)loadVoteTableView {
    self.voteTableView = [UITableView new];
    self.voteTableView.delegate = self;
    self.voteTableView.dataSource = self;
    self.voteTableView.scrollEnabled = NO;
    [self.voteTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"PitchVoteCell"];
    [self.contentView addSubview:self.voteTableView];
    
    self.voteTableViewMask = [UIView new];
    self.voteTableViewMask.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    [self.contentView addSubview:self.voteTableViewMask];
    if ([self.pitch userDidVote]) {
        // user already voted, so disable tableView
        [self disableVoteTableView];
    } else {
        [self enableVoteTableView];
    }
}

- (void)enableVoteTableView {
    self.voteTableViewMask.hidden = YES;
    self.voteTableView.userInteractionEnabled = YES;
}

- (void)disableVoteTableView {
    self.voteTableViewMask.hidden = NO;
    self.voteTableView.userInteractionEnabled = NO;
}

- (void)loadVoteButton {
    self.voteButton = [UIButton new];
    
    if ([self.pitch userDidVote]) {
        // user already voted, so disable vote button
        [self disableVoteButton];
    } else {
        [self enableVoteButton];
    }
    [self.contentView addSubview:self.voteButton];
}

- (void)enableVoteButton {
    self.voteButton.enabled = YES;
    [self.voteButton addTarget:self action:@selector(submitVote) forControlEvents:UIControlEventTouchUpInside];
    [self.voteButton setTitle:@"Vote" forState:UIControlStateNormal];
    [self.voteButton setBackgroundImage:[UIImage imageWithColor:[UIColor KTPGreen363]] forState:UIControlStateNormal];
    [self.voteButton setBackgroundImage:[UIImage imageWithColor:[[UIColor KTPGreen363] colorWithAlphaComponent:0.5]] forState:UIControlStateHighlighted];
}

- (void)disableVoteButton {
    self.voteButton.enabled = NO;
    [self.voteButton setTitle:@"Voted" forState:UIControlStateNormal];
    [self.voteButton setBackgroundImage:[UIImage imageWithColor:[[UIColor KTPGreen363] colorWithAlphaComponent:0.5]] forState:UIControlStateNormal];
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
    
    // titleLabel, memberLabel, descriptionLabel, descriptionDataLabel, voteLabel
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[titleLabel]-[memberLabel]-30-[descriptionLabel]-[descriptionDataLabel]-30-[voteLabel]" options:NSLayoutFormatAlignAllLeft metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[titleLabel]-10-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[memberLabel]-10-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[descriptionLabel]-10-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[descriptionDataLabel]-10-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[voteLabel]-10-|" options:0 metrics:nil views:views]];
    
    // voteTableView, voteTableViewMask
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[voteTableView]-0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[voteLabel]-5-[voteTableView(voteTableViewHeight)]" options:0 metrics:metrics views:views]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.voteTableViewMask attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.voteTableView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.voteTableViewMask attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.voteTableView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.voteTableViewMask attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.voteTableView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.voteTableViewMask attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.voteTableView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    
    // voteButton
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[voteButton]-10-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[voteTableView]-10-[voteButton(50)]" options:0 metrics:nil views:views]];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // Get the top and bottom subviews of contentView
    UIView *topView, *bottomView;
    for (UIView *view in self.contentView.subviews) {
        if (!topView || topView.frame.origin.y > view.frame.origin.y) {
            topView = view;
        }
        if (!bottomView || bottomView.frame.origin.y + bottomView.frame.size.height < view.frame.origin.y + view.frame.size.height) {
            bottomView = view;
        }
    }
    
    // Resize contentView such that it is larger than its subviews
    CGRect frame = self.contentView.frame;
    frame.size.height = topView.frame.origin.y + bottomView.frame.origin.y + bottomView.frame.size.height + kContentViewBottomPadding;
    self.contentView.frame = frame;
    
    // Set the content size of scrollView to contentView's size
    self.scrollView.contentSize = self.contentView.frame.size;
}

#pragma mark - UITableViewDelegate methods

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

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;   // 3 categories to vote in
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PitchVoteCell" forIndexPath:indexPath];
    
    UILabel *label;
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Innovation Score";
            if (!self.innovationScoreLabel) {
                label = [UILabel labelWithText:(self.userVote ? [NSString stringWithFormat:@"%lu", (unsigned long)self.userVote.innovationScore] : @"5")];
                self.innovationScoreLabel = label;
            }
            cell.accessoryView = self.innovationScoreLabel;
            break;
        case 1:
            cell.textLabel.text = @"Usefulness Score";
            if (!self.usefulnessScoreLabel) {
                label = [UILabel labelWithText:(self.userVote ? [NSString stringWithFormat:@"%lu", (unsigned long)self.userVote.usefulnessScore] : @"5")];
                self.usefulnessScoreLabel = label;
            }
            cell.accessoryView = self.usefulnessScoreLabel;
            break;
        case 2:
            cell.textLabel.text = @"Coolness Score";
            if (!self.coolnessScoreLabel) {
                label = [UILabel labelWithText:(self.userVote ? [NSString stringWithFormat:@"%lu", (unsigned long)self.userVote.coolnessScore] : @"5")];
                self.coolnessScoreLabel = label;
            }
            cell.accessoryView = self.coolnessScoreLabel;
            break;
        default:
            break;
    }
    [label sizeToFit];
    
    return cell;
}

#pragma mark - UI action selectors

- (void)showPickerForScoreLabel:(UILabel*)label {
    NSArray *scoreChoices = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10"];
    
    ActionSheetStringPicker *picker = [[ActionSheetStringPicker alloc]
                                       initWithTitle:@"Select Score"
                                       rows:scoreChoices
                                       initialSelection:[scoreChoices indexOfObject:label.text]
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           label.text = selectedValue;
                                           [label sizeToFit];
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

- (void)submitVote {
    [self.pitch addVote:[[KTPPitchVote alloc] initWithMember:[KTPSUser currentMember]
                                             innovationScore:[self.innovationScoreLabel.text integerValue]
                                             usefulnessScore:[self.usefulnessScoreLabel.text integerValue]
                                               coolnessScore:[self.coolnessScoreLabel.text integerValue]]];
}

#pragma mark - Notification Handling

- (void)userVotedSuccess:(NSNotification*)notification {
    if (notification.object == self.pitch) {
        [self disableVoteButton];
        [self disableVoteTableView];
    }
}

- (void)userVotedFailure {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Vote Not Submitted" message:@"There was an error in submitting your vote" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
}

@end
