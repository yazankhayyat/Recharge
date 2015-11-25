//
//  LocationController.m
//
//  Created by Peter Sobkowski on 2014-11-07.
//  Copyright (c) 2014 psobko. All rights reserved.
//

#import "LocationController.h"
#import "UIAlert+Blocks.h"

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@implementation LocationController

#pragma mark - Initialization

static LocationController *sharedLocationController = nil;

+ (LocationController *)sharedInstance
{
    static dispatch_once_t _LocationControllerPredicate;
    dispatch_once(&_LocationControllerPredicate, ^{
        sharedLocationController = [[LocationController alloc] init];
    });
    
    return sharedLocationController;
}

- (id)init
{
    if (self = [super init])
    {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        //TODO: change for map to Best
        _locationManager.activityType = CLActivityTypeFitness;
        _locationManager.distanceFilter = (CLLocationDistance)1.0;
        _locationManager.pausesLocationUpdatesAutomatically = NO;
        if([self checkLocationAuthorizationStatus])
        {
            [_locationManager startUpdatingLocation];
        }
    }
    return self;
}

#pragma mark - Public Methods

-(BOOL)checkLocationAuthorizationStatus
{
    //TODO: localization
    //TODO: check BG usage
    NSLog(@"%d", [CLLocationManager authorizationStatus]);
    NSString *errorMessage;
    switch ([CLLocationManager authorizationStatus])
    {
        case kCLAuthorizationStatusAuthorized:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            return YES;
        case kCLAuthorizationStatusRestricted:
            errorMessage = @"Location services must be enabled in order to use this app.";
            break;
        case kCLAuthorizationStatusDenied:
            errorMessage = @"Location services must be enabled in order to use this app.";
            break;
        case kCLAuthorizationStatusNotDetermined:
        default:
        {
            if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
            { //iOS 8+
                [self.locationManager requestWhenInUseAuthorization];
                return NO;
            }

            errorMessage = @"Unable to determine your location. Please make sure location services are enabled.";
            break;
        }
    }
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {

        [[[UIAlertView alloc] initWithTitle:@""
                                   message:@"You need to enable location services in settings"
                                  delegate:nil
                         cancelButtonTitle:@"Cancel" otherButtonTitles:@"Enable",nil] showWithCompletion:^(UIAlertView *alertView, NSInteger buttonIndex, BOOL didCancel) {
            

                if(!didCancel)
                {
                    NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    [[UIApplication sharedApplication] openURL:settingsURL];
                }

        }];
        
   
    }
    else
    {
        [[UIAlertView alloc] initWithTitle:@""
                                  message:errorMessage
                                 delegate:nil
                        cancelButtonTitle:@"Cancel" otherButtonTitles:@"Enable",nil];
    }
    
    return NO;
}

#pragma mark - Accessors

-(CLLocationDegrees)longitude
{
    return self.location.coordinate.longitude;
}

-(CLLocationDegrees)latitude
{
    return self.location.coordinate.latitude;
}

- (void)currentLocationDataWithCompletion:(void (^)(CLPlacemark* placemark, NSError *error))completion
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:self.locationManager.location
                   completionHandler:^(NSArray *placemarks, NSError *error)
    {
        NSLog(@"reverseGeocodeLocation:completionHandler: Completion Handler called!");
        
        CLPlacemark *placemark = [placemarks firstObject];
        _placemark = placemark;
        if (error)
        {
            NSLog(@"Geocode failed with error: %@", error);
        }
        
        if(completion)
        {
            completion(placemark, error);
        }

        
        NSLog(@"placemark.ISOcountryCode %@",placemark.ISOcountryCode);
        NSLog(@"placemark.country %@",placemark.country);
        NSLog(@"placemark.postalCode %@",placemark.postalCode);
        NSLog(@"placemark.administrativeArea %@",placemark.administrativeArea);
        NSLog(@"placemark.locality %@",placemark.locality);
        NSLog(@"placemark.subLocality %@",placemark.subLocality);
        NSLog(@"placemark.subThoroughfare %@",placemark.subThoroughfare);
        
    }];
}


#pragma mark - CLLocationManager Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    _location = [locations lastObject];
}

- (void)locationManager:(CLLocationManager*)manager
    didUpdateToLocation:(CLLocation*)newLocation
           fromLocation:(CLLocation*)oldLocation
{
    _location = newLocation;
}

-(void)processLocationUpdateWithLocation:(CLLocation*)newLocation
{
    _location = newLocation;
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||
    ([error.domain isEqualToString:kCLErrorDomain] && error.code == kCLErrorDenied))
    {
        [self checkLocationAuthorizationStatus];
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if([CLLocationManager locationServicesEnabled])
    {
        [self.locationManager startUpdatingLocation];
    }
}



@end
