//
//  PrinterViewController.m
//  ShopFloor
//
//  Created by Kavita Deshmukh on 10/09/15.
//  Copyright (c) 2015 Infosys. All rights reserved.
//

#import "PrinterViewController.h"
#import "Global.h"
#import "APIsManager.h"
#import "Constants.h"

@interface PrinterViewController (){
NSArray * _pickerData;
}

@end

@implementation PrinterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.customPickerViewObject = [[UICustomPicker alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)cancelButton_ToucUpInside:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)backButton_TouchUpInside:(id)sender {
   [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)saveButton_ToucUpInside:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] setValue:[self getWorkStationValue:self.printerButton.titleLabel.text]
                                             forKey:PRINTER_SELECTED];
    
    // set the current date
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"yyyyMMdd"];
    NSString *date = [dateformate stringFromDate:[NSDate date]];
    NSLog(@"date :%@",date);
    [[NSUserDefaults standardUserDefaults] setValue:date forKey:CURRENT_DATE];
    
    BOOL isValid = [[Global sharedInstance] isNetworkReachable];
    if (isValid) {
        [Global
         showWaitIndicatorWithTitle:[NSString stringWithFormat:@"%@..!",@"Performing Inventory Movement"]];
        [[APIsManager sharedManager] setInventoryMovement:@"" quantity:@"" reason:@""
                                              postingDate:@"" storageLocation:@"" workStation:@""
                                                 comments:@"" bin:@""
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

}
-(IBAction)printerButton_TouchUpInside:(id)sender {
    _pickerData = [[NSArray alloc] initWithObjects:@"32 - NCM ASSY - LEG E - S101",@"33 - NCM FAB FRAME - S203",@"34 - NCM FAB TANK WELD - S205", nil];
    [self.customPickerViewObject initWithCustomPicker:
     CGRectMake(0, 0, self.view.frame.size.width, 160)
                                               inView:self.view
                                          ContentSize:CGSizeMake(self.view.frame.size.width, 160)
                                           pickerSize:CGRectMake(0, 0, self.view.frame.size.width, 160)
                                             barStyle:UIBarStyleBlack
                                             Recevier:self.printerButton
                                       componentArray:(NSMutableArray*)_pickerData
                                         toolBartitle:@"Printer"
                                            textColor:[UIColor whiteColor]
                                           needToSort:NO needMultiSelection:NO
                                          withDictKey:@"name"];

}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
-(NSString*)getWorkStationValue:(NSString*)aPrinter{
    if ([aPrinter isEqualToString:@"32 - NCM ASSY - LEG E - S101"]){
    return @"HYRKSF40FE7E";
    }
    if ([aPrinter isEqualToString:@"33 - NCM FAB FRAME - S203"]){
        return @"HYRKSF14D58E";
    }
    if ([aPrinter isEqualToString:@"34 - NCM FAB TANK WELD - S205"]){
        return @"HYRKSF15161E";
    }
    else {
    return @"";
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag==100){
        [self.navigationController popToViewController:
         [self.navigationController.viewControllers
          objectAtIndex:self.navigationController.viewControllers.count-3]
                                              animated:YES];
    }
}

-(void)showAlertBox:(NSString*)aMessage {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ShopFloor"
                                                        message:aMessage delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
    [alertView show];
}
@end
