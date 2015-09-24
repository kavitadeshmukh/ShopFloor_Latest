//
//  VersionViewController.h
//  ShopFloor
//
//  Created by Kavita Deshmukh on 10/09/15.
//  Copyright (c) 2015 Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VersionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) IBOutlet UITableView *versionDisplayTableView;

// Methods
-(IBAction)backButon_ToucUpInside:(id)sender;
@end
