//
//  UIAlert+Blocks.h
//  Recharge 2
//
//  Created by Yazan Khayyat on 2015-10-29.
//  Copyright © 2015 Yazan. All rights reserved.
//



#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIAlertView (Blocks)

- (void)showWithCompletion:(void(^)(UIAlertView *alertView, NSInteger buttonIndex, BOOL didCancel))completion;

@end
