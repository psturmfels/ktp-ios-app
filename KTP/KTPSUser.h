//
//  KTPSUser.h
//  KTP
//
//  Created by Greg Azevedo on 8/27/14.
//  Copyright (c) 2014 Kappa Theta Pi. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SESSION_LENGTH_DAYS 7

@class KTPMember;

/*!
 @class         KTPUser
 @description   The KTPUser class is a singleton that represents the current user of the app. Once logged in, the user is associated with a KTPMember object.
 */
@interface KTPSUser : NSObject

@property (nonatomic, strong) KTPMember *member;
@property (nonatomic, getter = isLoggedIn) BOOL loggedIn;

+ (KTPSUser*)currentUser;
+ (KTPMember*)currentMember;

+ (BOOL)currentUserIsAdmin;
+ (BOOL)currentUserIsActive;
+ (BOOL)currentUserIsPledge;

+ (BOOL)currentUserIsPresident;
+ (BOOL)currentUserIsVicePresident;
+ (BOOL)currentUserIsSecretary;
+ (BOOL)currentUserIsTreasurer;
+ (BOOL)currentUserIsDirTechnology;
+ (BOOL)currentUserIsDirProDev;
+ (BOOL)currentUserIsDirMembership;
+ (BOOL)currentUserIsDirMarketing;
+ (BOOL)currentUserIsDirEngagement;

/*!
 Asynchronously logs in the user with their provided username and password. When the user is logged in or if an error occurred, block is called with the appropriate arguments.
 
 @param         username    KTP account username
 @param         password    KTP account password
 @param         block       Callback after login finishes
 */
- (void)loginWithUsername:(NSString *)username password:(NSString *)password block:(void (^)(BOOL successful, NSError *error))block;

/*!
 Synchronously logs in the user if they have a valid session active. When the user is logged in or if an error occurred, block is called with the appropriate arguments.
 
 @param         block       Callback after login finishes
 */
- (void)loginWithSession:(void (^)(BOOL successful, NSError *error))block;

/*!
 Synchronously logs in the user if they have logged in before (intended to be called after verification of Touch ID). When the user is logged in or if an error occurred, block is called with the appropriate arguments.
 
 @param         block       Callback after login finishes
 */
- (void)loginWithTouchID:(void (^)(BOOL successful, NSError *error))block;

/*!
 Logs out the user
 */
- (void)logout;

@end

extern NSString *const KTPLoginErrorInvalidUsername;
extern NSString *const KTPLoginErrorInvalidPassword;
extern NSString *const KTPLoginErrorInvalidSession;
extern NSString *const KTPLoginErrorTouchIDFailed;
extern NSString *const KTPLoginErrorLoginFailed;


