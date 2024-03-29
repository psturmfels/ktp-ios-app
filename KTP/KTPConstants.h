//
//  KTPConstants.h
//  KTP
//
//  Created by Owen Yang on 1/23/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 KTPConstants contains all global constants and is automatically included in every file.
 */

// Notification names
extern NSString *const KTPNotificationMembersUpdated;
extern NSString *const KTPNotificationMemberUpdated;
extern NSString *const KTPNotificationMemberUpdateFailed;
extern NSString *const KTPNotificationMemberDeleted;
extern NSString *const KTPNotificationUserLogout;
extern NSString *const KTPNotificationPitchesUpdated;
extern NSString *const KTPNotificationPitchVotedSuccess;
extern NSString *const KTPNotificationPitchVotedFailure;
extern NSString *const KTPNotificationPledgeTasksUpdated;
extern NSString *const KTPNotificationPledgeTaskUpdateFailed;
extern NSString *const KTPNotificationPledgeTasksUpdateFailed;
extern NSString *const KTPNotificationPledgeMeetingUpdateFailed;

// Session keys
extern NSString *const KTPSessionKeyLoggedInMemberID;
extern NSString *const KTPSessionKeyLastLogin;
extern NSString *const KTPSessionKeySessionIsValid;

// User settings keys
extern NSString *const KTPUserSettingsKeyUseTouchID;

// Internal settings keys
extern NSString *const KTPSettingsKeyTouchIDPrompted;

// UI element constants
extern CGFloat const kSlideAnimationDuration;
extern CGFloat const kMainViewShadowOpacity;
extern CGFloat const kStandardTableViewCellHeight;
extern CGFloat const kContentViewBottomPadding;
extern CGFloat const kLargeButtonHeight;

#define kSlideMenuWidth                 [UIScreen mainScreen].bounds.size.width * 0.8

#define KTPGreekAlphabet                @[@"Alpha", @"Beta", @"Gamma", @"Delta", @"Epsilon", @"Zeta", @"Eta", @"Theta", @"Iota", @"Kappa", @"Lambda", @"Mu", @"Nu", @"Xi", @"Omicron", @"Pi", @"Rho", @"Sigma", @"Tau", @"Upsilon", @"Phi", @"Chi", @"Psi", @"Omega"]
#define KTPStatusOptions                @[@"Eboard", @"Active", @"Inactive", @"Probation", @"Pledge", @"Alumni"]
#define KTPRoleOptions                  @[@"President", @"Vice President", @"Secretary", @"Treasurer", @"Director of Engagement", @"Director of Marketing", @"Director of Technology", @"Director of Professional Development", @"Director of Membership", @"Member", @"Pledge", @"Alumni"]

typedef NS_ENUM(NSInteger, KTPViewType) {
    KTPViewTypeMyProfile,
    KTPViewTypeMembers,
    KTPViewTypePledging,
    KTPViewTypeAnnouncements,
    KTPViewTypeSettings,
    KTPViewTypePitches
};
typedef NS_ENUM(NSInteger, KTPMembersSortType) {
    KTPMembersSortTypeFirstName,
    KTPMembersSortTypeLastName,
    KTPMembersSortTypePledgeClass,
    KTPMembersSortTypeStatus,
    KTPMembersSortTypeRole,
    KTPMembersSortTypeGradYear,
    KTPMembersSortTypeMajor
};
