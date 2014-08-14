//
//  KTPViewController.m
//  KTP
//
//  Created by Gregory Azevedo on 1/18/14.
//  Copyright (c) 2014 Kappa Theta Pi. All rights reserved.
//

#import "KTPViewController.h"

@interface KTPViewController ()

@property (nonatomic) UIScrollView *scrollView;

@end

@implementation KTPViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)loadView
{
    [super loadView];
    self.scrollView = [UIScrollView new];
    [self.scrollView setFrame:self.view.frame];
    [self.scrollView setAlwaysBounceHorizontal:YES];
    [self.scrollView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.scrollView];
    
    self.ktpBlockView = [[KTPBlockView alloc] initWithFrame:CGRectMake(10, 100, 310, 150)];
    [self.scrollView addSubview:self.ktpBlockView];

    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
