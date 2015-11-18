//
//  GasStation.h
//  Recharge 2
//
//  Created by Yazan Khayyat on 2015-10-27.
//  Copyright © 2015 Yazan. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapKit;

@interface GasStation : NSObject <MKAnnotation>

@property (assign, nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSString *gasStationName;
@property (nonatomic, strong) NSString *gasPricePremium;
@property (nonatomic, strong) NSString *gasPriceUnleaded;
@property (nonatomic, strong) NSString *gasPriceMidGrade;
@property (nonatomic, strong) NSString *gasStationDistance;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *subtitle;
@property MKRoute *gasStationRoute;


@end
