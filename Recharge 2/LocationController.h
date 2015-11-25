//
//  LocationController.h
//
//  Created by Peter Sobkowski on 2014-11-07.
//  Copyright (c) 2014 psobko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@interface LocationController : NSObject <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager; //TODO: private
@property (readonly, nonatomic) CLLocation *location;
@property (readonly, nonatomic) CLLocationDegrees longitude;
@property (readonly, nonatomic) CLLocationDegrees latitude;
@property (readonly, nonatomic) CLPlacemark *placemark;

//@property (weak, nonatomic) id delegate;

+ (LocationController *)sharedInstance;

- (BOOL)checkLocationAuthorizationStatus;

- (void)currentLocationDataWithCompletion:(void (^)(CLPlacemark* placemark, NSError *error))completion;


@end
