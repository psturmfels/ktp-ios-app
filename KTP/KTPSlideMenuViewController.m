//
//  KTPSlideMenuViewController.m
//  KTP
//
//  Created by Owen Yang on 1/20/15.
//  Copyright (c) 2015 Kappa Theta Pi. All rights reserved.
//

#import "KTPSlideMenuViewController.h"
#import "KTPSlideMenuCell.h"

@interface KTPSlideMenuViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *cellDictArray;

@end

@implementation KTPSlideMenuViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.menuTableView = [UITableView new];
        self.menuTableView.delegate = self;
        self.menuTableView.dataSource = self;
        
        self.cellDictArray = @[
                               @{ @"cellTitle"  :   @"My Profile",      @"cellViewType"  :  [NSNumber numberWithInteger:KTPViewTypeMyProfile]       },
                               @{ @"cellTitle"  :   @"Members",         @"cellViewType"  :  [NSNumber numberWithInteger:KTPViewTypeMembers]         },
                               @{ @"cellTitle"  :   @"Pledging",        @"cellViewType"  :  [NSNumber numberWithInteger:KTPViewTypePledging]        },
                               @{ @"cellTitle"  :   @"Announcements",   @"cellViewType"  :  [NSNumber numberWithInteger:KTPViewTypeAnnouncements]   },
                               @{ @"cellTitle"  :   @"Pitches",         @"cellViewType"  :  [NSNumber numberWithInteger:KTPViewTypePitches]         },
                               @{ @"cellTitle"  :   @"Settings",        @"cellViewType"  :  [NSNumber numberWithInteger:KTPViewTypeSettings]        }
                               ];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    
    // Add menu TableView as subview
    CGRect menuFrame = self.view.frame;
    menuFrame.origin.y += statusBarHeight;
    menuFrame.size.height -= statusBarHeight;
    self.menuTableView.frame = menuFrame;
    [self.view addSubview:self.menuTableView];
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Call delegate method if implemented
    if ([self.delegate respondsToSelector:@selector(didSelectSlideMenuCell:)]) {
        [self.delegate didSelectSlideMenuCell:(KTPSlideMenuCell*)[tableView cellForRowAtIndexPath:indexPath]];
    }
}

#pragma mark - UITableViewDataSource methods


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellDictArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KTPSlideMenuCell *cell = [KTPSlideMenuCell new];
    cell.textLabel.text = self.cellDictArray[indexPath.row][@"cellTitle"];
    cell.viewType = [self.cellDictArray[indexPath.row][@"cellViewType"] integerValue];
    return cell;
}

@end
