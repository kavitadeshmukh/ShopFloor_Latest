//
//  PrinterViewController.h
//  ShopFloor
//
//  Created by Kavita Deshmukh on 10/09/15.
//  Copyright (c) 2015 Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICustomPicker.h"

@interface PrinterViewController : UIViewController
@property (strong, nonatomic) UICustomPicker *customPickerViewObject;
@property (strong, nonatomic) IBOutlet UIButton *printerButton;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
-(IBAction)backButton_TouchUpInside:(id)sender;
-(IBAction)saveButton_ToucUpInside:(id)sender;
-(IBAction)printerButton_TouchUpInside:(id)sender;
-(IBAction)cancelButton_ToucUpInside:(id)sender;
@end
