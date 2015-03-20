//
//  U1MR_CoffeeHouseTableViewController.h
//  CoffeeShop13
//
//  Created by Myles Ringle on 12/12/2013.
//  Copyright (c) 2013 Myles Ringle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "U1MR_DetailViewController.h"
#import "U1MR_LocationAnnotation.h"

@interface U1MR_CoffeeHouseTableViewController : UITableViewController <U1MR_DetailViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray *coffeeHouseList;
@property (strong, nonatomic) U1MR_DetailViewController *detailViewController;

@end
