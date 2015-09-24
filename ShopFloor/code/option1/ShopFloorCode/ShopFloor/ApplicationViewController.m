//
//  ApplicationViewController.m
//  ShopFloor
//
//  Created by Kavita Deshmukh on 10/09/15.
//  Copyright (c) 2015 Infosys. All rights reserved.
//

#import "ApplicationViewController.h"
#import "HomeTableViewCell.h"
#import "NCMViewController.h"

@interface ApplicationViewController ()

@end

@implementation ApplicationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma ----
#pragma UITableView  Delegate And DataSource METHODS
#pragma -----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
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
       UIImageView *iconImageView = (UIImageView *)[cell viewWithTag:100];
        iconImageView.backgroundColor = [UIColor clearColor];
            iconImageView.image = [UIImage imageNamed:@"icon_bike"];
        
        UILabel *titleNameLabel = (UILabel *)[cell viewWithTag:101];
        titleNameLabel.text = @"Bike History";
    }
    else if (indexPath.row == 1){
        UIImageView *iconImageView = (UIImageView *)[cell viewWithTag:100];
        iconImageView.backgroundColor = [UIColor clearColor];
        iconImageView.image = [UIImage imageNamed:@"icon_downtimetracking"];
        
        UILabel *titleNameLabel = (UILabel *)[cell viewWithTag:101];
        titleNameLabel.text = @"Downtime Tracking";
    }
    else if (indexPath.row == 2){
        UIImageView *iconImageView = (UIImageView *)[cell viewWithTag:100];
        iconImageView.backgroundColor = [UIColor clearColor];
        iconImageView.image = [UIImage imageNamed:@"icon_ncm_expeditor"];
        
        UILabel *titleNameLabel = (UILabel *)[cell viewWithTag:101];
        titleNameLabel.text = @"NCM Expediter";
    }
    else if (indexPath.row == 3){
        UIImageView *iconImageView = (UIImageView *)[cell viewWithTag:100];
        iconImageView.backgroundColor = [UIColor clearColor];
        iconImageView.image = [UIImage imageNamed:@"icon_post_assembly"];
        
        UILabel *titleNameLabel = (UILabel *)[cell viewWithTag:101];
        titleNameLabel.text = @"Post Assembly";
    }
    else {
        UIImageView *iconImageView = (UIImageView *)[cell viewWithTag:100];
        iconImageView.backgroundColor = [UIColor clearColor];
        iconImageView.image = [UIImage imageNamed:@"icon_bike_defect"];
        
        UILabel *titleNameLabel = (UILabel *)[cell viewWithTag:101];
        titleNameLabel.text = @"Bike Defect";
    }
    
    UIImageView *arrowImageView = (UIImageView *)[cell viewWithTag:102];
    arrowImageView.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2)
        [self performSegueWithIdentifier:@"NCMViewController" sender:nil];
//    NCMViewController *loginController = (NCMViewController*)[self.storyboard
//                                                                  instantiateViewControllerWithIdentifier: @"NCMViewController"];
//  //  NCMViewController *viewController = [segue destinationViewController];
//    [self.navigationController pushViewController:loginController animated:YES];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
//    CustomObject *custObject = [arrayOfObjects objectAtIndex:[self.tableView indexPathForSelectedRow].row];
    //viewController.objectNeeded = custObject;
}


@end
