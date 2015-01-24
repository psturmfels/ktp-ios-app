//
//  KTPSMembers.h
//  KTP
//
//  Created by Owen Yang on 1/22/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @class         KTPSMembers
 @description   The KTPSMembers class is a singleton that handles fetching and maintaining the information on all KTP members. It should be referenced (and thus initialized) as early as possible to ensure all members' data are loaded by the time they are needed.
 */
@interface KTPSMembers : NSObject

@property (nonatomic, strong) NSMutableArray *membersArray;

+ (KTPSMembers*)members;

@end