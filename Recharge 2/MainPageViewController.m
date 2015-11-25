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
#import "RevealViewController.h"
#import "MainPageViewController.h"

@interface MainPageViewController ()

@end

@implementation MainPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //NSLog(@"%@", self.view.backgroundColor);
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[self.view.backgroundColor CGColor],(id)[self.view.backgroundColor CGColor], (id)[[UIColor colorWithRed:0.99 green:0.5 blue:0.5 alpha:1] CGColor], nil];
    [self.view.layer insertSublayer:gradient atIndex:0];
    
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self performSelector:@selector(loadRevealViewController) withObject:self afterDelay:3.0];
    
}

- (void)loadRevealViewController {
    [self performSegueWithIdentifier:@"RevealViewController" sender:self];
}

@end
