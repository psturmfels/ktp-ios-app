//
//  KTPEditProfileViewCell.m
//  KTP
//
//  Created by Kate Findlay on 2/5/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPEditProfileViewCell.h"

@implementation KTPEditProfileViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.textField = [UITextField new];
        CGRect frame = self.contentView.bounds;
        frame.origin.x += self.separatorInset.left;
        frame.size.width -= self.separatorInset.left;
        self.textField.frame = frame;
        [self.contentView addSubview:self.textField];
    }
    return self;
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
