//
//  GasStationTableViewCell.h
//  Recharge 2
//
//  Created by Yazan Khayyat on 2015-11-17.
//  Copyright © 2015 Yazan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GasStationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *stationNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
