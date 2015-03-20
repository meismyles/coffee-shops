//
//  U1MR_MasterViewController.m
//  CoffeeShop13
//
//  Created by Myles Ringle on 11/12/2013.
//  Copyright (c) 2013 Myles Ringle. All rights reserved.
//

#import "U1MR_MasterViewController.h"

@interface U1MR_MasterViewController ()

@property (strong, nonatomic) NSArray *locationList;
@property (strong, nonatomic) U1MR_CoffeeHouseTableViewController *coffeeHouseTableView;

@end

@implementation U1MR_MasterViewController

// =================================================
#pragma mark - Life Cycle
// =================================================

- (void)awakeFromNib
{
    self.preferredContentSize = CGSizeMake(320.0, 600.0);
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Deselect a previously selected location group on returning to the master view
    [self setClearsSelectionOnViewWillAppear:YES];
    
    self.detailViewController = (U1MR_DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    self.navigationItem.title = @"Location Groups";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Method to retreive the coffe houses from the plist.
- (NSArray *) locationList {
    
    // If _coffeeHouseList array is nil, retreive the data.
    if (_locationList == nil) {
        
        // Set directory to retreive plist from.
        NSString *coffeeHouseListPath = [[NSBundle mainBundle] pathForResource:@"CityCycleRideLocations" ofType:@"plist"];
        
        // If the plist exists, extract the location lists from it and put into an array
        if ([[NSFileManager defaultManager] fileExistsAtPath:coffeeHouseListPath]) {
            _locationList = [NSArray arrayWithContentsOfFile:coffeeHouseListPath];
        }
    }
    return _locationList;
}

// =================================================
#pragma mark - Table View
// =================================================

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Only 1 section required, the different location groups
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Get the number of location groups
    return [[self locationList] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    // Re-use table view cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Set the title of the rows with their corresponding location title
    NSString *coffeeHouseLocation;
    if ([indexPath row] == 0) {
        coffeeHouseLocation = @"Liverpool Coffee Houses";
    }
    else {
        coffeeHouseLocation = @"Cupertino Coffee Houses";
    }
    [[cell textLabel] setText:coffeeHouseLocation];
    
    return cell;

}

// =================================================
#pragma mark - Segue Method
// =================================================

// Prepare to move to new view
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // Check that we are trying to move to a coffee house list
    if ([[segue identifier] isEqualToString:@"coffeeHouseTableSegue"]) {
        
        // Get the indexpath of the selected row to identify the selected location.
        // Extract the respective array of coffee houses from the full array.
        NSIndexPath *indexPath = [[self tableView] indexPathForSelectedRow];
        NSMutableArray *coffeeHouseList = [NSMutableArray arrayWithArray:[[self locationList] objectAtIndex:[indexPath row]]];
        
        // Create the coffee house VC instance and set this as the destination of the segue transition
        U1MR_CoffeeHouseTableViewController *coffeeHouseTableView = [segue destinationViewController];
        
        // Set the delegate of the detail view to be this new coffee house VC
        [[self detailViewController] setDelegate:coffeeHouseTableView];
        
        // Set the coffee house list of the new coffee house view to be the array we just extracted above
        [coffeeHouseTableView setCoffeeHouseList:coffeeHouseList];
        
        // Set the title of the coffee house VC depending on which was selected
        if ([indexPath row] == 0) {
            [[coffeeHouseTableView navigationItem] setTitle:@"Liverpool Coffee Houses"];
        }
        else {
            [[coffeeHouseTableView navigationItem] setTitle:@"Cupertino Coffee Houses"];
        }

    }
}

@end
