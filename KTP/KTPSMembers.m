//
//  KTPSMembers.m
//  KTP
//
//  Created by Owen Yang on 1/22/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPSMembers.h"
#import "KTPMember.h"
#import "KTPNetworking.h"

@implementation KTPSMembers

+ (KTPSMembers *)members {
    static KTPSMembers *members;
    static dispatch_once_t membersToken;
    dispatch_once(&membersToken, ^{
        members = [self new];
    });
    return members;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self reloadMembers];
    }
    return self;
}

- (void)reloadMembers {
    // Requests all members sorted by first_name in ascending order
    [KTPNetworking sendAsynchronousRequestType:KTPRequestTypeGET toRoute:KTPRequestRouteAPIMembers appending:nil parameters:@"sort=first_name" withBody:nil block:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (!error) {
            NSError *error;
            NSArray *members = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            if (!error) {
                NSLog(@"%@", members[0]);
                [self loadMembers:members];
            }
        } else {
            NSLog(@"member fetch failed with error:\n%@", error.userInfo);
        }
    }];
}

/*!
 Loads members from an array of JSON dictionaries to the membersArray property.

 @param         members     The array of JSON dictionaries storing members' data
 */
- (void)loadMembers:(NSArray*)members {
    self.membersArray = [NSMutableArray new];
    for (NSDictionary *dict in members) {
        [self.membersArray addObject:[[KTPMember alloc] initWithFirstName:dict[@"first_name"]
                                                                 lastName:dict[@"last_name"]
                                                                 uniqname:dict[@"uniqname"]
                                                                    image:dict[@"image"]
                                                                   gender:dict[@"gender"]
                                                                    major:dict[@"major"]
                                                                 hometown:dict[@"hometown"]
                                                                biography:dict[@"biography"]
                                                              pledgeClass:dict[@"pledge_class"]
                                                                   status:dict[@"membership_status"]
                                                                     role:dict[@"role"]
                                                                 gradYear:[(NSNumber*)dict[@"year"] integerValue]
                                                             proDevEvents:[(NSNumber*)dict[@"pro_dev_events"] integerValue]
                                                             comServHours:[(NSNumber*)dict[@"service_hours"] floatValue]
                                                               committees:dict[@"committees"]
                                                              phoneNumber:dict[@"phone_number"]
                                                                    email:dict[@"email"]
                                                                 facebook:dict[@"facebook"]
                                                                  twitter:dict[@"twitter"]
                                                                 linkedIn:dict[@"linkedin"]
                                                             personalSite:dict[@"personal_site"]
                                                                  account:dict[@"account"]
                                                                      _id:dict[@"_id"]
                                                                      __v:dict[@"__v"]]];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:KTPNotificationMembersUpdated object:self];
}

@end
