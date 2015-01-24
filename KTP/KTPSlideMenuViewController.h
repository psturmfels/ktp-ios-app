//
//  KTPSlideMenuViewController.h
//  KTP
//
//  Created by Owen Yang on 1/20/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KTPSlideMenuCell;
@protocol KTPSlideMenuDelegate;

@interface KTPSlideMenuViewController : UIViewController

@property (nonatomic, assign) id <KTPSlideMenuDelegate> delegate;
@property (nonatomic, strong) UITableView *menuTableView;

@end

@protocol KTPSlideMenuDelegate <NSObject>
@optional
/*!
 Optional delegate method that is called when a cell is selected. Most likely implemented by the root view controller of a slide menu to change the main view as needed.
 
 @param         cell
 */
- (void)didSelectSlideMenuCell:(KTPSlideMenuCell*)cell;

@end
