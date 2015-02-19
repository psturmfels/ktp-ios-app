//
//  KTPProfileNameView.h
//  KTP
//
//  Created by Kate Findlay on 2/17/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KTPProfileNameView : UIView

@property (nonatomic, strong) UIImageView *profileImageView;
@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) CALayer *border;
@property (nonatomic, strong) CALayer *baseLayer;

@end
