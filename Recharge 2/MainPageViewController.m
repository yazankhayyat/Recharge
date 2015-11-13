//
//  MainPageViewController.m
//  Recharge 2
//
//  Created by Yazan Khayyat on 2015-10-28.
//  Copyright © 2015 Yazan. All rights reserved.
//

#import "MainPageViewController.h"
//#import "AppDelegate.h"

#import "RechargeViewControler.h"
#import "SliderTableViewController.h"
#import "SWRevealViewController.h"
#import "MainPageViewController.h"

@interface MainPageViewController ()

@end

@implementation MainPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@", self.view.backgroundColor);
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[self.view.backgroundColor CGColor],(id)[self.view.backgroundColor CGColor], (id)[[UIColor colorWithRed:0.98 green:0.74 blue:0.73 alpha:1] CGColor], nil];
    [self.view.layer insertSublayer:gradient atIndex:0];
    
    // Do any additional setup after loading the view.
}

@end
