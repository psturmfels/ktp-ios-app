//
//  KTPPledgeTask.h
//  KTP
//
//  Created by Owen Yang on 2/6/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KTPPledgeTask : NSObject

@property (nonatomic, strong)   NSString *_id;
@property (nonatomic, strong)   NSString *taskTitle;
@property (nonatomic, strong)   NSString *taskDescription;
@property (nonatomic, strong)   NSString *proof;
@property (nonatomic)           CGFloat points;
@property (nonatomic)           CGFloat pointsEarned;
@property (nonatomic)           NSUInteger minimumPledges;
@property (nonatomic)           BOOL repeatable;
@property (nonatomic, strong)   NSMutableArray *pledges;    // Object type: KTPMember

- (instancetype)initWithTitle:(NSString*)title
                  description:(NSString*)description
                        proof:(NSString*)proof
                       points:(CGFloat)points
                 pointsEarned:(CGFloat)pointsEarned
               minimumPledges:(NSUInteger)minimumPledges
                   repeatable:(BOOL)repeatable
                      pledges:(NSMutableArray*)pledges
                          _id:(NSString*)_id;

@end
