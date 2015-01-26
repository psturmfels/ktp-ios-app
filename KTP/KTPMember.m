//
//  KTPMember.m
//  KTP
//
//  Created by Owen Yang on 11/13/14.
//  Copyright (c) 2014 Kappa Theta Pi. All rights reserved.
//

#import "KTPMember.h"
#import "KTPSMembers.h"

@implementation KTPMember

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

+ (instancetype)memberWithAccount:(NSString*)account {
    for (KTPMember *member in [KTPSMembers members].membersArray) {
        if ([member.account isEqualToString:account]) {
            return member;
        }
    }
    return nil;
}

@end
