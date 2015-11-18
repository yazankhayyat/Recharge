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
    NSString *urlString = [NSString stringWithFormat:@"http://services.opisnet.com/RealtimePriceService/RealtimePriceServicePlus.asmx/GetLatLongSortedResults?UserTicket=vHsMe6FTPXZHPEUTXz5mi0H30WlHxQCUwarkHoWW8poQ9PmbIbGAtI9CY8r9AdmR&Latitude=%f&Longitude=%f&SortByProduct=Unleaded", self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude];
    
    NSURL *url = [[NSURL alloc]initWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
                               if (connectionError == nil) {
                                   NSString *dataAsString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                                   NSLog(@"data String : %@", dataAsString);
                                   self.parser = [[NSXMLParser alloc]initWithData:data];
                                   self.parser.delegate = self;
                                   [self.parser parse];
                                   
                               }
                               
                           }];
    
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(NSDictionary<NSString *, NSString *> *)attributeDict {
    self.element = nil;
    if ([elementName isEqualToString:@"StationPricesMultiPlus"]) {
        self.currentGasStation = [[GasStation alloc]init];
        self.currentLong = HUGE_VALF;
        self.currentLat = HUGE_VALF;
        
        //        NSLog(@"element dictionary: %@", attributeDict);
        //    }
        //
        //    if ([elementName isEqualToString:@"Station_Name"]) {
        //        self.element = nil;
        //        return;
        //    }
        //
        //    if ([elementName isEqualToString:@"Unleaded_Price"]) {
        //        self.element = nil;
        //        return;
        //    }
        //
        //    if ([elementName isEqualToString:@"LATITUDE"]) {
        //        self.element = nil;
        //        return;
        //
        //    }
        //    
        //    if ([elementName isEqualToString:@"LONGITUDE"]) {
        //        self.element = nil;
        //        return;
        //    }
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
        self.currentGasStation.gasPriceUnleaded = self.element;
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
                    blockGasStation.gasStationDistance = [NSString stringWithFormat:@"%f",response.expectedTravelTime];
                    NSLog(@"");
                }
                
                SliderTableViewController *sliderTableView = (SliderTableViewController *)self.rearViewController;
                [sliderTableView.tableView reloadData];
                
            }];
       //     NSLog(@"Long: %f, lat:%f", self.currentLong, self.currentLat);

        }
        
    }
    if ([elementName isEqualToString:@"StationPricesMultiPlus"]) {
        [self.gasArray addObject:self.currentGasStation];
      //  NSLog(@"................>>>>> gas Array : %@", self.gasArray);
    }
    
}

-(void)parserDidEndDocument:(NSXMLParser *)parser {
    
    SliderTableViewController *sliderTableView = (SliderTableViewController *)self.rearViewController;
    sliderTableView.gasStationsArray = self.gasArray;
    [sliderTableView viewWillAppear:NO];
}



@end
