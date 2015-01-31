//
//  KTPPitchVoteViewController.h
//  KTP
//
//  Created by Owen Yang on 1/29/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KTPPitch;

@interface KTPPitchVoteViewController : UIViewController

@property (nonatomic, strong) KTPPitch *pitch;

- (instancetype)initWithPitch:(KTPPitch*)pitch;

@end
