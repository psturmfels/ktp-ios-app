//
//  KTPUser.h
//  KTP
//
//  Created by Greg Azevedo on 8/27/14.
//  Copyright (c) 2014 Kappa Theta Pi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KTPUser : NSObject

+ (KTPUser *)currentUser;
- (void)loginWithUsername:(NSString *)username password:(NSString *)password block:(void (^)(BOOL successful))block;

@property (nonatomic, getter = isLoggedIn) BOOL loggedIn;

@end
