//
//  KTPSMembers.m
//  KTP
//
//  Created by Owen Yang on 1/22/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPSMembers.h"
#import "KTPMember.h"

#define AUTHKEY @"5af9a24515589a73d0fa687e69cbaaa15918f833"

@interface KTPSMembers ()

@property (nonatomic, strong) NSMutableData *membersData;

@end

@implementation KTPSMembers

+ (KTPSMembers *)members {
    static KTPSMembers *members;
    static dispatch_once_t membersToken;
    dispatch_once(&membersToken, ^{
        members = [[self alloc] init];
    });
    return members;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self fetchMembers];
    }
    return self;
}

/*!
 Sends an asynchronous request to the KTP api for all member data. Calls loadMembers when request is complete.
 */
- (void)fetchMembers {
    self.membersData = [NSMutableData new];
    
    // Creates a URL that requests all members sorted by first_name in ascending order
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://kappathetapi.com/api/members?t=%@&sort=first_name", AUTHKEY]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.allHTTPHeaderFields = @{@"x-access-token" : AUTHKEY};
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!connectionError) {
            NSError *error;
            NSArray *members = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSLog(@"%@", members[0]);
            [self loadMembers:members];
        } else {
            NSLog(@"member fetch failed with error:\n%@", connectionError.userInfo);
        }
    }];
}

/*!
 Loads members from an array of JSON dictionaries to the membersArray property. Each JSON object in the members array should have the following structure:
 {
    __v
    _id
    account
    committees
    gender
    major
    name
        {
            first
            last
            uniqname
        }
    pledge_class
    pro_dev_events
    service_hours
    year
 }
 
 @param         members
 */
- (void)loadMembers:(NSArray*)members {
    self.membersArray = [NSMutableArray arrayWithCapacity:members.count];
    int i = 0;
    for (NSDictionary *dict in members) {
        self.membersArray[i] = [[KTPMember alloc] initWithFirstName:dict[@"first_name"]
                                                           lastName:dict[@"last_name"]
                                                           uniqname:dict[@"uniqname"]
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
                                                            account:dict[@"account"]
                                                                _id:dict[@"_id"]
                                                                __v:dict[@"__v"]];
        ++i;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:KTPNotificationMembersUpdated object:self];
    
    // DEBUG
//    KTPMember *member = self.membersArray[0];
//    NSLog(@"%@\n%@\n%@\n%@\n%@\n%@\n%ld\n%ld\n%f\n%@\n%@\n%@\n%@", member.firstName, member.lastName, member.uniqname, member.gender, member.major, member.pledgeClass, (long)member.gradYear, (long)member.proDevEvents, member.comServHours, member.committees, member.account, member._id, member.__v);
}

@end
