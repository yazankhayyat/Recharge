//
//  RevealViewController.m
//  Recharge 2
//
//  Created by Yazan Khayyat on 2015-11-13.
//  Copyright © 2015 Yazan. All rights reserved.
//

#import "RevealViewController.h"

@interface RevealViewController ()

@end

@implementation RevealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    super.revealViewController.delegate = self;
}

- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position {
    
}

- (void)revealToggle:(id)sender
{
    [self doSomething];
    [super revealToggleAnimated:YES];
}
- (void)_handleRevealGesture:(UIPanGestureRecognizer *)recognizer {
    [self doSomething];
    [super _handleRevealGesture:recognizer];
    
}

- (void)doSomething {
    // get location
    NSLog(@"location manager : %@ called in: %s", self.locationManager, __PRETTY_FUNCTION__);
    // get data
    
    NSLog(@"do something");
}

- (BOOL)revealControllerPanGestureShouldBegin:(SWRevealViewController *)revealController {
    
    return YES;
}

@end
