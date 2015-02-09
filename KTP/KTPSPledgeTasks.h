//
//  KTPSPledgeTasks.h
//  KTP
//
//  Created by Owen Yang on 2/6/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KTPSPledgeTasks : NSObject

@property (nonatomic, strong) NSMutableArray *pledgeTasksArray; // Object type: KTPPledgeTask

+ (KTPSPledgeTasks *)pledgeTasks;
- (void)reloadPledgeTasks;

@end
