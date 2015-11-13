//
//  RevealViewController.h
//  Recharge 2
//
//  Created by Yazan Khayyat on 2015-11-13.
//  Copyright © 2015 Yazan. All rights reserved.
//

#import "SWRevealViewController.h"
@import MapKit;
@import CoreLocation;

@interface RevealViewController : SWRevealViewController <SWRevealViewControllerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@end
