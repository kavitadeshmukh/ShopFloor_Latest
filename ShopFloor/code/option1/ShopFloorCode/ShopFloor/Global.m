//
//  Global.m
//  ShopFloor
//
//  Created by Kavita Deshmukh on 10/09/15.
//  Copyright (c) 2015 Infosys. All rights reserved.
//

#import "Global.h"
#import "Reachability.h"
#import "Constants.h"

@implementation Global
static Global *sharedObject = nil;

- (id)init {
    if (! sharedObject) {
        sharedObject = [super init];
    }
    return sharedObject;
}
+(Global*)sharedInstance{
    
    static Global *sharedInstance=nil;
    static dispatch_once_t  oncePredecate;
    
    dispatch_once(&oncePredecate,^{
        sharedInstance=[[Global alloc] init];
    });
    return sharedInstance;
}
-(BOOL)isNetworkReachable{
    
    //creating the object of ReachabilityNV class and call the function.
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    
    //checking the network status.
    NetworkStatus reachabilityStatus = [reachability currentReachabilityStatus];
    
    //condition check for reachibilty.
    if(reachabilityStatus == NotReachable)
    {
        return NO;
    }
    else
        return YES;
    
}

+ (void) showWaitIndicator {
    [[[Global sharedInstance] HUD] hide:TRUE];
    [Global sharedInstance].HUD = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:[Global sharedInstance].HUD];
    
    [[Global sharedInstance].HUD show:TRUE];
}

+ (void) showWaitIndicatorWithTitle:(NSString*)message {
    [[[Global sharedInstance] HUD] hide:TRUE];
    [Global sharedInstance].HUD = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:[Global sharedInstance].HUD]; [Global sharedInstance].HUD.labelText = message;
    [[Global sharedInstance].HUD show:TRUE];
}
+ (void) hideWaitIndicator {
    [[[Global sharedInstance] HUD] hide:TRUE];
}
+ (UIView*)setBottomBorderOfButton:(UIButton*)aButton color:(UIColor*)aColor{
    UIView *bottomBorder = [[UIView alloc]
                            initWithFrame:CGRectMake(0, aButton.frame.size.height - 1.0f,
                                                     aButton.frame.size.width, 1)];
    bottomBorder.backgroundColor = aColor;
    return bottomBorder;
}
+ (UIView*)setTopBorderOfButton:(UIButton*)aButton color:(UIColor*)aColor{
    UIView *topBorder = [[UIView alloc]
                         initWithFrame:CGRectMake(0, 0,
                                                  aButton.frame.size.width, 1)];
    topBorder.backgroundColor = aColor;
    return topBorder;
}
+ (UIView*)setBottomShortBorderOfButton:(UIButton*)aButton color:(UIColor*)aColor{
    UIView *bottomBorder = [[UIView alloc]
                            initWithFrame:CGRectMake(0+13, aButton.frame.size.height - 1.0f,
                                                     aButton.frame.size.width-30, 5)];
    bottomBorder.backgroundColor = aColor;
    return bottomBorder;
}


@end
