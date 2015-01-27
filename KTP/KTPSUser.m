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

@implementation KTPSUser

+ (KTPSUser *)currentUser {
    static KTPSUser *user;
    static dispatch_once_t userToken;
    dispatch_once(&userToken, ^{
        user = [[self alloc] init];
    });
    return user;
}

- (void)loginWithUsername:(NSString *)username password:(NSString *)password block:(void (^)(BOOL successful, NSError *error))block {
    // Login is performed asynchronously
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        NSDictionary *errorUserInfo = @{@"username" : username, @"password" : password};
        NSError *error = [[NSError alloc] initWithDomain:@"KTPInvalidUsernameError" code:-1 userInfo:errorUserInfo];    // default error
        
        // Create a block for error action
        void (^errorBlock)(NSError *error) = ^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(NO, error);
                return;
            });
        };
        
        // Breakdown username into components
        NSArray *usernameComponents = [username componentsSeparatedByString:@"@"];
        
        /* Check if username is in invalid format */
        if (usernameComponents.count > 2 || usernameComponents.count < 1) {
            errorBlock(error);
            return;
        }
        
        /* Check if username exists */
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
        
        /* If a domain was entered, check if the domain is @umich.edu */
        if (usernameComponents.count == 2) {
            NSString *domain = usernameComponents[1];
            if (![domain isEqualToString:@"umich.edu"]) {
                errorBlock(error);
                return;
            }
        }
        
        /* Check if password is correct for this user */
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://kappathetapi.com/api/login"]];
        request.HTTPMethod = @"POST";
        request.allHTTPHeaderFields = @{@"x-access-token"   : @"5af9a24515589a73d0fa687e69cbaaa15918f833",
                                        @"Content-Type"     : @"application/json"};
        NSDictionary *body = @{@"account"     :   possibleMember.account,
                               @"password"    :   password};
        request.HTTPBody = [NSJSONSerialization dataWithJSONObject:body options:0 error:nil];   // NEEDS TO HANDLE ERROR
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
            NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            // Check if response was valid
            if ([string isEqualToString:@"account not found\n"] || [string isEqualToString:@"invalid password\n"]) {
                NSError *error = [[NSError alloc] initWithDomain:@"KTPInvalidPasswordError" code:-1 userInfo:errorUserInfo];
                errorBlock(error);
                return;
            } else if (![string isEqualToString:@"success\n"]) {
                // should never reach
                NSLog(@"THIS SHOULD NOT HAVE PRINTED");
            }
            
            /* This point reached only if username and password were both correct */
            // Use NSUserDefaults as session management
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:possibleMember._id forKey:@"loggedInMemberId"];
            [defaults setObject:[NSDate date] forKey:@"lastLogin"];
            [defaults synchronize];
            self.member = [KTPMember memberWithUniqname:uniqname];
            
            self.loggedIn = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                block(YES, nil);
            });
        }];
    });
}

- (void)loginWithSession:(void (^)(BOOL, NSError *))block {
    
    // Use NSUserDefaults as session management
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *loggedInMemberId = [defaults stringForKey:@"loggedInMemberId"];
    NSDate *lastLogin = [defaults objectForKey:@"lastLogin"];
    
    // Check if user is not logged in, or the time since last login has exceeded the session length
    NSTimeInterval secondsPerWeek = SESSION_LENGTH_DAYS * 24 * 60 * 60; // days * hours * minutes * seconds
    if (!loggedInMemberId || [loggedInMemberId isEqualToString:@""] || [[NSDate date] timeIntervalSinceDate:lastLogin] > secondsPerWeek) {
        [defaults setObject:nil forKey:@"loggedInMemberId"];
        if (block) {
            block(NO, [NSError errorWithDomain:@"KTPSessionEndedError" code:-1 userInfo:nil]);
        }
        return;
    }
    
    /* This point reached only if session is valid */
    [defaults setObject:[NSDate date] forKey:@"lastLogin"];
    [defaults synchronize];
    self.member = [KTPMember memberWithID:loggedInMemberId];
    
    self.loggedIn = YES;
    if (block) {
        block(YES, nil);
    }
}

- (void)logout {
    // Use NSUserDefaults as session management
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:@"loggedInMemberId"];
    self.loggedIn = NO;
    self.member = nil;
    
    // Send notification to app that user has logged out
    [[NSNotificationCenter defaultCenter] postNotificationName:KTPNotificationUserLogout object:self];
}

@end
