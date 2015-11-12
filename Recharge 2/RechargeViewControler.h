//
//  ViewController.h
//  Recharge 2
//
//  Created by Yazan Khayyat on 2015-10-27.
//  Copyright © 2015 Yazan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "SWRevealDelegate.h"


@interface RechargeViewControler : UIViewController
@property (nonatomic, strong) SWRevealDelegate *revealDelegate;
@end

