//
//  LoginViewController.m
//  ShopFloor
//
//  Created by Kavita Deshmukh on 10/09/15.
//  Copyright (c) 2015 Infosys. All rights reserved.
//

#import "LoginViewController.h"
#import "TabBarViewController.h"

@interface LoginViewController ()
@end

int movedup = 1;
@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // hide the navigation bar
    self.navigationController.navigationBarHidden = YES;
    self.loginButton.layer.cornerRadius = 5;
    self.cardenumberTextField.layer.cornerRadius = 5;
    
    // activate linea pro
    [self setLieaDelegates];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.linea removeDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    movedup =2;
    [UIView beginAnimations:@"MoveView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.5f];
    self.view.frame = CGRectMake(0, -150, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    movedup =1;
    [UIView beginAnimations:@"MoveDown" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.5f];
    self.view.frame = CGRectMake(0, self.view.frame.origin.y+150, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];

    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Barcode delegate

-(void)barcodeData:(NSString *)barcode type:(int)type {
    
    // You can use this data as you wish
    // Here I write barcode data into the console
    NSLog(@"Barcode data : %@", barcode);
    
    if ([barcode characterAtIndex:0] == '*'){
         NSString *truncatedString =  [barcode substringFromIndex:1];
        self.barcodeString = [truncatedString substringWithRange:NSMakeRange(0, [truncatedString length]-3)];
    }
    else {
        self.barcodeString = barcode;
    }
//    [self showAlertBox:barcode];
//    [self showAlertBox:self.barcodeString];
    
    if ([self.barcodeString isEqualToString:@"02039"]||
        [self.barcodeString isEqualToString:@"01458"]||
        [self.barcodeString isEqualToString:@"575188"]||
        [self.barcodeString isEqualToString:@"69274"]||
        [self.barcodeString isEqualToString:@"572722"]||
        [self.barcodeString isEqualToString:@"66949"]||
        [self.barcodeString isEqualToString:@"61600"]||
        [self.barcodeString isEqualToString:@"01129"]||
        [self.barcodeString isEqualToString:@"00406"]||
        [self.barcodeString isEqualToString:@"00310"]||
        [self.barcodeString isEqualToString:@"01820"]||
        [self.barcodeString isEqualToString:@"07185"]||
        [self.barcodeString isEqualToString:@"66257"]||
        [self.barcodeString isEqualToString:@"68821"]||
        [self.barcodeString isEqualToString:@"68820"]||
        [self.barcodeString isEqualToString:@"576703"]||
        [self.barcodeString isEqualToString:@"002565"]||
        [self.barcodeString isEqualToString:@"02039"]||
        [self.barcodeString isEqualToString:@"02121"]||
        [self.barcodeString isEqualToString:@"02565"]||
        [self.barcodeString isEqualToString:@"093314"]||
        [self.barcodeString isEqualToString:@"675794"]||
        [self.barcodeString isEqualToString:@"6513"]) {
        self.cardenumberTextField.text = self.barcodeString;
        TabBarViewController *tabBarViewController = (TabBarViewController*)[self.storyboard
                                                                             instantiateViewControllerWithIdentifier: @"TabBarViewController"];
        [self.navigationController pushViewController:tabBarViewController animated:YES];
    }
    else {
        [self showAlertBox:@"Card not authorized"];
    }
    
//    // Navigate to next screen
//    if ([self.barcodeString isEqualToString:@"Card not authorized"]){
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Card not authorized"
//                                                        delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//    }
//    else {
//        TabBarViewController *tabBarViewController = (TabBarViewController*)[self.storyboard
//                                                                             instantiateViewControllerWithIdentifier: @"TabBarViewController"];
//        [self.navigationController pushViewController:tabBarViewController animated:YES];
//    }
}


#pragma mark - magnetic card delegate
/**
 Notification sent when magnetic card is successfuly read
 @param track1 - data contained in track 1 of the magnetic card or nil
 @param track2 - data contained in track 2 of the magnetic card or nil
 @param track3 - data contained in track 3 of the magnetic card or nil
 **/
-(void)magneticCardData:(NSString *)track1 track2:(NSString *)track2 track3:(NSString *)track3 {
    
    @try
    {
        NSString *firstThree = [track1 substringFromIndex:3];
        NSString *truncatedString = [firstThree substringWithRange:NSMakeRange(0, [firstThree length]-3)];
        
        if ([truncatedString isEqualToString:@"02039"]||
            [truncatedString isEqualToString:@"01458"]||
            [truncatedString isEqualToString:@"575188"]||
            [truncatedString isEqualToString:@"69274"]||
            [truncatedString isEqualToString:@"572722"]||
            [truncatedString isEqualToString:@"66949"]||
            [truncatedString isEqualToString:@"61600"]||
            [truncatedString isEqualToString:@"01129"]||
            [truncatedString isEqualToString:@"00406"]||
            [truncatedString isEqualToString:@"00310"]||
            [truncatedString isEqualToString:@"01820"]||
            [truncatedString isEqualToString:@"07185"]||
            [truncatedString isEqualToString:@"66257"]||
            [truncatedString isEqualToString:@"68821"]||
            [truncatedString isEqualToString:@"68820"]||
            [truncatedString isEqualToString:@"576703"]||
            [truncatedString isEqualToString:@"002565"]||
            [truncatedString isEqualToString:@"02039"]||
            [truncatedString isEqualToString:@"02121"]||
            [truncatedString isEqualToString:@"02565"]||
            [truncatedString isEqualToString:@"093314"]||
            [truncatedString isEqualToString:@"675794"]){
            self.cardenumberTextField.text = truncatedString;
            TabBarViewController *tabBarViewController = (TabBarViewController*)[self.storyboard
                                                                                 instantiateViewControllerWithIdentifier: @"TabBarViewController"];
            [self.navigationController pushViewController:tabBarViewController animated:YES];
        }
        else {
            [self showAlertBox:@"Card not authorized"];
        }
        
    }
    @catch (NSException *exception)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:exception.description
                                                        delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}


#pragma mark - Navigation

-(IBAction)loginButton_TouchUpInside:(id)sender {
    
    // Move the view down
    if (movedup !=1){
    movedup =1;
    [UIView beginAnimations:@"MoveDown" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.5f];
    self.view.frame = CGRectMake(0, self.view.frame.origin.y+150, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    }
    [self.cardenumberTextField resignFirstResponder];
    
    // Navigate to next screen
    if (![self.cardenumberTextField.text isEqualToString:@""]){
        
        if ([self.cardenumberTextField.text isEqualToString:@"02039"]||[self.cardenumberTextField.text isEqualToString:@"575188"]||
            [self.cardenumberTextField.text isEqualToString:@"69274"]||[self.cardenumberTextField.text isEqualToString:@"572722"]||
            [self.cardenumberTextField.text isEqualToString:@"66949"]||[self.cardenumberTextField.text isEqualToString:@"61600"]||
            [self.cardenumberTextField.text isEqualToString:@"01129"]||[self.cardenumberTextField.text isEqualToString:@"00406"]||
            [self.cardenumberTextField.text isEqualToString:@"00310"]||[self.cardenumberTextField.text isEqualToString:@"01820"]||
            [self.cardenumberTextField.text isEqualToString:@"07185"]||[self.cardenumberTextField.text isEqualToString:@"01458"]||
            [self.cardenumberTextField.text isEqualToString:@"00574"]||[self.cardenumberTextField.text isEqualToString:@"574"]){
                TabBarViewController *tabBarViewController = (TabBarViewController*)[self.storyboard
                                                                              instantiateViewControllerWithIdentifier: @"TabBarViewController"];
                [self.navigationController pushViewController:tabBarViewController animated:YES];
        }
        else {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"ShopFloor" message:@"Card not authorized"
                                                            delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
    else {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"ShopFloor" message:@"Please enter card number"
                                                        delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)showAlertBox:(NSString*)aMessage {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ShopFloor"
                                                        message:aMessage delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
    [alertView show];
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
        [self.linea msEnable:&error];
        [self.linea barcodeEnginePowerControl:YES maxTimeMinutes:15 error:&error];
        // [linea barcodeEnginePowerControl:YES error:&error];
        [self.linea
         rfInit:CARD_SUPPORT_TYPE_A|CARD_SUPPORT_ISO15|CARD_SUPPORT_TYPE_B|
         CARD_SUPPORT_FELICA|CARD_SUPPORT_NFC|CARD_SUPPORT_JEWEL error:&error];
        
    }
    else {
    }
}

//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//    
//
//}



@end
