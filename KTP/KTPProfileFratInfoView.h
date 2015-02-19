//
//  KTPProfileFratInfoView.h
//  KTP
//
//  Created by Kate Findlay on 2/17/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KTPProfileFratInfoView : UIView

@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *statusDataLabel;
@property (nonatomic, strong) UILabel *roleLabel;
@property (nonatomic, strong) UILabel *roleDataLabel;
@property (nonatomic, strong) UILabel *pledgeClassLabel;
@property (nonatomic, strong) UILabel *pledgeClassDataLabel;
@property (nonatomic, strong) CALayer *baseLayer;
@property (nonatomic, strong) CALayer *border;

@end
