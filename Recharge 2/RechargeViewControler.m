//
//  ViewController.m
//  Recharge 2
//
//  Created by Yazan Khayyat on 2015-10-27.
//  Copyright © 2015 Yazan. All rights reserved.
//

#import "RechargeViewControler.h"
#import "GasStation.h"
#import "LocationController.h"

@import MapKit;
@import CoreLocation;

@interface RechargeViewControler () <CLLocationManagerDelegate, MKMapViewDelegate, SWRevealViewControllerDelegate> {
    MKPolyline *_routeOverlay;
    
}
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLPlacemark *placeMark;
@property (assign, nonatomic) BOOL initialLocationSet;
@property (nonatomic, strong) MKPinAnnotationView *myAnnotationView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *buffer;
@property (nonatomic, strong) NSString *addressString;
@property (nonatomic, strong) NSString *nameString;
@property (nonatomic ,strong) MKPointAnnotation *closestMarker;
@property (nonatomic ,strong) RevealViewController *revealController;
@property (nonatomic ,strong) UIColor *barTintColor;
@property MKRoute *routeDetails;

@end

@implementation RechargeViewControler


- (void)viewDidLoad {
    [super viewDidLoad];
    [self createRevealViewController];
    
    self.mapView.delegate = self;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.79 green:0.23 blue:0.20 alpha:1];
    self.initialLocationSet = NO;
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    gradient.frame = self.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[self.view.backgroundColor CGColor],
                       (id)[self.view.backgroundColor CGColor],
                       (id)[[UIColor colorWithRed:0.99 green:0.50 blue:0.50 alpha:1] CGColor],
                       nil];
    [self.view.layer insertSublayer:gradient atIndex:0];
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = 1000;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [self.view bringSubviewToFront:self.mapView];
    self.addressLabel.adjustsFontSizeToFitWidth = YES;
    
    if ([CLLocationManager locationServicesEnabled]) {
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        if (status == kCLAuthorizationStatusNotDetermined) {
            [self.locationManager requestWhenInUseAuthorization];
        }
    }
    
    //    [[LocationController sharedInstance] checkLocationAuthorizationStatus];
    //    [[LocationController sharedInstance] currentLocationDataWithCompletion:^(CLPlacemark *placemark, NSError *error) {
    //
    //    }];
}

-(void)createRevealViewController {
    
    self.revealController = (RevealViewController *)self.revealViewController;
    
    self.revealController.locationManager = self.locationManager;
    self.navigationController.navigationBar.topItem.title = @"Recharge";
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                      NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Regular"  size:16]}];
    [self.menuButton setTarget:self.revealController];
    [self.menuButton setAction:@selector(revealToggle:)];
    [self.view addGestureRecognizer:self.revealController.panGestureRecognizer];
    
}


-(void)showGasStations {
    //msj9zzc952qknnh88cfbbw92
    // hx6emten4cp32yp53pjyrafn
    
    [self.buffer startAnimating];
    self.buffer.hidden = NO;
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.sandbox.yellowapi.com/FindBusiness/?what=gas+stations&where=cZ%f,%f&pgLen=108&pg=1&dist=1&fmt=JSON&lang=en&UID=6472349276&apikey=hx6emten4cp32yp53pjyrafn", self.locationManager.location.coordinate.longitude, self.locationManager.location.coordinate.latitude];
    NSLog(@"%@", urlString);
    
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession]dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!error) {
            NSError *jsonError;
            NSDictionary *myGasStationsDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            
            if (!jsonError) {
                NSArray *myGasStationsArray = myGasStationsDictionary[@"listings"];
                
                CLLocationDistance closestDistance = INFINITY;
                
                NSMutableArray *markers = [[NSMutableArray alloc] init];
                
                for (NSDictionary *dictionary in myGasStationsArray) {
                    NSDictionary *theGeoCodeDictionary = dictionary[@"geoCode"];
                    MKPointAnnotation *marker = [[MKPointAnnotation alloc] init];
                    NSString *stationName = dictionary[@"name"];
                    NSDictionary *addressDictionary = dictionary[@"address"];
                    NSString *addressName = addressDictionary[@"street"];
                    
                    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
                    marker.coordinate = CLLocationCoordinate2DMake([theGeoCodeDictionary[@"latitude"] doubleValue], [theGeoCodeDictionary[@"longitude"] doubleValue]);
                    MKPlacemark *destinationPlacemark = [[MKPlacemark alloc]initWithCoordinate:marker.coordinate addressDictionary:nil];
                    [request setSource:[MKMapItem mapItemForCurrentLocation]];
                    [request setDestination:[[MKMapItem alloc] initWithPlacemark:destinationPlacemark]];
                    request.transportType = MKDirectionsTransportTypeAutomobile;
                    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
                    
                    
//                    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
//                        if (error) {
////                            NSLog(@"Error %@", error.description);
//                        } else {
//                            self.routeDetails = response.routes.firstObject;
//                        }
//                    }];
                    
                    
                    //                    CLLocationDistance distance = [self.locationManager.location distanceFromLocation:[[CLLocation alloc] initWithLatitude:marker.coordinate.latitude longitude:marker.coordinate.longitude]];
                    
                    if (self.routeDetails.distance < closestDistance) {
                        self.addressString = addressName;
                        self.nameString = stationName;
                        closestDistance = self.routeDetails.distance;
                        self.closestMarker = marker;
                    }
                    
                    [markers addObject:marker];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.buffer stopAnimating];
                    self.buffer.hidden = YES;
                    [self.mapView removeAnnotations:self.mapView.annotations];
                    [self.mapView addAnnotations:markers];
                });
            }
        }
    }];
    [dataTask resume];
}

//#pragma mark - Utility Methods
//
//- (void)plotRouteOnMap:(MKRoute *)route
//{
//    if(_routeOverlay) {
//        [self.mapView removeOverlay:_routeOverlay];
//    }
//
//    // Update the ivar
//    _routeOverlay = route.polyline;
//
//    // Add it to the map
//    [self.mapView addOverlay:_routeOverlay];
//
//}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager startUpdatingLocation];
        self.mapView.showsUserLocation = YES;
    }
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    NSLog(@"User loc: %f", self.locationManager.location.coordinate.latitude);
    self.revealController.locationManager = self.locationManager;
    CLLocation *location = [locations firstObject];
    if (!self.initialLocationSet) {
        self.initialLocationSet = YES;
        NSLog(@">> User loc: %f", self.locationManager.location.coordinate.latitude);
        
        MKCoordinateRegion region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(0.04, 0.04));
        [self.mapView setRegion:region animated:NO];
        
        
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            
            if (placemarks.count > 0) {
                CLPlacemark *placemark = [placemarks firstObject];
                self.placeMark = placemark;
                
            }
            
            [self showGasStations];
            NSLog(@"Called twice");
            
        }];
    }
    
}


#pragma mark - MKMapViewDelegate


-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if (annotation == self.mapView.userLocation) {
        return nil;
    }
    
    MKAnnotationView *pinView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:@"GasStation"];
    //pinView.image = nil;
    
    if (!pinView) {
        
        pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"GasStation"];
        pinView.image = [UIImage imageNamed:@"GasPump"];
        pinView.frame = CGRectMake(0, 0, 30, 30);
        pinView.contentMode = UIViewContentModeScaleAspectFit;
        pinView.centerOffset = CGPointMake(0, -pinView.frame.size.height/2);
    }
    
    if (annotation == self.closestMarker) {
        self.addressLabel.text = [NSString stringWithFormat:@"Closest Station: %@, %@",self.nameString, self.addressString];
        [UIView animateWithDuration:1
                              delay:0
             usingSpringWithDamping:1
              initialSpringVelocity:1
                            options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             
                             CGPoint oldCenter = pinView.center;
                             oldCenter.y += 10;
                             pinView.center = oldCenter;
                             
                         } completion:NULL];
        
    }
    
    return pinView;
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
    
    GasStation *gasStation = (GasStation *)view.annotation;
    
    NSString* url = [NSString stringWithFormat:@"http://maps.apple.com/maps?saddr=%f,%f&daddr=%f,%f",
                     self.mapView.userLocation.coordinate.latitude,
                     self.mapView.userLocation.coordinate.longitude,
                     gasStation.coordinate.latitude,
                     gasStation.coordinate.longitude];
    
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
    
    
}


@end
