//
//  KTPOptionSelectViewController.h
//  KTP
//
//  Created by Owen Yang on 2/17/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KTPOptionSelectDelegate;

@interface KTPOptionSelectViewController : UINavigationController

@property (nonatomic, strong)   NSArray *options;
@property (nonatomic)           NSUInteger selected;
@property (nonatomic, strong)   NSString *title;
@property (nonatomic, retain)   id<KTPOptionSelectDelegate> optionSelectDelegate;

- (instancetype)initWithOptions:(NSArray*)options selected:(NSUInteger)selected title:(NSString*)title;

@end

@protocol KTPOptionSelectDelegate <NSObject>
@optional
- (void)optionSelectViewController:(KTPOptionSelectViewController*)controller didSelectOptionAtIndex:(NSUInteger)index;
- (void)optionSelectViewController:(KTPOptionSelectViewController*)controller didSelectOptionWithValue:(id)value;
- (void)optionSelectViewControllerDidTapDoneButton:(KTPOptionSelectViewController *)controller;
- (void)optionSelectViewControllerDidTapCancelButton:(KTPOptionSelectViewController *)controller;
@end