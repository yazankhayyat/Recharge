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
     NSLog(@"------------------------> gasArray 2: %@", self.gasStationsArray);
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
    
    return self.gasStationsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GasStationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    GasStation *gasStation = self.gasStationsArray[indexPath.row];
    cell.stationNameLabel.text = gasStation.gasStationName;
    cell.priceLabel.text = [NSString stringWithFormat:@"Unleaded Gas Price: %@", gasStation.gasPriceUnleaded];
    cell.distanceLabel.text = [NSString stringWithFormat:@"Time needed: %@",[self stringFromTimeInterval:gasStation.gasStationTime]];
    
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GasStation *gasStation = self.gasStationsArray[indexPath.row];
    CLLocationManager *locationManager = ((RevealViewController*)self.parentViewController).locationManager;
    
    NSString* url = [NSString stringWithFormat:@"http://maps.apple.com/maps?saddr=%f,%f&daddr=%f,%f",
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
    NSInteger hours = (ti/3600);
    
    return [NSString stringWithFormat:@"%02ld:%02ld",(long)hours, (long)minutes];
    
}

@end
