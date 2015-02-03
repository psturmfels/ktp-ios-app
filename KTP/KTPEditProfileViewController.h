//
//  KTPEditProfileViewController.h
//  KTP
//
//  Created by Owen Yang on 2/2/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KTPMember;

/*!
 @class         KTPEditProfileViewController
 @description   KTPEditProfileViewController handles allowing the user to edit member information. 
 */
@interface KTPEditProfileViewController : UIViewController

@property (nonatomic, strong) KTPMember *member;

/*!
 Initializes a KTPEditProfileViewController with the specified member.
 
 @param         member      The member who's profile to edit
 @returns       An instance of KTPEditProfileViewController
 */
- (instancetype)initWithMember:(KTPMember*)member;

@end
