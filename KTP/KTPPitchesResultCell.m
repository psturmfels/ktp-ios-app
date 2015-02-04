//
//  KTPPitchesResultCell.m
//  KTP
//
//  Created by Owen Yang on 2/3/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPPitchesResultCell.h"
#import "KTPPitch.h"
#import "KTPMember.h"
#import "KTPPitchVote.h"

@interface KTPPitchesResultCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *memberLabel;

@property (nonatomic, strong) UILabel *innovationScoreLabel;
@property (nonatomic, strong) UILabel *usefulnessScoreLabel;
@property (nonatomic, strong) UILabel *coolnessScoreLabel;
@property (nonatomic, strong) UILabel *overallScoreLabel;

@end

@implementation KTPPitchesResultCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadLabels];
    }
    return self;
}

- (void)loadLabels {
    UIFont *smallFont = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.numberOfLines = 3;
    
    self.memberLabel = [UILabel new];
    self.memberLabel.font = smallFont;
    self.innovationScoreLabel = [UILabel new];
    self.innovationScoreLabel.font = smallFont;
    self.innovationScoreLabel.textAlignment = NSTextAlignmentRight;
    self.usefulnessScoreLabel = [UILabel new];
    self.usefulnessScoreLabel.font = smallFont;
    self.usefulnessScoreLabel.textAlignment = NSTextAlignmentRight;
    self.coolnessScoreLabel = [UILabel new];
    self.coolnessScoreLabel.font = smallFont;
    self.coolnessScoreLabel.textAlignment = NSTextAlignmentRight;
    self.overallScoreLabel = [UILabel new];
    self.overallScoreLabel.font = [UIFont boldSystemFontOfSize:smallFont.pointSize];
    self.overallScoreLabel.textAlignment = NSTextAlignmentRight;
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.memberLabel];
    [self.contentView addSubview:self.innovationScoreLabel];
    [self.contentView addSubview:self.usefulnessScoreLabel];
    [self.contentView addSubview:self.coolnessScoreLabel];
    [self.contentView addSubview:self.overallScoreLabel];
}

- (void)setPitch:(KTPPitch *)pitch {
    if (_pitch != pitch) {
        _pitch = pitch;
        
        self.titleLabel.text = pitch.pitchTitle;
        self.memberLabel.text = [NSString stringWithFormat:@"%@ %@", pitch.member.firstName, pitch.member.lastName];
        
        self.innovationScoreLabel.text = [NSString stringWithFormat:@"Innovation: %2.2f", pitch.innovationScore];
        self.usefulnessScoreLabel.text = [NSString stringWithFormat:@"Usefulness: %2.2f", pitch.usefulnessScore];
        self.coolnessScoreLabel.text = [NSString stringWithFormat:@"Coolness: %2.2f", pitch.coolnessScore];
        self.overallScoreLabel.text = [NSString stringWithFormat:@"Overall: %2.2f", pitch.overallScore];
        
        [self autoLayoutSubviews];
    }
}

- (void)autoLayoutSubviews {
    for (UIView *view in self.contentView.subviews) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    NSDictionary *views = @{
                            @"titleLabel"               :   self.titleLabel,
                            @"memberLabel"              :   self.memberLabel,
                            @"innovationScoreLabel"     :   self.innovationScoreLabel,
                            @"usefulnessScoreLabel"     :   self.usefulnessScoreLabel,
                            @"coolnessScoreLabel"       :   self.coolnessScoreLabel,
                            @"overallScoreLabel"        :   self.overallScoreLabel
                            };
    
    /* titleLabel, memberLabel */
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[titleLabel]" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[titleLabel]-0-[memberLabel]-(>=5)-|" options:NSLayoutFormatAlignAllLeft metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[memberLabel]-10-[innovationScoreLabel]" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[titleLabel]-10-[innovationScoreLabel(100)]-10-|" options:NSLayoutFormatAlignAllTop metrics:nil views:views]];
    
    /* innovationScoreLabel, usefulnessScoreLabel, coolnessScoreLabel, overallScoreLabel */
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[innovationScoreLabel]-0-[usefulnessScoreLabel]-0-[coolnessScoreLabel]-10-[overallScoreLabel]" options:NSLayoutFormatAlignAllRight metrics:nil views:views]];
}



@end
