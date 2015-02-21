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
#import "KTPPledgeMeeting.h"

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
        self.queue = [NSOperationQueue new];
        self.sortType = (KTPMembersSortType)[[NSUserDefaults standardUserDefaults] integerForKey:@"membersSortType"];
        [self reloadMembers];
    }
    return self;
}

- (void)setSortType:(KTPMembersSortType)sortType {
    _sortType = sortType;
    [[NSUserDefaults standardUserDefaults] setInteger:sortType forKey:@"membersSortType"];
    [self sortMembers];
}

- (void)reloadMembers {
    // Requests all members sorted by first_name in ascending order
    [KTPNetworking sendAsynchronousRequestType:KTPRequestTypeGET toRoute:KTPRequestRouteAPIMembers appending:nil parameters:@"populate=meetings&sort=first_name" withJSONBody:nil block:^(NSURLResponse *response, NSData *data, NSError *error) {
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
                                                                    image:nil
                                                                 imageURL:dict[@"prof_pic_url"]
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
                                                                 meetings:nil
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
    
    int i = 0;
    for (KTPMember *member in self.membersArray) {
        NSMutableArray *meetings = [NSMutableArray new];
        for (NSDictionary *dict in members[i][@"meetings"]) {
            KTPMember *active = [KTPMember memberWithID:dict[@"active"]];
            KTPMember *pledge = [KTPMember memberWithID:dict[@"pledge"]];
            [meetings addObject:[[KTPPledgeMeeting alloc] initWithActive:active pledge:pledge complete:[dict[@"complete"] boolValue] _id:dict[@"_id"]]];
        }
        member.meetings = meetings;
        ++i;
    }
    [self sortMembers];
    [[NSNotificationCenter defaultCenter] postNotificationName:KTPNotificationMembersUpdated object:self];
}

- (void)sortMembers {
    if (self.membersArray) {
        NSSortDescriptor *firstNameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES];
        switch (self.sortType) {
            case KTPMembersSortTypeFirstName:
                self.membersArray = [[self.membersArray sortedArrayUsingDescriptors:@[firstNameSortDescriptor]] mutableCopy];
                break;
            case KTPMembersSortTypeLastName:
                self.membersArray = [[self.membersArray sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES]]] mutableCopy];
                break;
            case KTPMembersSortTypePledgeClass: {
                NSComparisonResult (^pledgeClassComparator)(id, id) = ^NSComparisonResult(id obj1, id obj2) {
                    NSInteger dif = [KTPGreekAlphabet indexOfObject:obj1] - [KTPGreekAlphabet indexOfObject:obj2];
                    return dif / ABS(dif);
                };
                self.membersArray = [[self.membersArray sortedArrayUsingDescriptors:
                                      @[[NSSortDescriptor sortDescriptorWithKey:@"pledgeClass" ascending:YES comparator:pledgeClassComparator],
                                        firstNameSortDescriptor]] mutableCopy];
                break;
            }
            case KTPMembersSortTypeStatus: {
                NSComparisonResult (^statusComparator)(id, id) = ^NSComparisonResult(id obj1, id obj2) {
                    NSInteger dif = [KTPStatusOptions indexOfObject:obj1] - [KTPStatusOptions indexOfObject:obj2];
                    return dif / ABS(dif);
                };
                self.membersArray = [[self.membersArray sortedArrayUsingDescriptors:
                                      @[[NSSortDescriptor sortDescriptorWithKey:@"status" ascending:YES comparator:statusComparator],
                                        firstNameSortDescriptor]] mutableCopy];
                break;
            }
            case KTPMembersSortTypeRole:{
                NSComparisonResult (^roleComparator)(id, id) = ^NSComparisonResult(id obj1, id obj2) {
                    NSInteger dif = [KTPRoleOptions indexOfObject:obj1] - [KTPRoleOptions indexOfObject:obj2];
                    return dif / ABS(dif);
                };
                self.membersArray = [[self.membersArray sortedArrayUsingDescriptors:
                                      @[[NSSortDescriptor sortDescriptorWithKey:@"role" ascending:YES comparator:roleComparator],
                                        firstNameSortDescriptor]] mutableCopy];
                break;
            }
            case KTPMembersSortTypeGradYear:
                self.membersArray = [[self.membersArray sortedArrayUsingDescriptors:
                                      @[[NSSortDescriptor sortDescriptorWithKey:@"gradYear" ascending:YES],
                                        firstNameSortDescriptor]] mutableCopy];
                break;
            case KTPMembersSortTypeMajor:
                self.membersArray = [[self.membersArray sortedArrayUsingDescriptors:
                                      @[[NSSortDescriptor sortDescriptorWithKey:@"major" ascending:YES],
                                        firstNameSortDescriptor]] mutableCopy];
                break;
        }
    }
}

@end
