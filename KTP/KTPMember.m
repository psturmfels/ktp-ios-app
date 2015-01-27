//
//  KTPMember.m
//  KTP
//
//  Created by Owen Yang on 11/13/14.
//  Copyright (c) 2014 Kappa Theta Pi. All rights reserved.
//

#import "KTPMember.h"
#import "KTPSMembers.h"
#import "KTPNetworking.h"

@implementation KTPMember

#pragma mark - Initialization and Creation

- (instancetype)initWithFirstName:(NSString*)firstName
                         lastName:(NSString*)lastName
                         uniqname:(NSString*)uniqname
                           gender:(NSString*)gender
                            major:(NSString*)major
                         hometown:(NSString*)hometown
                        biography:(NSString*)biography
                      pledgeClass:(NSString*)pledgeClass
                           status:(NSString*)status
                             role:(NSString*)role
                         gradYear:(NSInteger)gradYear
                     proDevEvents:(NSInteger)proDevEvents
                     comServHours:(CGFloat)comServHours
                       committees:(NSArray*)committees
                      phoneNumber:(NSString*)phoneNumber
                            email:(NSString*)email
                          account:(NSString*)account
                              _id:(NSString*)_id
                              __v:(NSString*)__v
{
    self = [super init];
    if (self) {
        self.firstName = firstName;
        self.lastName = lastName;
        self.uniqname = uniqname;
        self.gender = gender;
        self.major = major;
        self.hometown = hometown;
        self.biography = biography;
        self.pledgeClass = pledgeClass;
        self.status = status;
        self.role = role;
        self.gradYear = gradYear;
        self.proDevEvents = proDevEvents;
        self.comServHours = comServHours;
        self.committees = committees;
        self.phoneNumber = phoneNumber;
        self.email = email;
        self.account = account;
        self._id = _id;
        self.__v = __v;
    }
    return self;
}

+ (instancetype)memberWithFirstName:(NSString *)firstName lastName:(NSString *)lastName {
    for (KTPMember *member in [KTPSMembers members].membersArray) {
        if ([member.firstName isEqualToString:firstName] &&
            [member.lastName isEqualToString:lastName]) {
            return member;
        }
    }
    return nil;
}

+ (instancetype)memberWithUniqname:(NSString *)uniqname {
    for (KTPMember *member in [KTPSMembers members].membersArray) {
        if ([member.uniqname isEqualToString:uniqname]) {
            return member;
        }
    }
    return nil;
}

+ (instancetype)memberWithID:(NSString*)ID {
    for (KTPMember *member in [KTPSMembers members].membersArray) {
        if ([member._id isEqualToString:ID]) {
            return member;
        }
    }
    return nil;
}

+ (instancetype)memberWithAccount:(NSString*)account {
    for (KTPMember *member in [KTPSMembers members].membersArray) {
        if ([member.account isEqualToString:account]) {
            return member;
        }
    }
    return nil;
}

#pragma mark - Update

- (void)update {
    [KTPNetworking sendAsynchronousRequestType:KTPRequestTypePUT toRoute:KTPRequestRouteAPIMembers appending:self._id parameters:nil withBody:[self JSONObject] block:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Update Failed"
                                                            message:@"Member information was not updated"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }];
}

/*!
 Returns a JSON object with all editable properties of a KTPMember
 
 @returns       The JSON object as an NSDictionary
 */
- (NSDictionary*)JSONObject {
    // INCOMPLETE IMPLEMENTATION
    // Need to add committees, main_committee
    return @{
             @"first_name"          :   self.firstName,
             @"last_name"           :   self.lastName,
             @"uniqname"            :   self.uniqname,
             @"year"                :   [NSNumber numberWithInteger:self.gradYear],
             @"gender"              :   self.gender,
             @"major"               :   self.major,
             @"hometown"            :   self.hometown,
             @"biography"           :   self.biography,
             @"pledge_class"        :   self.pledgeClass,
             @"membership_status"   :   self.status,
             @"role"                :   self.role,
             @"pro_dev_events"      :   [NSNumber numberWithInteger:self.proDevEvents],
             @"service_hours"       :   [NSNumber numberWithFloat:self.comServHours],
             @"phone_number"        :   self.phoneNumber,
             @"email"               :   self.email
             };
}

@end
