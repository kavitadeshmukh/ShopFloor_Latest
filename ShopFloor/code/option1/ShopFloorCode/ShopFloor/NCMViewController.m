//
//  NCMViewController.m
//  ShopFloor
//
//  Created by Kavita Deshmukh on 10/09/15.
//  Copyright (c) 2015 Infosys. All rights reserved.
//

#import "NCMViewController.h"
#import "PrinterViewController.h"
#import "APIsManager.h"
#import "Global.h"
#import "Constants.h"


@interface NCMViewController ()
{
NSArray * _pickerData;
    UIView *ncmBorderView;
    UIView *reorderBorderView;
}
@end
int moveup = 1;
int _clickNCMCounter = 0;
int _clickReorderCounter = 0;

@implementation NCMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self resetValues];
    
    // Do any additional setup after loading the view.
     self.customPickerViewObject = [[UICustomPicker alloc]init];
    
    // Set color to placeholder
    UIColor *color = [UIColor grayColor];
    self.materialIDTextfield.attributedPlaceholder =
    [[NSAttributedString alloc]
     initWithString:@"Material ID (Scan or Enter Manually)"
     attributes:@{NSForegroundColorAttributeName:color}];
    self.materialReorderTextField.attributedPlaceholder =
    [[NSAttributedString alloc]
     initWithString:@"Material ID (Scan or Enter Manually)"
     attributes:@{NSForegroundColorAttributeName:color}];
    
    self.commentsTextView.delegate = self;
    self.commentsTextView.text = @"Comments";
    self.commentsTextView.textColor = [UIColor lightGrayColor];
    self.reorderView.hidden = YES;
    
    // set the button border
    [self.binButton addSubview:[Global
                                setBottomBorderOfButton:self.binButton
                                color:[UIColor lightGrayColor]]];
    [self.binButton addSubview:[Global setTopBorderOfButton:self.binButton
                                                      color:[UIColor lightGrayColor]]];
    [self.quantityButton addSubview:[Global
                                     setBottomBorderOfButton:self.quantityButton
                                     color:[UIColor lightGrayColor]]];
    [self.reasonButton addSubview:[Global
                                   setBottomBorderOfButton:self.reasonButton
                                   color:[UIColor lightGrayColor]]];
    [self.ncmButton addSubview:[Global
                                setBottomBorderOfButton:self.ncmButton
                                color:[UIColor colorWithRed:255/255.0
                                                      green:102/255.0
                                                       blue:0/255.0
                                                      alpha:1]]];
    [self.reorderButton addSubview:[Global
                                    setBottomBorderOfButton:self.reorderButton
                                    color:[UIColor colorWithRed:255/255.0
                                                          green:102/255.0
                                                           blue:0/255.0
                                                          alpha:1]]];
    ncmBorderView =[Global setBottomShortBorderOfButton:self.ncmButton
                                                  color:[UIColor
                                                         colorWithRed:255/255.0
                                                         green:102/255.0
                                                         blue:0/255.0
                                                         alpha:1]];
    [self.ncmButton addSubview:ncmBorderView];
    
    // activate linea pro
    [self setLieaDelegates];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
    [self.linea removeDelegate:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backButton_TouchUpInside:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)goButton_ToucUpInside:(id)sender {
    self.storageButton.titleLabel.text = @"S101";
    if ([self.storageButton.titleLabel.text isEqualToString:@"Storage Location"]){
        [self showAlertBox:@"Select a Storage Location"];
    }
    else if ([[self.materialIDTextfield.text stringByTrimmingCharactersInSet:
               [NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]){
        [self showAlertBox:@"Enter a Material ID"];
    }
    else {
        [self serviceCallToGetMaterialDescription];
    }
}

-(IBAction)storageButton_TouchUpInside:(id)sender {
    _pickerData = [[NSArray alloc] initWithObjects:@"S004 : IM HU SYTomahawk",@"S005 : IM SY NCM 2",@"S006 : DO NOT USE",@"S007 : IM SY ASY FG YBC",@"S008 : IM SY NCM YBC",@"S009 : IM SY NCM rework",@"S010 : IM SY New Prts",@"S011 : IM SY Zn A",@"S012 : IM SY Zn B",@"S013 : IM SY Zn C",@"S014 : IM SY Zn D",@"S015 : IM SY Zn E Main",@"S016 : IM SY Zn F Main",@"S021 : IM SY Zn W",@"S022 : IM SY Zn PTO",@"S030 : IM HU SY  PTO",@"S031 : IM HU SY  CVO",@"S035 : IM SY CKD F.Asy",@"S036 : IM SY P-A  F.Asy",@"S101 : WM Assly LinePOU",@"S103 : IM Yrk Intransit",@"S105 : IM Fin Bk RE-CIC",@"S106 : IM Bk WIP repair",@"S107 : IM Asy POU Anxtr",@"S201 : IM Fab RackStore",@"S203 : IM Fab FramePres",@"S204 : IM Fab Fin Frame",@"S205 : IM Fab Tnk Press",@"S207 : IM Fab Fin Tank",@"S208 : IM Fab FendPress",@"S209 : IM Fab Fin Fendr",@"S301 : IM Paint  WIP",@"S302 : IM Paint  E-Coat",@"S303 : IM Pnt MMile Avl",@"S304 : IM Paint Strip",@"S305 : IM Pnt P-A parts",@"S307 : IM Paint  Rework",@"S351 : IM New Parts Yrk",@"S352 : IM Process Lab",@"S401 : IM MRO Tooling",@"S402 : IM MRO Overflow",@"S403 : IM MRO Warranty",@"S404 : IM Indirect Gen.",@"S405 : IM MRO Henkel",@"S406 : IM MRO Outside",@"S407 : IM MRO NCM",@"S408 : IM MRO Scrap",@"S501 : IM Crane  Comp",@"S502 : IM Crane Assly",@"S503 : IM Crane FG",@"S601 : IM CKD AS TK HU",@"S602 : IM CKD YRK Assly",@"S603 : IM HU CKD Yrk FG",@"S651 : IM P-A General",@"S700 : IM Plant NCM",@"S701 : IM Plnt Rework",@"S702 : IM Rework Extl",@"S703 : IM Scrap Extl",@"S704 : IM NCMTrailerYRK",@"S803 : IM M-M Operation",@"S804 : IM M-M Rework",@"S805 : IM OSS AFR Paint",@"S806 : IM OSS  Surtech",@"S807 : IM OSS StrpItCln",@"S808 : IM OSS USI",@"SP04 : IM Partner S603",@"SP05 : IM Partner S601",@"SP06 : IM Partner S004",@"SP07 : IM Partner S030",@"SP08 : IM Partner S031",@"SYC1 : DO NOT USE",@"SYC2 : SYC WM MVC",@"SYC3 : SYC WM YBC", nil];
    [self.customPickerViewObject initWithCustomPicker:
     CGRectMake(0, 0, self.view.frame.size.width, 160)
                                               inView:self.view
                                          ContentSize:CGSizeMake(self.view.frame.size.width, 160)
                                           pickerSize:CGRectMake(0, 0, self.view.frame.size.width, 160)
                                             barStyle:UIBarStyleBlack
                                             Recevier:self.storageButton
                                       componentArray:(NSMutableArray*)_pickerData
                                         toolBartitle:@"Locations"
                                            textColor:[UIColor whiteColor]
                                           needToSort:NO needMultiSelection:NO
                                          withDictKey:@"name"];
}

-(IBAction)binButton_TouchUpInside:(id)sender {
    _pickerData = [[NSArray alloc] initWithObjects:[[NSUserDefaults standardUserDefaults] valueForKey:BIN], nil];
    [self.customPickerViewObject initWithCustomPicker:
     CGRectMake(0, 0, self.view.frame.size.width, 160)
                                               inView:self.view
                                          ContentSize:CGSizeMake(self.view.frame.size.width, 160)
                                           pickerSize:CGRectMake(0, 0, self.view.frame.size.width, 160)
                                             barStyle:UIBarStyleBlack
                                             Recevier:self.binButton
                                       componentArray:(NSMutableArray*)_pickerData
                                         toolBartitle:@"Bin Number"
                                            textColor:[UIColor whiteColor]
                                           needToSort:NO needMultiSelection:NO
                                          withDictKey:@"name"];
}

-(IBAction)quantityButton_ToucUpInside:(id)sender {
    _pickerData = [[NSArray alloc] initWithObjects:@"Quantity: 1", @"Quantity: 2",@"Quantity: 3",@"Quantity: 4",@"Quantity: 5",@"Quantity: 6",nil];
    [self.customPickerViewObject initWithCustomPicker:
     CGRectMake(0, 0, self.view.frame.size.width, 160)
                                               inView:self.view
                                          ContentSize:CGSizeMake(self.view.frame.size.width, 160)
                                           pickerSize:CGRectMake(0, 0, self.view.frame.size.width, 160)
                                             barStyle:UIBarStyleBlack
                                             Recevier:self.quantityButton
                                       componentArray:(NSMutableArray*)_pickerData
                                         toolBartitle:@"Quantity"
                                            textColor:[UIColor whiteColor]
                                           needToSort:NO needMultiSelection:NO
                                          withDictKey:@"name"];
}

-(IBAction)reasonButton_ToucUpInside:(id)sender {
    _pickerData = [[NSArray alloc] initWithObjects:@"Reason: NCM - Print Label",@"Reason: MRO Cores",@"Reason: Hold- Insp /Warranty",@"Reason: Running Charge",@"Reason: New Product",@"Reason: Quality",@"Reason: Paint Strip",@"Reason: Inventory Discrepancy",@"Reason: Mis-Labeled", nil];
    [self.customPickerViewObject initWithCustomPicker:
     CGRectMake(0, 0, self.view.frame.size.width, 160)
                                               inView:self.view
                                          ContentSize:CGSizeMake(self.view.frame.size.width, 160)
                                           pickerSize:CGRectMake(0, 0, self.view.frame.size.width, 160)
                                             barStyle:UIBarStyleBlack
                                             Recevier:self.reasonButton
                                       componentArray:(NSMutableArray*)_pickerData
                                         toolBartitle:@"Reason"
                                            textColor:[UIColor whiteColor]
                                           needToSort:NO needMultiSelection:NO
                                          withDictKey:@"name"];
}

-(IBAction)resetButton_TouchUpInside:(id)sender {
    // Reset all values
    [self resetValues];
}

-(IBAction)proceedButton_TouchUpInside:(id)sender {
    // Set Values
    if ([self.commentsTextView.text isEqualToString:@"Comments"])
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:COMMENTS];
    else
    [[NSUserDefaults standardUserDefaults] setValue:self.commentsTextView.text forKey:COMMENTS];
//    [[NSUserDefaults standardUserDefaults] setValue:[self getQuantityKeyValue:self.reasonButton.titleLabel.text] forKey:REASON];
//    [[NSUserDefaults standardUserDefaults] setValue:[self getReasonKeyValue:self.quantityButton.titleLabel.text] forKey:QUANTITY];
    [[NSUserDefaults standardUserDefaults] setValue:@"001" forKey:REASON];
    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:QUANTITY];
    
    NSLog(@"dddd %@ %@", [self getQuantityKeyValue:self.reasonButton.titleLabel.text],[self getReasonKeyValue:self.quantityButton.titleLabel.text]);
    if ([self.binButton.titleLabel.text isEqualToString:@"Bin Number"] ||
        [self.quantityButton.titleLabel.text isEqualToString:@"Quantity"]||
        [self.reasonButton.titleLabel.text isEqualToString:@"Reason"]){
        [self showAlertBox:@"Please select all the fields (Bin, Quantity and Reason)."];
    
    }
    else {
    // Perform Inventory
    PrinterViewController *printerViewController = (PrinterViewController*)[self.storyboard
                                                                         instantiateViewControllerWithIdentifier:@"PrinterViewController"];
    [self.navigationController pushViewController:printerViewController animated:YES];
    }
}

-(IBAction)ncmButton_TouchUpInside:(id)sender {
    _clickNCMCounter = _clickNCMCounter+1;
     self.storageButton.userInteractionEnabled = YES;
    self.reorderView.hidden= YES;
   
    if (_clickNCMCounter == 1){
        _clickReorderCounter=0;
        self.ncmButton.userInteractionEnabled = NO;
        self.reorderButton.userInteractionEnabled=YES;
    ncmBorderView = nil;
    ncmBorderView =[Global
                    setBottomShortBorderOfButton:self.ncmButton
                    color:[UIColor colorWithRed:255/255.0
                                          green:102/255.0
                                           blue:0/255.0
                                          alpha:1]];
    [self.ncmButton addSubview:ncmBorderView];
    [reorderBorderView removeFromSuperview];
    }

}
-(IBAction)reorderButton_TouchUpInside:(id)sender {
    _clickReorderCounter = _clickReorderCounter+1;
    self.storageButton.userInteractionEnabled = NO;
    self.reorderView.hidden= NO;
    
    if (_clickReorderCounter ==1){
        _clickNCMCounter =0;
        self.ncmButton.userInteractionEnabled = YES;
        self.reorderButton.userInteractionEnabled=NO;
    reorderBorderView = nil;
    reorderBorderView =[Global
                        setBottomShortBorderOfButton:self.reorderButton
                        color:[UIColor colorWithRed:255/255.0
                                              green:102/255.0
                                               blue:0/255.0
                                              alpha:1]];
    [self.reorderButton addSubview:reorderBorderView];
    [ncmBorderView removeFromSuperview];
    }

}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
//    // Proceed button is clicked call the webservice
//    [[APIsManager sharedManager] getMaterialDescription:@"" completionBlock:^(NSDictionary *responseDictonary){
//        NSLog(@"resonse %@", responseDictonary);
//    }];
//    [[APIsManager sharedManager] getBinNumber:@"" storageLocation:@""
//                              completionBlock:^(NSDictionary *responseDictonary){
//        NSLog(@"resonse %@", responseDictonary);
//    }];
//        [[APIsManager sharedManager] setInventoryMovement:@"" quantity:@"" reason:@"" postingDate:@"" storageLocation:@"" workStation:@"" comments:@"" bin:@""
//                                  completionBlock:^(NSDictionary *responseDictonary){
//            NSLog(@"resonse %@", responseDictonary);
//                                     
//        }];

//    [[APIsManager sharedManager] sample];
}

# pragma TextView/ TextField delegate methods

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if(textView.text.length != 0 && [textView.text isEqualToString:@"Comments"]) {
        textView.text = @"";
        textView.textColor = [UIColor whiteColor];
        textView.tag = 1;
    }
    if (moveup == 1){
    moveup =2;
    [UIView beginAnimations:@"MoveView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.5f];
    self.view.frame = CGRectMake(0, -150, self.view.frame.size.width,
                                 self.view.frame.size.height);
    [UIView commitAnimations];
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [self.view endEditing:YES];
        if (moveup ==2){
            moveup =1;
            [UIView beginAnimations:@"MoveDown" context:nil];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
            [UIView setAnimationDuration:0.5f];
            self.view.frame = CGRectMake(0, self.view.frame.origin.y+150,
                                         self.view.frame.size.width,
                                         self.view.frame.size.height);
            [UIView commitAnimations];
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

# pragma SLEF DEFINE METHODS

-(void)resetValues{
    //Setups
    [self.storageButton setTitle:@"Storage location"
                        forState:UIControlStateNormal];
    self.materialIDTextfield.text =@"";
    self.materialReorderTextField.text=@"";
    self.materialReorderTextField.text =@"";
    self.materialDesReorderTextView.text=@"";
    self.goButton.userInteractionEnabled = YES;
    self.binButton.userInteractionEnabled=NO;
    self.quantityButton.userInteractionEnabled=NO;
    self.reorderView.userInteractionEnabled=NO;
    self.reasonButton.userInteractionEnabled=NO;
    self.proccedButton.userInteractionEnabled=NO;
    self.toggleButton.userInteractionEnabled=NO;
    self.commentsTextView.userInteractionEnabled = NO;
}

-(void)activateValues {
    self.goButton.userInteractionEnabled = YES;
    self.binButton.userInteractionEnabled=YES;
    self.quantityButton.userInteractionEnabled=YES;
    self.reorderView.userInteractionEnabled=YES;
    self.reasonButton.userInteractionEnabled=YES;
    self.proccedButton.userInteractionEnabled=YES;
    self.toggleButton.userInteractionEnabled=YES;
    self.commentsTextView.userInteractionEnabled = YES;
}

-(void)showAlertBox:(NSString*)aMessage {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ShopFloor"
                                                        message:aMessage delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
    [alertView show];
}

-(void)serviceCallToGetMaterialDescription{
    [self.materialIDTextfield resignFirstResponder];
    
    // Set values
    [[NSUserDefaults standardUserDefaults] setValue:[self getStorageLocationKeyValue:self.storageButton.titleLabel.text]
                                             forKey:STORAGE_LOCATION];
    [[NSUserDefaults standardUserDefaults] setValue:self.materialIDTextfield.text
                                             forKey:MATERIAL_ID];
    NSLog(@"vvv %@",[self getStorageLocationKeyValue:self.storageButton.titleLabel.text]);
    // Success
    [Global
     showWaitIndicatorWithTitle:[NSString
                                 stringWithFormat:@"%@..!",@"Searching SAP Material Master"]];
    BOOL isValid = [[Global sharedInstance] isNetworkReachable];
    if (isValid) {
        [[APIsManager sharedManager] getMaterialDescription:@""
                                            completionBlock:^(NSDictionary *responseDictonary){
                                                NSLog(@"resonse %@", responseDictonary);
                                                if ([[responseDictonary allKeys] containsObject:@"MaterialDescription"]){
                                                    self.materialDescriptiontextView.text = [responseDictonary
                                                                                             valueForKey:@"MaterialDescription"];
                                                    self.materialDesReorderTextView.text = [responseDictonary
                                                                                            valueForKey:@"MaterialDescription"];
                                                    self.materialReorderTextField.text = self.materialIDTextfield.text;
                                                    // Call the other web service for bin number
                                                    [self serviceCallToGetBIN];
                                                }
                                                else if ([[responseDictonary allKeys] containsObject:@"Message"]){
                                                    [self showAlertBox:[NSString stringWithFormat:@"%@ %@ %@",
                                                                        self.materialIDTextfield.text,[responseDictonary
                                                                                                       objectForKey:@"Message"],
                                                                        self.storageButton.titleLabel.text]];
                                                }
                                                else if ([[responseDictonary allKeys] containsObject:@"Error"]){
                                                    [self showAlertBox:[responseDictonary objectForKey:@"Error"]];
                                                }
                                                else {
                                                    [self showAlertBox:[responseDictonary
                                                                        objectForKey:@"Server not responsing. Please try after sometime."]];
                                                }
                                            }];
    }
    else {
        [Global hideWaitIndicator];
        [self showAlertBox:@"Please check your network connection"];
    }
}

-(void)serviceCallToGetBIN {
    [Global
     showWaitIndicatorWithTitle:[NSString stringWithFormat:@"%@..!",@"Searching SAP Material Master"]];
    BOOL isValid = [[Global sharedInstance] isNetworkReachable];
    if (isValid) {
        [[APIsManager sharedManager] getBinNumber:@"" storageLocation:@""
                                  completionBlock:^(NSDictionary *responseDictonary){
            NSLog(@"resonse %@", responseDictonary);
            if ([[responseDictonary allKeys] containsObject:@"StorageBin"]){
                // check if it is array.. check in response if data is comma seperated
                self.binButton.titleLabel.text = [responseDictonary valueForKey:@"StorageBin"];
                _pickerData = [[NSArray alloc]
                               initWithObjects:[responseDictonary
                                                valueForKey:@"StorageBin"], nil];
                [[NSUserDefaults standardUserDefaults] setValue:[responseDictonary
                                                                 valueForKey:@"StorageBin"] forKey:BIN];
                [self activateValues];
            }
            else if ([[responseDictonary allKeys] containsObject:@"Message"]){
                [self showAlertBox:[responseDictonary objectForKey:@"Message"]];
            }
            else if ([[responseDictonary allKeys] containsObject:@"Error"]){
                [self showAlertBox:[responseDictonary objectForKey:@"Error"]];
            }
            else {
                [self showAlertBox:[responseDictonary
                                    objectForKey:@"Server not responsing. Please try after sometime."]];
            }
            [Global hideWaitIndicator];
        }];
    }
    else {
        [Global hideWaitIndicator];
        [self showAlertBox:@"Please check your network connection"];
    }
}

-(NSString*)getStorageLocationKeyValue:(NSString*)aStorageLocation {
    
    if ([aStorageLocation isEqualToString:@"S004 : IM HU SYTomahawk"]){
        return @"S004";
    }
     else if ([aStorageLocation isEqualToString:@"S005 : IM SY NCM 2"]){
        return @"S005";
    }
    else if ([aStorageLocation isEqualToString:@"S006 : DO NOT USE"]){
        return @"S006";
    }
    else if ([aStorageLocation isEqualToString:@"S007 : IM SY ASY FG YBC"]){
        return @"S007";
    }
    else if ([aStorageLocation isEqualToString:@"S008 : IM SY NCM YBC"]){
        return @"S008";
    }
    else if ([aStorageLocation isEqualToString: @"S009 : IM SY NCM rework"]){
        return @"S009";
    }
    else if ([aStorageLocation isEqualToString: @"S010 : IM SY New Prts"]){
        return @"S010";
    }
    else if ([aStorageLocation isEqualToString:@"S011 : IM SY Zn A"]){
        return @"S011";
    }
    else if ([aStorageLocation isEqualToString:@"S012 : IM SY Zn B"]){
        return @"S012";
    }
    else if ([aStorageLocation isEqualToString:@"S013 : IM SY Zn C"]){
        return @"S013";
    }
    else if ([aStorageLocation isEqualToString:@"S014 : IM SY Zn D"]){
        return @"S014";
    }
    else if ([aStorageLocation isEqualToString:@"S015 : IM SY Zn E Main"]){
        return @"S015";
    }
    else if ([aStorageLocation isEqualToString:@"S016 : IM SY Zn F Main"]){
        return @"S016";
    }
    else if ([aStorageLocation isEqualToString:@"S021 : IM SY Zn W"]){
        return @"S021";
    }
    else if ([aStorageLocation isEqualToString:@"S022 : IM SY Zn PTO"]){
        return @"S022";
    }
    else if ([aStorageLocation isEqualToString:@"S030 : IM HU SY  PTO"]){
        return @"S030";
    }
    else if ([aStorageLocation isEqualToString:@"S031 : IM HU SY  CVO"]){
        return @"S031";
    }
    else if ([aStorageLocation isEqualToString:@"S035 : IM SY CKD F.Asy"]){
        return @"S035";
    }
    else if ([aStorageLocation isEqualToString:@"S036 : IM SY P-A  F.Asy"]){
        return @"S036";
    }
    else if ([aStorageLocation isEqualToString:@"S101 : WM Assly LinePOU"]){
        return @"S101";
    }
    else if ([aStorageLocation isEqualToString:@"S103 : IM Yrk Intransit"]){
        return @"S103";
    }
    else if ([aStorageLocation isEqualToString:@"S105 : IM Fin Bk RE-CIC"]){
        return @"S105";
    }
    else if ([aStorageLocation isEqualToString:@"S106 : IM Bk WIP repair"]){
        return @"S106";
    }
    else if ([aStorageLocation isEqualToString:@"S107 : IM Asy POU Anxtr"]){
        return @"S107";
    }
    else if ([aStorageLocation isEqualToString:@"S201 : IM Fab RackStore"]){
        return @"S201";
    }
    else if ([aStorageLocation isEqualToString: @"S203 : IM Fab FramePres"]){
        return @"S203";
    }
    else if ([aStorageLocation isEqualToString:@"S204 : IM Fab Fin Frame"]){
        return @"S204";
    }
    else if ([aStorageLocation isEqualToString:@"S205 : IM Fab Tnk Press"]){
        return @"S205";
    }
     else if ([aStorageLocation isEqualToString:@"S207 : IM Fab Fin Tank"]){
         return @"S207";
     }
    else if ([aStorageLocation isEqualToString:@"S208 : IM Fab FendPress"]){
        return @"S208";
    }
    else if ([aStorageLocation isEqualToString:@"S209 : IM Fab Fin Fendr"]){
        return @"S209";
    }
    else if ([aStorageLocation isEqualToString:@"S301 : IM Paint  WIP"]){
        return @"S301";
    }
    else if ([aStorageLocation isEqualToString:@"S302 : IM Paint  E-Coat"]){
        return @"S302";
    }
    else if ([aStorageLocation isEqualToString:@"S303 : IM Pnt MMile Avl"]){
        return @"S303";
    }
    else if ([aStorageLocation isEqualToString:@"S304 : IM Paint Strip"]){
        return @"S304";
    }
    else if ([aStorageLocation isEqualToString:@"S305 : IM Pnt P-A parts"]){
        return @"S305";
    }
    else if ([aStorageLocation isEqualToString:@"S307 : IM Paint  Rework"]){
        return @"S307";
    }
    else if ([aStorageLocation isEqualToString:@"S351 : IM New Parts Yrk"]){
        return @"S351";
    }
    else if ([aStorageLocation isEqualToString:@"S352 : IM Process Lab"]){
        return @"S352";
    }
    else if ([aStorageLocation isEqualToString:@"S401 : IM MRO Tooling"]){
        return @"S401";
    }
    else if ([aStorageLocation isEqualToString:@"S402 : IM MRO Overflow"]){
        return @"S402";
    }
    else if ([aStorageLocation isEqualToString:@"S403 : IM MRO Warranty"]){
        return @"S403";
    }
    else if ([aStorageLocation isEqualToString:@"S404 : IM Indirect Gen."]){
        return @"S404";
    }
    else if ([aStorageLocation isEqualToString:@"S405 : IM MRO Henkel"]){
        return @"S405";
    }
    else if ([aStorageLocation isEqualToString:@"S406 : IM MRO Outside"]){
        return @"S406";
    }
    else if ([aStorageLocation isEqualToString:@"S407 : IM MRO NCM"]){
        return @"S407";
    }
    else if ([aStorageLocation isEqualToString:@"S408 : IM MRO Scrap"]){
        return @"S408";
    }
    else if ([aStorageLocation isEqualToString:@"S501 : IM Crane  Comp"]){
        return @"S501";
    }
    else if ([aStorageLocation isEqualToString:@"S502 : IM Crane Assly"]){
        return @"S502";
    }
    else if ([aStorageLocation isEqualToString:@"S503 : IM Crane FG"]){
        return @"S503";
    }
    else if ([aStorageLocation isEqualToString:@"S601 : IM CKD AS TK HU"]){
        return @"S601";
    }
    else if ([aStorageLocation isEqualToString:@"S602 : IM CKD YRK Assly"]){
        return @"S602";
    }
    else if ([aStorageLocation isEqualToString:@"S603 : IM HU CKD Yrk FG"]){
        return @"S603";
    }
    else if ([aStorageLocation isEqualToString:@"S651 : IM P-A General"]){
        return @"S651";
    }
    else if ([aStorageLocation isEqualToString:@"S700 : IM Plant NCM"]){
        return @"S700";
    }
    else if ([aStorageLocation isEqualToString:@"S701 : IM Plnt Rework"]){
        return @"S701";
    }
    else if ([aStorageLocation isEqualToString:@"S702 : IM Rework Extl"]){
        return @"S702";
    }
    else if ([aStorageLocation isEqualToString:@"S703 : IM Scrap Extl"]){
        return @"S703";
    }
    else if ([aStorageLocation isEqualToString:@"S704 : IM NCMTrailerYRK"]){
        return @"S704";
    }
    else if ([aStorageLocation isEqualToString:@"S803 : IM M-M Operation"]){
        return @"S803";
    }
    else if ([aStorageLocation isEqualToString:@"S804 : IM M-M Rework"]){
        return @"S804";
    }
    else if ([aStorageLocation isEqualToString:@"S805 : IM OSS AFR Paint"]){
        return @"S805";
    }
    else if ([aStorageLocation isEqualToString: @"S806 : IM OSS  Surtech"]){
        return @"S806";
    }
    else if ([aStorageLocation isEqualToString:@"S807 : IM OSS StrpItCln"]){
        return @"S807";
    }
    else if ([aStorageLocation isEqualToString:@"S808 : IM OSS USI"]){
        return @"S808";
    }
    else if ([aStorageLocation isEqualToString:@"SP04 : IM Partner S603"]){
        return @"SP04";
    }
    else if ([aStorageLocation isEqualToString:@"SP05 : IM Partner S601"]){
        return @"SP05";
    }
    else if ([aStorageLocation isEqualToString:@"SP06 : IM Partner S004"]){
        return @"SP06";
    }
    else if ([aStorageLocation isEqualToString:@"SP07 : IM Partner S030"]){
        return @"SP07";
    }
    else if ([aStorageLocation isEqualToString:@"SP08 : IM Partner S031"]){
        return @"SP08";
    }
    else if ([aStorageLocation isEqualToString:@"SYC1 : DO NOT USE"]){
        return @"SYC1";
    }
    else if ([aStorageLocation isEqualToString:@"SYC2 : SYC WM MVC"]){
        return @"SYC2";
    }
    else if ([aStorageLocation isEqualToString:@"SYC3 : SYC WM YBC"]){
        return @"SYC3";
    }
    else {
    return @"";
    }
}

-(NSString*)getQuantityKeyValue:(NSString*)aQuantity{
    if ([aQuantity isEqualToString:@"Quantity: 1"]){
    return @"1";
    }
    else if ([aQuantity isEqualToString:@"Quantity: 2"]){
        return @"2";
    }
    else if ([aQuantity isEqualToString:@"Quantity: 3"]){
        return @"3";
    }
    else if ([aQuantity isEqualToString:@"Quantity: 4"]){
        return @"4";
    }
    else if ([aQuantity isEqualToString:@"Quantity: 5"]){
        return @"5";
    }
    else if ([aQuantity isEqualToString:@"Quantity: 6"]){
        return @"6";
    }
    else {
    return @"";
    }
}

-(NSString*)getReasonKeyValue:(NSString*)aReason{
    if ([aReason isEqualToString:@"Reason: NCM - Print Label"]){
    return @"001";
    }
    else if ([aReason isEqualToString:@"Reason: MRO Cores"]){
        return @"002";
    }
    else if ([aReason isEqualToString:@"Reason: Hold- Insp /Warranty"]){
        return @"003";
    }
    else if ([aReason isEqualToString:@"Reason: Running Charge"]){
        return @"004";
    }
    else if ([aReason isEqualToString:@"Reason: New Product"]){
        return @"005";
    }
    else if ([aReason isEqualToString:@"Reason: Quality"]){
        return @"006";
    }
    else if ([aReason isEqualToString:@"Reason: Paint Strip"]){
        return @"007";
    }
    else if ([aReason isEqualToString:@"Reason: Inventory Discrepancy"]){
        return @"008";
    }
    else if ([aReason isEqualToString:@"Reason: Mis-Labeled"]){
        return @"009";
    }
    else {
    return @"";
    }
}

-(void)sample {
    
    BOOL isValid = [[Global sharedInstance] isNetworkReachable];
    if (isValid) {
        [Global
         showWaitIndicatorWithTitle:[NSString stringWithFormat:@"%@..!",@"Performing Inventory Movement"]];
        [[APIsManager sharedManager] setInventoryMovement:@"" quantity:@"" reason:@"" postingDate:@"" storageLocation:@"" workStation:@"" comments:@"" bin:@""
                                  completionBlock:^(NSDictionary *responseDictonary){
                                      NSLog(@"resonse %@", responseDictonary);
                                      if ([[responseDictonary allKeys] containsObject:@"Inventory"]){
                                          if ([[responseDictonary
                                                objectForKey:@"Inventory"]
                                               isEqualToString:@"TRANSACTION EXECUTED OK"]){
                                              UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ShopFloor"
                                                                                                  message:[responseDictonary objectForKey:@"Inventory"] delegate:self
                                                                                        cancelButtonTitle:@"OK"
                                                                                        otherButtonTitles: nil];
                                              alertView.tag=100;
                                              [alertView show];
                                          }
                                          else {
                                              [self showAlertBox:[responseDictonary objectForKey:@"Inventory"]];
                                          }
                                      }
                                      else if ([[responseDictonary allKeys] containsObject:@"Error"]){
                                          [self showAlertBox:[responseDictonary objectForKey:@"Error"]];
                                      }
                                      else {
                                          [self showAlertBox:[responseDictonary
                                                              objectForKey:@"Server not responsing. Please try after sometime."]];
                                      }
                                      [Global hideWaitIndicator];
                                  }];
    }
    else {
        [Global hideWaitIndicator];
        [self showAlertBox:@"Please check your network connection"];
    }


/*    BOOL isValid = [[Global sharedInstance] isNetworkReachable];
    if (isValid) {
        [Global
         showWaitIndicatorWithTitle:[NSString stringWithFormat:@"%@..!",@"Performing Inventory Movement"]];
        [[APIsManager sharedManager] getBinNumber:@"" storageLocation:@""
                                  completionBlock:^(NSDictionary *responseDictonary){
            NSLog(@"resonse %@", responseDictonary);
            if ([[responseDictonary allKeys] containsObject:@"StorageBin"]){
                self.materialIDTextfield.text = [responseDictonary valueForKey:@"StorageBin"];
            }
            else if ([[responseDictonary allKeys] containsObject:@"Message"]){
                [self showAlertBox:[responseDictonary objectForKey:@"Message"]];
            }
            else if ([[responseDictonary allKeys] containsObject:@"Error"]){
                [self showAlertBox:[responseDictonary objectForKey:@"Error"]];
            }
            else {
                [self showAlertBox:[responseDictonary
                                    objectForKey:@"Server not responsing. Please try after sometime."]];
            }
            [Global hideWaitIndicator];
        }];
    }
    else {
        [Global hideWaitIndicator];
        [self showAlertBox:@"Please check your network connection"];
    }*/
}
/**
 *  Determines if the current NSString is numeric or not. It also accounts for the localised (Germany for example use "," instead of ".") decimal point and includes these as a valid number.
 *
 *  @return BOOL - True if the string is numeric.
 */

- (void)checkIfNumeric:(NSString*)aString {
    // Look for 0-n digits from start to finish
    NSRegularExpression *noFunnyStuff = [NSRegularExpression
                                         regularExpressionWithPattern:@"^(?:|0|[1-9]\\d*)(?:\\.\\d*)?$"
                                         options:0 error:nil];
    
    // There should be just one match
    if ([noFunnyStuff numberOfMatchesInString:aString options:0
                                        range:NSMakeRange(0, aString.length)] == 1)
    {
        // Yay, digits! add preceeding zeros to make length 18
        NSNumberFormatter * numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setPaddingPosition:NSNumberFormatterPadBeforePrefix];
        [numberFormatter setPaddingCharacter:@"0"];
        [numberFormatter setMinimumIntegerDigits:18];
        
        NSNumber * number = [NSNumber numberWithInt:[aString intValue]];
        
        NSString * numberString = [numberFormatter stringFromNumber:number];
        
        NSLog(@"cccc %@", numberString);
        self.barcodeString = numberString;
    }
    else {
        self.barcodeString = aString;
    }
}

#pragma Barcode scan
// Add the delegates of linea sdk
- (void)setLieaDelegates {
    
    // Set the linea delegate
    self.linea =[Linea sharedDevice];
    [self.linea addDelegate:self];
    [self.linea connect];
    int lineaStatus = [[Linea sharedDevice] connstate];
    
    if (lineaStatus == CONN_DISCONNECTED) {
        // Device is disconnected.
        //peripheral is disconnected. Please connect and click the button.
        [self showAlertBox:@"peripheral is disconnected. Please connect and click the button."];
    }
    else  if (lineaStatus == CONN_CONNECTED){
        
        // Device is connected.
        NSError *error;
        
        [self.linea barcodeSetScanButtonMode:BUTTON_ENABLED error:&error];
        [self.linea barcodeSetTypeMode:BARCODE_TYPE_EXTENDED error:&error];
        [self.linea barcodeEnginePowerControl:YES maxTimeMinutes:15 error:&error];

    }
    else {
    }
}

#pragma mark - Barcode delegate

-(void)barcodeData:(NSString *)barcode type:(int)type {
    
    // You can use this data as you wish
    // Here I write barcode data into the console
    NSLog(@"Barcode data : %@", barcode);
    if (self.toggleButton.selectedSegmentIndex == 0){
    if ([barcode characterAtIndex:0] == '*' &&
        [barcode characterAtIndex:[barcode length]-1]){
        NSString *trimmedString =  [barcode substringFromIndex:1];
        NSString *truncatedString = [trimmedString
                                     substringWithRange:NSMakeRange(0, [trimmedString length]-1)];
        if ([truncatedString characterAtIndex:0] == 'P'||
            [truncatedString characterAtIndex:0] == 'p'){
            NSString *removedString=[truncatedString substringFromIndex:1];
            [self checkIfNumeric:removedString];
            }
        else {
            [self checkIfNumeric:truncatedString];
        }
    }
    else {
        if ([barcode characterAtIndex:0] == 'P'||
            [barcode characterAtIndex:0] == 'p'){
            NSString *removedString=[barcode substringFromIndex:1];
            [self checkIfNumeric:removedString];
        }
        else {
            [self checkIfNumeric:barcode];
        }
    }
    self.materialIDTextfield.text = self.barcodeString;
    self.materialReorderTextField.text = self.barcodeString;
        
        // make the web service call
        [self serviceCallToGetMaterialDescription];
    }
    else {
        self.commentsTextView.text = barcode;
    }
}

@end
