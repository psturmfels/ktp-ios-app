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

+ (KTPSUser *)currentUser;

/*!
 Asynchronously logs in the user with their provided username and password. When the user is logged in or if an error occurred, block is called with the appropriate arguments.
 
 @param         username
 @param         password
 @param         block
 */
- (void)loginWithUsername:(NSString *)username password:(NSString *)password block:(void (^)(BOOL successful, NSError *error))block;

/*!
 Synchronously logs in the user if they have a valid session active. When the user is logged in or if an error occurred, block is called with the appropriate arguments.
 
 @param         block
 */
- (void)loginWithSession:(void (^)(BOOL successful, NSError *error))block;

/*!
 Logs out the user
 */
- (void)logout;

@end
