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

extern NSString *const KTPNotificationMembersUpdated;
extern NSString *const KTPNotificationMemberUpdateFailed;
extern NSString *const KTPNotificationUserLogout;

#define kSlideMenuWidth                 [UIScreen mainScreen].bounds.size.width * 0.8
#define kSlideAnimationDuration         0.2
#define kMainViewShadowOpacity          0.8

typedef NS_ENUM(NSInteger, KTPViewType) {
    KTPViewTypeMembers,
    KTPViewTypePledge,
    KTPViewTypeAnnouncements,
    KTPViewTypeSettings
};