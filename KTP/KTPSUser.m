//
//  KTPSUser.m
//  KTP
//
//  Created by Greg Azevedo on 8/27/14.
//  Copyright (c) 2014 Kappa Theta Pi. All rights reserved.
//

#import "KTPSUser.h"
#import "KTPSMembers.h"
#import "KTPMember.h"
#import "KTPNetworking.h"

#import <LocalAuthentication/LocalAuthentication.h>

@implementation KTPSUser

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMember) name:KTPNotificationMembersUpdated object:nil];
    }
    return self;
}

+ (KTPSUser *)currentUser {
    static KTPSUser *user;
    static dispatch_once_t userToken;
    dispatch_once(&userToken, ^{
        user = [[self alloc] init];
    });
    return user;
}

+ (KTPMember*)currentMember {
    return [KTPSUser currentUser].member;
}

+ (BOOL)currentUserIsActive {
    return [[KTPSUser currentMember].status isEqualToString:@"Active"];
}

+ (BOOL)currentUserIsPledge {
    return [[KTPSUser currentMember].status isEqualToString:@"Pledge"];
}

+ (BOOL)currentUserIsAdmin {
    return [[KTPSUser currentMember].status isEqualToString:@"Eboard"];
}

+ (BOOL)currentUserIsPresident {
    return [[KTPSUser currentMember].role isEqualToString:@"President"];
}

+ (BOOL)currentUserIsVicePresident {
    return [[KTPSUser currentMember].role isEqualToString:@"Vice President"];
}

+ (BOOL)currentUserIsSecretary {
    return [[KTPSUser currentMember].role isEqualToString:@"Secretary"];
}

+ (BOOL)currentUserIsTreasurer {
    return [[KTPSUser currentMember].role isEqualToString:@"Treasurer"];
}

+ (BOOL)currentUserIsDirTechnology {
    return [[KTPSUser currentMember].role isEqualToString:@"Director of Technology"];
}

+ (BOOL)currentUserIsDirProDev {
    return [[KTPSUser currentMember].role isEqualToString:@"Director of Professional Development"];
}

+ (BOOL)currentUserIsDirMembership {
    return [[KTPSUser currentMember].role isEqualToString:@"Director of Membership"];
}

+ (BOOL)currentUserIsDirMarketing {
    return [[KTPSUser currentMember].role isEqualToString:@"Director of Marketing"];
}

+ (BOOL)currentUserIsDirEngagement {
    return [[KTPSUser currentMember].role isEqualToString:@"Director of Engagement"];
}

- (void)loginWithUsername:(NSString *)username password:(NSString *)password block:(void (^)(BOOL successful, NSError *error))block {
    // Login is performed asynchronously
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        NSDictionary *errorUserInfo = @{@"username" : username, @"password" : password};
        NSError *error = [[NSError alloc] initWithDomain:KTPLoginErrorInvalidUsername code:-1 userInfo:errorUserInfo];    // default error
        
        // Create a block for error action
        void (^errorBlock)(NSError *error) = ^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(NO, error);
                return;
            });
        };
        
        // Breakdown username into components
        NSArray *usernameComponents = [username componentsSeparatedByString:@"@"];
        
        // Check if username is in invalid format
        if (usernameComponents.count > 2 || usernameComponents.count < 1) {
            errorBlock(error);
            return;
        }
        
        // Check if username exists
        BOOL usernameFound = NO;
        KTPMember *possibleMember;
        NSString *uniqname = usernameComponents[0];
        for (KTPMember *member in [KTPSMembers members].membersArray) {
            if ([member.uniqname isEqualToString:uniqname]) {
                usernameFound = YES;
                possibleMember = member;
                break;
            }
        }
        if (!usernameFound) {
            errorBlock(error);
            return;
        }
        
        // If a domain was entered, check if the domain is @umich.edu
        if (usernameComponents.count == 2) {
            NSString *domain = usernameComponents[1];
            if (![domain isEqualToString:@"umich.edu"]) {
                errorBlock(error);
                return;
            }
        }
        
        // Check if password is correct for this user
        [KTPNetworking sendAsynchronousRequestType:KTPRequestTypePOST
                                           toRoute:KTPRequestRouteAPILogin
                                         appending:nil
                                        parameters:nil
                                      withJSONBody:@{@"account"     :   possibleMember.account,
                                                     @"password"    :   password}
                                             block:^(NSURLResponse *response, NSData *data, NSError *error)
        {
            
            NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            // Check if response was valid
            if ([string isEqualToString:@"success\n"]) {
                // This point reached only if username and password were both correct
                
                // Use NSUserDefaults as session management
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:possibleMember._id forKey:KTPSessionKeyLoggedInMemberID];
                [self login:block];
            } else {
                NSError *error = [[NSError alloc] initWithDomain:KTPLoginErrorInvalidPassword code:-1 userInfo:errorUserInfo];
                errorBlock(error);
                return;
            }
        }];
    });
}

- (void)loginWithSession:(void (^)(BOOL, NSError *))block {
    
    // Use NSUserDefaults as session management
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDate *lastLogin = [defaults objectForKey:KTPSessionKeyLastLogin];
    
    // Check if user is not logged in, or the time since last login has exceeded the session length
    NSTimeInterval secondsPerWeek = SESSION_LENGTH_DAYS * 24 * 60 * 60; // days * hours * minutes * seconds
    if (![defaults boolForKey:KTPSessionKeySessionIsValid] || [[NSDate date] timeIntervalSinceDate:lastLogin] > secondsPerWeek) {
        [defaults setBool:NO forKey:KTPSessionKeySessionIsValid];
        if (block) {
            block(NO, [NSError errorWithDomain:KTPLoginErrorTouchIDFailed code:-1 userInfo:nil]);
        }
        return;
    } else {
        [self login:block];
    }
}

- (void)loginWithTouchID:(void (^)(BOOL, NSError *))block {
    
    LAContext *context = [LAContext new];
    NSError *error = nil;
    
    // Use NSUserDefaults as session management
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults boolForKey:KTPUserSettingsKeyUseTouchID] &&
        [[defaults objectForKey:KTPSessionKeyLoggedInMemberID] isNotNilOrEmpty] &&
        [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"Authenticate to log into your KTP Account" reply:^(BOOL success, NSError *error) {
            if (success) {
                [self login:block];
            } else {
                if (block) {
                    block(NO, [NSError errorWithDomain:KTPLoginErrorTouchIDFailed code:-1 userInfo:nil]);
                }
            }
        }];
    } else {
        block(NO, [NSError errorWithDomain:KTPLoginErrorLoginFailed code:-1 userInfo:nil]);
    }
}

- (void)login:(void (^)(BOOL, NSError *))block {
    self.loggedIn = YES;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSDate date] forKey:KTPSessionKeyLastLogin];
    [defaults setBool:YES forKey:KTPSessionKeySessionIsValid];
    [defaults synchronize];
    [self updateMember];
    
    if (block) {
        block(YES, nil);
    }
}

- (void)logout {
    // Use NSUserDefaults as session management
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:KTPSessionKeySessionIsValid];
    self.loggedIn = NO;
    self.member = nil;
    
    // Send notification to app that user has logged out
    [[NSNotificationCenter defaultCenter] postNotificationName:KTPNotificationUserLogout object:self];
}

/*!
 Updates the member associated with this user. Usually called when updates are made to the member data maintained in KTPSMembers.
 */
- (void)updateMember {
    self.member = [KTPMember memberWithID:[[NSUserDefaults standardUserDefaults] stringForKey:KTPSessionKeyLoggedInMemberID]];
}

@end

NSString *const KTPLoginErrorInvalidUsername    = @"KTPLoginErrorInvalidUsername";
NSString *const KTPLoginErrorInvalidPassword    = @"KTPLoginErrorInvalidPassword";
NSString *const KTPLoginErrorInvalidSession     = @"KTPLoginErrorInvalidSession";
NSString *const KTPLoginErrorTouchIDFailed      = @"KTPLoginErrorTouchIDFailed";
NSString *const KTPLoginErrorLoginFailed        = @"KTPLoginErrorLoginFailed";
