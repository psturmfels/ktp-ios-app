//
//  KTPProfileViewController.h
//  KTP
//
//  Created by Owen Yang on 1/24/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KTPMember;

@interface KTPProfileViewController : UIViewController

@property (nonatomic, strong) KTPMember *member;

/*!
 Initializes this class with a KTPMember.
 
 @param         member
 @returns       A KTPProfileViewController object
 */
- (instancetype)initWithMember:(KTPMember*)member;
@end
