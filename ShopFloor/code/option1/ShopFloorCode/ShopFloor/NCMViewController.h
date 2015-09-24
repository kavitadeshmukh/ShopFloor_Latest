//
//  NCMViewController.h
//  ShopFloor
//
//  Created by Kavita Deshmukh on 10/09/15.
//  Copyright (c) 2015 Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICustomPicker.h"
#import "LineaSDK.h"

@interface NCMViewController : UIViewController <UITextViewDelegate>
@property (nonatomic, strong) IBOutlet UIButton *storageButton;
@property (nonatomic, strong) IBOutlet UIButton *binButton;
@property (nonatomic, strong) IBOutlet UIButton *quantityButton;
@property (nonatomic, strong) IBOutlet UIButton *reasonButton;
@property (nonatomic, strong) IBOutlet UIButton *ncmButton;
@property (nonatomic, strong) IBOutlet UIButton *reorderButton;
@property (nonatomic, strong) IBOutlet UITextField *materialIDTextfield;
@property (nonatomic, strong) IBOutlet UITextView *materialDescriptiontextView;
@property (nonatomic, strong) IBOutlet UITextView *commentsTextView;
@property (nonatomic, strong) IBOutlet UITextField *materialReorderTextField;
@property (nonatomic, strong) IBOutlet UITextView *materialDesReorderTextView;
@property (nonatomic, strong) IBOutlet UIButton *goReorderButton;
@property (nonatomic, strong) IBOutlet UIButton *goButton;
@property (nonatomic, strong) IBOutlet UIButton *resetButton;
@property (nonatomic, strong) IBOutlet UIButton *proccedButton;
@property (nonatomic, strong) IBOutlet UIView *reorderView;
@property (nonatomic, strong) IBOutlet UISegmentedControl *toggleButton;
@property (strong, nonatomic) UICustomPicker *customPickerViewObject;
@property (nonatomic, retain) NSString *barcodeString;
@property (nonatomic, strong) Linea *linea;

// Methods
-(IBAction)backButton_TouchUpInside:(id)sender;
-(IBAction)goButton_ToucUpInside:(id)sender;
-(IBAction)storageButton_TouchUpInside:(id)sender;
-(IBAction)binButton_TouchUpInside:(id)sender;
-(IBAction)quantityButton_ToucUpInside:(id)sender;
-(IBAction)reasonButton_ToucUpInside:(id)sender;
-(IBAction)resetButton_TouchUpInside:(id)sender;
-(IBAction)proceedButton_TouchUpInside:(id)sender;
-(IBAction)ncmButton_TouchUpInside:(id)sender;
-(IBAction)reorderButton_TouchUpInside:(id)sender;
@end
