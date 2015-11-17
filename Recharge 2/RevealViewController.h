//
//  RevealViewController.h
//  Recharge 2
//
//  Created by Yazan Khayyat on 2015-11-13.
//  Copyright © 2015 Yazan. All rights reserved.
//

#import "SWRevealViewController.h"
#import "GasStation.h"
@import MapKit;
@import CoreLocation;

@interface RevealViewController : SWRevealViewController <SWRevealViewControllerDelegate, NSXMLParserDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property NSXMLParser *parser;
@property NSMutableString *element;
@property (nonatomic, strong) NSMutableArray *gasArray;
@property (assign, nonatomic) CLLocationCoordinate2D currentCoordinate;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) NSString *currentStationName;
@property (nonatomic, strong) NSString *currentPricePremium;
@property (nonatomic, strong) NSString *currentPriceUnleaded;
@property (nonatomic, strong) NSString *currentPriceMidGrade;




@end
