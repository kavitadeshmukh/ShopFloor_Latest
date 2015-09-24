//
//  LoginViewController.h
//  ShopFloor
//
//  Created by Kavita Deshmukh on 10/09/15.
//  Copyright (c) 2015 Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineaSDK.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate>
@property (nonatomic, retain)Linea *linea;
@property (nonatomic, retain)NSString *barcodeString;
@property (nonatomic, strong)IBOutlet UITextField *cardenumberTextField;
@property (nonatomic, strong)IBOutlet UIButton *loginButton;

-(IBAction)loginButton_TouchUpInside:(id)sender;
@end
