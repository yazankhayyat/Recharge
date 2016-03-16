//
//  RevealViewController.m
//  Recharge 2
//
//  Created by Yazan Khayyat on 2015-11-13.
//  Copyright © 2015 Yazan. All rights reserved.
//

#import "RevealViewController.h"
#import "SliderTableViewController.h"


@interface RevealViewController ()

@property (nonatomic, strong) GasStation *currentGasStation;
@property double currentLat;
@property double currentLong;
@property NSString *currentDistance;


@end

@implementation RevealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.gasArray = [[NSMutableArray alloc]init];
    self.rearViewRevealWidth = self.view.frame.size.width - 40;
    self.currentGasStation.gasStationLocationManager = self.locationManager;
    super.delegate = self;
    
}

- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position {
    if (position == FrontViewPositionRight) {
        [self fetchXMLData];
    }
}


- (void)fetchXMLData {
    //    NSURLComponents *components = [[NSURLComponents alloc]init];
    //    components.scheme = @"http";
    //    components.host = @"services.opisnet.com";
    //    components.path = @"/RealtimePriceService/RealtimePriceServicePlus.asmx/GetLatLongSortedResults";
    //    components.queryItems = @[
    //                                  [NSURLQueryItem queryItemWithName:@"UserTicket" value:@"vHsMe6FTPXZHPEUTXz5mi0H30WlHxQCUGHCwCYdTtnSgEXn37RsDaOUpU9Ul33wH"],
    //                                  [NSURLQueryItem queryItemWithName:@"Latitude" value:[NSString stringWithFormat:@"%f",self.locationManager.location.coordinate.latitude]],
    //                                  [NSURLQueryItem queryItemWithName:@"Longitude" value:[NSString stringWithFormat:@"%f",self.locationManager.location.coordinate.longitude]],
    //                                  [NSURLQueryItem queryItemWithName:@"SortByProduct" value:@"Unleaded"],
    //                                  [NSURLQueryItem queryItemWithName:@"MaxResult" value:@"50"]
    //                                  ];
    //    NSURL *url = components.URL;
    //    NSAssert(url, @"must not be nil");
    
    // https://services.opisnet.com/RealtimePriceService/RealtimePriceServicePlus.asmx/GetLatLongSortedWithDistanceResults?UserTicket=string&Latitude=string&Longitude=string&SortByProduct=string&distance=string&isFilteredByDistance=string&UserLatitude=string&UserLongitude=string
   
    // http://services.opisnet.com/RealtimePriceService/RealtimePriceServicePlus.asmx/GetLatLongSortedWithDistanceResults?UserTicket=vHsMe6FTPXZHPEUTXz5mi0H30WlHxQCUGHCwCYdTtnSgEXn37RsDaOUpU9Ul33wH&Latitude=43.667686&Longitude=-79.389023&UserLatitude=43.667686&UserLongitude=-79.389023&isFilteredByDistance=True&distance=5.0&SortByProduct=Unleaded
   
    
    
    // http://services.opisnet.com/RealtimePriceService/RealtimePriceServicePlus.asmx/GetLatLongSortedWithDistanceResults?UserTicket=vHsMe6FTPXZHPEUTXz5mi0H30WlHxQCUpoDKq8u+Js/Q5VYESTdIuE1Guw7bdsOY&Latitude=43.667686&Longitude=-79.389023&UserLatitude=43.667686&UserLongitude=-79.389023&isFilteredByDistance=True&distance=5.0&SortByProduct=Unleaded
    
    
    NSString *latitude = [NSString stringWithFormat:@"%f",self.locationManager.location.coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f",self.locationManager.location.coordinate.longitude];
    
    
    
    NSURLComponents *components = [[NSURLComponents alloc]init];
    components.scheme = @"http";
    components.host = @"services.opisnet.com";
    components.path = @"/RealtimePriceService/RealtimePriceServicePlus.asmx/GetLatLongSortedWithDistanceResults";
    components.queryItems = @[
                              [NSURLQueryItem queryItemWithName:@"UserTicket" value:@"vHsMe6FTPXZHPEUTXz5mi0H30WlHxQCUe6y/ZTWUfRUq0FmKUkhD3QO7wZeqW/V2"],
                              [NSURLQueryItem queryItemWithName:@"Latitude" value:latitude],
                              [NSURLQueryItem queryItemWithName:@"Longitude" value:longitude],
                              [NSURLQueryItem queryItemWithName:@"SortByProduct" value:@"Unleaded"],
                              [NSURLQueryItem queryItemWithName:@"distance" value:@"3.0"],
                              [NSURLQueryItem queryItemWithName:@"isFilteredByDistance" value:@"True"],
                              [NSURLQueryItem queryItemWithName:@"UserLatitude" value:latitude],
                              [NSURLQueryItem queryItemWithName:@"UserLongitude" value:longitude],];
    NSURL *url = components.URL;
    NSAssert(url, @"must not be nil");
    NSLog(@"%s %@", __PRETTY_FUNCTION__, url);
    //    NSString *urlString = [NSString stringWithFormat:@"http://services.opisnet.com/RealtimePriceService/RealtimePriceServicePlus.asmx/GetLatLongSortedResults?UserTicket=vHsMe6FTPXZHPEUTXz5mi0H30WlHxQCUGHCwCYdTtnSgEXn37RsDaOUpU9Ul33wH&Latitude=%f&Longitude=%f&SortByProduct=Unleaded&isFilteredByDistance=True", self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude];
    //     urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    //
    //    NSURL *url = [[NSURL alloc]initWithString:urlString];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
                               if (connectionError == nil) {
                                   NSString *dataAsString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                               NSLog(@">>>>>>>>>>  data String :<<<<<<< %@", dataAsString);
                                   self.parser = [[NSXMLParser alloc]initWithData:data];
                                   self.parser.delegate = self;
                                   [self.parser parse];
                                   
                               }
                               
                           }];
    
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(NSDictionary<NSString *, NSString *> *)attributeDict {
    
    self.element = nil;
    if ([elementName isEqualToString:@"StationPricesByLatLongMultiPlus"]) {
        self.currentGasStation = [[GasStation alloc]init];
        self.currentLong = HUGE_VALF;
        self.currentLat = HUGE_VALF;
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (!self.element) {
        self.element = [[NSMutableString alloc]init];
    }
    [self.element appendString:string];
    
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    __block GasStation *blockGasStation = self.currentGasStation;
    
    if ([elementName isEqualToString:@"Station_Name"]) {
        self.currentGasStation.gasStationName = self.element;
        return;
    }
    
    if ([elementName isEqualToString:@"Unleaded_Price"]) {
        CGFloat priceAsFloat = [self.element floatValue];
        NSString *priceAsString = [NSString stringWithFormat:@"%0.2f",priceAsFloat];
        self.currentGasStation.gasPriceUnleaded = priceAsString;
        NSLog(@"unleaded price: %@",self.currentGasStation.gasPriceUnleaded);
        return;
    }
    
    if ([elementName isEqualToString:@"LATITUDE"]) {
        self.currentLat= [self.element doubleValue];
    }
    
    if ([elementName isEqualToString:@"LONGITUDE"]) {
        self.currentLong = [self.element doubleValue];
        if (self.currentLat != HUGE_VALF) {
            self.currentGasStation.coordinate = CLLocationCoordinate2DMake(self.currentLat, self.currentLong);
            MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
            MKPlacemark *destinationPlacemark = [[MKPlacemark alloc]initWithCoordinate:
                                                 CLLocationCoordinate2DMake(self.currentLat, self.currentLong)
                                                                     addressDictionary:nil];
            MKPlacemark *sourcePlaceMark = [[MKPlacemark alloc]initWithCoordinate:self.locationManager.location.coordinate addressDictionary:nil];
            
            [request setSource:[[MKMapItem alloc]initWithPlacemark:sourcePlaceMark]];
            
            [request setDestination:[[MKMapItem alloc] initWithPlacemark:destinationPlacemark]];
            
            request.transportType = MKDirectionsTransportTypeAutomobile;
            MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
            
            
            [directions calculateETAWithCompletionHandler:^(MKETAResponse *response, NSError *error) {
                
                if (error) {
                    NSLog(@"Error %@", error.description);
                } else {
                    blockGasStation.gasStationTime = [NSString stringWithFormat:@"%f",response.expectedTravelTime];
                    
                    //                    NSLog(@"gas station time: %d", self.gasArray.);
                }
                //                blockGasStation.gasStationTime = [NSString stringWithFormat:@"%f",response.expectedTravelTime];
                
                SliderTableViewController *sliderTableView = (SliderTableViewController *)self.rearViewController;
                [sliderTableView.tableView reloadData];
                
            }];
            //     NSLog(@"Long: %f, lat:%f", self.currentLong, self.currentLat);
            
        }
        
    }
    if ([elementName isEqualToString:@"StationPricesByLatLongMultiPlus"]) {
        [self.gasArray addObject:self.currentGasStation];
        //  NSLog(@"................>>>>> gas Array : %@", self.gasArray);
    }
    
}

-(void)parserDidEndDocument:(NSXMLParser *)parser {
    
    SliderTableViewController *sliderTableView = (SliderTableViewController *)self.rearViewController;
    sliderTableView.gasStationsArray = self.gasArray;
    //    UIView *view = [[UIView alloc] initWithFrame:sliderTableView.view.frame];
    //    view.backgroundColor = [UIColor orangeColor];
    //    [sliderTableView.tableView addSubview:view];
    [sliderTableView viewWillAppear:NO];
    
}



@end
