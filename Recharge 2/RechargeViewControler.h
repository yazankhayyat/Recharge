//
//  ViewController.h
//  Recharge 2
//
//  Created by Yazan Khayyat on 2015-10-27.
//  Copyright © 2015 Yazan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RevealViewController.h"


@interface RechargeViewControler : UIViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButton;
@property (strong, nonatomic) CLLocationManager *locationManager;
@end

