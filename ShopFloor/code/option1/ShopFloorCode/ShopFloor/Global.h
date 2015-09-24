//
//  Global.h
//  ShopFloor
//
//  Created by Kavita Deshmukh on 10/09/15.
//  Copyright (c) 2015 Infosys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface Global : NSObject
@property (nonatomic, strong) MBProgressHUD *HUD;

+(Global*)sharedInstance;
+ (void) showWaitIndicator;
+ (void) showWaitIndicatorWithTitle:(NSString*)message;
+ (UIView*)setBottomBorderOfButton:(UIButton*)aButton color:(UIColor*)aColor;
+ (UIView*)setTopBorderOfButton:(UIButton*)aButton color:(UIColor*)aColor;
+ (UIView*)setBottomShortBorderOfButton:(UIButton*)aButton color:(UIColor*)aColor;
+ (void) hideWaitIndicator;
-(BOOL)isNetworkReachable;
@end
