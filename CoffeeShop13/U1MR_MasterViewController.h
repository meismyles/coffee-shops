//
//  U1MR_MasterViewController.h
//  CoffeeShop13
//
//  Created by Myles Ringle on 11/12/2013.
//  Copyright (c) 2013 Myles Ringle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "U1MR_CoffeeHouseTableViewController.h"

@class U1MR_DetailViewController;

@interface U1MR_MasterViewController : UITableViewController

@property (strong, nonatomic) U1MR_DetailViewController *detailViewController;

@end
