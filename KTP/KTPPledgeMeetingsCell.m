//
//  KTPPledgeMeetingsCell.m
//  KTP
//
//  Created by Greg Azevedo on 2/16/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPPledgeMeetingsCell.h"

@interface KTPPledgeMeetingsCell ()

@property (nonatomic) UILabel *otherMemberLabel;

@end

@implementation KTPPledgeMeetingsCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.otherMemberLabel = [UILabel new];
        [self.otherMemberLabel setFrame:CGRectInset(self.bounds, 10, 10)];
        [self.contentView addSubview:self.otherMemberLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void)setOtherMember:(NSString *)otherMember {
    [self.otherMemberLabel setText:otherMember];
    _otherMember = otherMember;
}

@end
