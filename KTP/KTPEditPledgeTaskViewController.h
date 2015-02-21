//
//  KTPEditPledgeTaskViewController.h
//  KTP
//
//  Created by Owen Yang on 2/21/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KTPPledgeTask;

@interface KTPEditPledgeTaskViewController : UITableViewController

@property (nonatomic, strong) KTPPledgeTask *pledgeTask;

- (instancetype)initWithPledgeTask:(KTPPledgeTask*)pledgeTask;

@end
