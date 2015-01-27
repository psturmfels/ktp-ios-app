//
//  KTPConstants.h
//  KTP
//
//  Created by Owen Yang on 1/23/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @class         KTPConstants
 @description   The KTPConstants class contains all global constants and is automatically included in every file.
 */
@interface KTPConstants : NSObject
@end

#define KTPNotificationMembersUpdated   @"KTPNotificationMembersUpdated"
#define KTPNotificationUserLogout       @"KTPNotificationUserLogout"

#define kSlideMenuWidth                 [UIScreen mainScreen].bounds.size.width * 0.8
#define kSlideAnimationDuration         0.2
#define kMainViewShadowOpacity          0.8

typedef NS_ENUM(NSInteger, KTPViewType) {
    KTPViewTypeMembers,
    KTPViewTypePledge,
    KTPViewTypeAnnouncements,
    KTPViewTypeSettings
};