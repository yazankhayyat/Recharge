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



@end

@implementation SliderTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear:animated];
     NSLog(@"------------------------> gasArray 2: %@", self.gasStationsArray);
    [self.tableView reloadData];
}


#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 5;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.gasStationsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GasStationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    GasStation *gasStation = self.gasStationsArray[indexPath.row];
    cell.stationNameLabel.text = gasStation.gasStationName;
    cell.priceLabel.text = gasStation.gasPriceUnleaded;
    cell.distanceLabel.text = gasStation.gasStationDistance;
    
    
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
