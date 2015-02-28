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

@property (nonatomic, readonly)  CGFloat totalPointsEarned; // calculated with sum of points earned on each task
@property (nonatomic, readwrite) CGFloat totalPointsNeeded; // default is 500

+ (KTPSPledgeTasks *)pledgeTasks;
- (void)reloadPledgeTasks;

@end
