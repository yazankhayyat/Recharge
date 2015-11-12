//
//  AppDelegate.m
//  Recharge 2
//
//  Created by Yazan Khayyat on 2015-10-27.
//  Copyright © 2015 Yazan. All rights reserved.
//

#import "AppDelegate.h"
#import "RechargeViewControler.h"
#import "SliderTableViewController.h"
#import "SWRevealViewController.h"
#import "MainPageViewController.h"


@interface AppDelegate ()<SWRevealViewControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    MainPageViewController *mainPageViewController = (MainPageViewController *)self.window.rootViewController;
//    NSLog(@"%@", mainPageViewController);
    return YES;
}

-(void)showReveal {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window = window;
    
    RechargeViewControler *frontViewController =     [mainStoryboard instantiateViewControllerWithIdentifier:@"RechargeViewControler"];
    SliderTableViewController *rearViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"SliderTableViewController"];
    
    UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
    
    UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
    SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
    
    revealController.delegate = self;
    
    self.revealController = revealController;
    
    self.window.rootViewController = self.revealController;
    [self.window makeKeyAndVisible];
}

@end
