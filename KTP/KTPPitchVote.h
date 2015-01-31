//
//  KTPPitchVote.h
//  KTP
//
//  Created by Owen Yang on 1/29/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KTPMember;

/*!
 @class         KTPPitchVote
 @description   The KTPPitchVote class represents a vote for a KTPPitch.
 */
@interface KTPPitchVote : NSObject

@property (nonatomic, strong) KTPMember *member;
@property (nonatomic) NSUInteger innovationScore;
@property (nonatomic) NSUInteger usefulnessScore;
@property (nonatomic) NSUInteger coolnessScore;

- (instancetype)initWithMember:(KTPMember*)member innovationScore:(NSUInteger)innovationScore usefulnessScore:(NSUInteger)usefulnessScore coolnessScore:(NSUInteger)coolnessScore;
@end
