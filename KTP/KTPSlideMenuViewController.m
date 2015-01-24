//
//  KTPSlideMenuViewController.m
//  KTP
//
//  Created by Owen Yang on 1/20/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPSlideMenuViewController.h"
#import "KTPSlideMenuDataSource.h"

@interface KTPSlideMenuViewController () <UITableViewDelegate>

@property (nonatomic, strong) KTPSlideMenuDataSource *dataSource;

@end

@implementation KTPSlideMenuViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.menuTableView = [UITableView new];
        self.menuTableView.delegate = self;
        
        self.dataSource = [KTPSlideMenuDataSource new];
        self.menuTableView.dataSource = self.dataSource;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    
    // Add menu TableView as subview
    CGRect menuFrame = self.view.frame;
    menuFrame.origin.y += statusBarHeight;
    menuFrame.size.height -= statusBarHeight;
    self.menuTableView.frame = menuFrame;
    [self.view addSubview:self.menuTableView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Call delegate method if implemented
    if ([self.delegate respondsToSelector:@selector(didSelectSlideMenuCell:)]) {
        [self.delegate didSelectSlideMenuCell:(KTPSlideMenuCell*)[tableView cellForRowAtIndexPath:indexPath]];
    }
}

@end
