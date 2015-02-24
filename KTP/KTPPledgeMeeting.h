//
//  KTPPledgeMeeting.h
//  KTP
//
//  Created by Owen Yang on 2/6/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KTPMember;

@interface KTPPledgeMeeting : NSObject

@property (nonatomic, strong) NSString *_id;
@property (nonatomic, strong) KTPMember *pledge;
@property (nonatomic, strong) KTPMember *active;
@property (nonatomic) BOOL complete;

- (instancetype)initWithActive:(KTPMember*)active pledge:(KTPMember*)pledge complete:(BOOL)complete _id:(NSString*)_id;

/*!
 Update's this pledge meeting's information in the database. Calls block after update is complete.
 */
- (void)update:(void (^)(BOOL successful))block;

@end
