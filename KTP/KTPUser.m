//
//  KTPUser.m
//  KTP
//
//  Created by Greg Azevedo on 8/27/14.
//  Copyright (c) 2014 Kappa Theta Pi. All rights reserved.
//

#import "KTPUser.h"

@implementation KTPUser

+ (KTPUser *)currentUser {
    static KTPUser *user;
    static dispatch_once_t userToken;
    dispatch_once(&userToken, ^{
        user = [[self alloc] init];
    });
    return user;
}

- (void)loginWithUsername:(NSString *)username password:(NSString *)password block:(void (^)(BOOL successful))block {
    // implement login logic here
    
    // test data, change for login logic
    self.loggedIn = YES;
    block(YES);
}

@end
