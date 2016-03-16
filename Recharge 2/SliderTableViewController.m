//
//  SliderTableViewController.m
//  Recharge 2
//
//  Created by Yazan Khayyat on 2015-11-06.
//  Copyright © 2015 Yazan. All rights reserved.
//

#import "SliderTableViewController.h"
#import "GasStation.h"
#import "RechargeViewControler.h"
#import "GasStationTableViewCell.h"
@import MapKit;
@import CoreLocation;

@interface SliderTableViewController ()
@property (nonatomic, strong) NSArray *sortedGasStationsArray;


@end

@implementation SliderTableViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear:animated];
     //NSLog(@"------------------------> gasArray 2: %@", self.gasStationsArray);
    [self.tableView reloadData];
    if (self.sortedGasStationsArray.count == 0) {
        return;
    }
    [self sortGasArray];
    
}

-(void)sortGasArray {
    
    self.sortedGasStationsArray = [self.gasStationsArray sortedArrayUsingComparator:^NSComparisonResult(GasStation* obj1, GasStation*  obj2) {
        NSNumber *first = @([obj1.gasPriceUnleaded floatValue]);
        NSNumber *second = @([obj2.gasPriceUnleaded floatValue]);
        return [first compare:second];
    }];
    
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 7;
    return self.gasStationsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
      //  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
       GasStationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    GasStation *gasStation = self.gasStationsArray[indexPath.row];
    cell.stationNameLabel.text = gasStation.gasStationName;
    cell.priceLabel.text = [NSString stringWithFormat:@"Unleaded Gas Price: $%@", gasStation.gasPriceUnleaded];
    cell.distanceLabel.text = [NSString stringWithFormat:@"Time needed: %@ min",[self stringFromTimeInterval:gasStation.gasStationTime]];
//
//    #define ARC4RANDOM_MAX      0x100000000
//    
//    double val = ((double)arc4random() / ARC4RANDOM_MAX) + 0.5;
//    int x = arc4random()% 8 + 4;
//    NSString *shell = @"Shell";
//    NSString *esso = @"Esso";
//    NSString *petro = @"Petro Canada";
//    
//    NSArray *array = [[NSMutableArray alloc]initWithObjects:shell, esso, petro, nil];
//    
//    uint32_t rnd = arc4random_uniform([array count]);
//    
//    NSString *randomObject = [array objectAtIndex:rnd];
//
//    
//        cell.stationNameLabel.text = [NSString stringWithFormat:@"%@", randomObject];
//        cell.distanceLabel.text = [NSString stringWithFormat:@"%d min", x];
//        cell.priceLabel.text = [NSString stringWithFormat:@"$%f/L", val];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
   // http://maps.apple.com/maps?saddr=%f,%f&daddr=%f,%f
    GasStation *gasStation = self.gasStationsArray[indexPath.row];
    CLLocationManager *locationManager = ((RevealViewController*)self.parentViewController).locationManager;
    
    NSString* url = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f",
                     locationManager.location.coordinate.latitude,
                     locationManager.location.coordinate.longitude,
                     gasStation.coordinate.latitude,
                     gasStation.coordinate.longitude];
    
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
    
    

}

-(NSString *)stringFromTimeInterval:(NSString *)intervalString {
    NSInteger interval = [intervalString intValue];
    NSInteger ti = (NSInteger)interval;
    NSInteger minutes = (ti/60) % 60;
//    NSInteger hours = (ti/3600);
    
    return [NSString stringWithFormat:@"%01ld", (long)minutes];
    
}

@end
