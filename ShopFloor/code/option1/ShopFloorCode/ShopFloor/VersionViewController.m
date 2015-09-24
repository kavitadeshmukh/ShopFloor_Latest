//
//  VersionViewController.m
//  ShopFloor
//
//  Created by Kavita Deshmukh on 10/09/15.
//  Copyright (c) 2015 Infosys. All rights reserved.
//

#import "VersionViewController.h"

@interface VersionViewController ()

@end

@implementation VersionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backButon_ToucUpInside:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma ----
#pragma UITableView  Delegate And DataSource METHODS
#pragma -----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Display recipe in the table cell
    if (indexPath.row == 0){
        UILabel *versionLabel = (UILabel *)[cell viewWithTag:100];
        versionLabel.text = @"Version 1.1";
        UILabel *updateLabel = (UILabel *)[cell viewWithTag:101];
        updateLabel.text = @"Updated On : 12/10/2015";
        UITextView *describtionTextView = (UITextView *)[cell viewWithTag:102];
        describtionTextView.text = @"Static UI screens.";
    }
    else if (indexPath.row == 1){
        UILabel *versionLabel = (UILabel *)[cell viewWithTag:100];
        versionLabel.text = @"Version 1.0";
        UILabel *updateLabel = (UILabel *)[cell viewWithTag:101];
        updateLabel.text = @"Updated On : 12/10/2015";
        UITextView *describtionTextView = (UITextView *)[cell viewWithTag:102];
        describtionTextView.text = @"Static UI screens.";
    }
    else {
        UILabel *versionLabel = (UILabel *)[cell viewWithTag:100];
        versionLabel.text = @"Version 1.1";
        UILabel *updateLabel = (UILabel *)[cell viewWithTag:101];
        updateLabel.text = @"Updated On : 12/10/2015";
        UITextView *describtionTextView = (UITextView *)[cell viewWithTag:102];
        describtionTextView.text = @"Static UI screens.";
    }
    return cell;
}

@end
