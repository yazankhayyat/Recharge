//
//  SliderTableViewController.h
//  Recharge 2
//
//  Created by Yazan Khayyat on 2015-11-06.
//  Copyright © 2015 Yazan. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MapKit;
@import CoreLocation;

@interface SliderTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *gasStationsArray;
@property (nonatomic, strong) CLLocationManager *locationManager;



@end
