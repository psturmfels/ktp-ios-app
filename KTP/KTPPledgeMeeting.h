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

@property (nonatomic, strong) KTPMember *pledge;
@property (nonatomic, strong) KTPMember *active;
@property (nonatomic) BOOL completed;

@end
