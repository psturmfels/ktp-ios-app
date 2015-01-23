//
//  KTPMember.h
//  KTP
//
//  Created by Owen Yang on 11/13/14.
//  Copyright (c) 2014 Kappa Theta Pi. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @class         KTPMember
 @description   The KTPMember class encapsulates all information for a member of KTP. It also provides several class methods to return members with certain properties.
 */
@interface KTPMember : NSObject

@property (nonatomic, strong)   NSString    *firstName;
@property (nonatomic, strong)   NSString    *lastName;
@property (nonatomic, strong)   NSString    *uniqname;
@property (nonatomic, strong)   NSString    *gender;
@property (nonatomic, strong)   NSString    *major;

@property (nonatomic, strong)   NSString    *pledgeClass;
@property (nonatomic)           NSInteger   gradYear;
@property (nonatomic)           NSInteger   proDevEvents;
@property (nonatomic)           CGFloat     comServHours;
@property (nonatomic, strong)   NSArray     *committees;

@property (nonatomic, strong)   NSString    *account;
@property (nonatomic, strong)   NSString    *_id;
@property (nonatomic, strong)   NSString    *__v;
//@property (nonatomic, strong)   UIImage     *image;

/*!
 Creates a KTPMember object with all provided properties.
 
 @param         firstName
 @param         lastName
 @param         uniqname
 @param         gender
 @param         major
 @param         pledgeClass
 @param         gradYear
 @param         proDevEvents
 @param         comServHours
 @param         committees
 @param         account
 @param         _id
 @param         __v
 @returns       A KTPMember object.
 */
- (instancetype)initWithFirstName:(NSString*)firstName
                         lastName:(NSString*)lastName
                         uniqname:(NSString*)uniqname
                           gender:(NSString*)gender
                            major:(NSString*)major
                      pledgeClass:(NSString*)pledgeClass
                         gradYear:(NSInteger)gradYear
                     proDevEvents:(NSInteger)proDevEvents
                     comServHours:(CGFloat)comServHours
                       committees:(NSArray*)committees
                          account:(NSString*)account
                              _id:(NSString*)_id
                              __v:(NSString*)__v;

/*!
 Returns a KTPMember object with the given first and last name. If no such member exists, this method returns nil.
 
 @param         firstName
 @param         lastName
 @returns       The KTPMember object with the given first and last name, or nil if not found.
 */
+ (instancetype)memberWithFirstName:(NSString*)firstName lastName:(NSString*)lastName;

/*!
 Returns a KTPMember object with the given uniqname. If no such member exists, this method returns nil.
 
 @param         uniqname
 @returns       The KTPMember object with the given uniqname, or nil if not found.
 */
+ (instancetype)memberWithUniqname:(NSString*)uniqname;


@end
