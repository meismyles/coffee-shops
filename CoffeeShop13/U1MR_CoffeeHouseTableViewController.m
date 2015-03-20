//
//  U1MR_CoffeeHouseTableViewController.m
//  CoffeeShop13
//
//  Created by Myles Ringle on 12/12/2013.
//  Copyright (c) 2013 Myles Ringle. All rights reserved.
//

#import "U1MR_CoffeeHouseTableViewController.h"

@interface U1MR_CoffeeHouseTableViewController ()

@property (strong, nonatomic) CLLocation *userLocation;

@end

@implementation U1MR_CoffeeHouseTableViewController

// =================================================
#pragma mark - Life Cycle
// =================================================

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set a detail view property to that of the detail instance so we can access it
    self.detailViewController = (U1MR_DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];

    // Get the users last known location from the detail view
    [self setUserLocation:[[self detailViewController] lastLocation]];
    
    // Draw the annotations of the coffee houses on the map
    [self drawAnnotations];
    
    // Update the view.
    [self sortCoffeeHouseList];
}

// Method to remove the annotations when returning back to the master view
- (void) viewDidDisappear:(BOOL)animated {
    // Clear pins
    for (id<MKAnnotation> annotation in [[[self detailViewController] mapView] annotations]) {
        [[[self detailViewController] mapView] removeAnnotation:annotation];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// =================================================
#pragma mark - Location and Map Methods
// =================================================

// Method called by the detail when the users location updates.
- (void)setUsersCurrentLocation:(CLLocation *)usersLocation {

    // The users new location is passed here and set to be used elsewhere in the file
    [self setUserLocation:usersLocation];
    
    // Start the sorting process again since the location has updated
    [self sortCoffeeHouseList];
}

// Method to draw the annotations of the coffee houses on the map
- (void) drawAnnotations {
   
    // Loop iterates through each coffee house and draws an annotation for each
    for (int i = 0; i < [[self coffeeHouseList] count]; i++) {
        
        // Get the dictionary of information for the coffee house that corresponds to i
        NSDictionary *coffeeHouse = [[self coffeeHouseList] objectAtIndex:i];
        
        // Extract the name and comment for the coffee house
        NSString *coffeeHouseName = [coffeeHouse objectForKey:@"name"];
        NSString *coffeeHouseComment = [coffeeHouse objectForKey:@"comments"];
        
        // Extract the location of the coffee house
        CLLocation *coffeeHouseLocation = [[CLLocation alloc]
                                           initWithLatitude:[[coffeeHouse objectForKey:@"latitude"] doubleValue]
                                           longitude:[[coffeeHouse objectForKey:@"longitude"] doubleValue]];
        
        // Reverse lookup the location of the coffee house and then draw the annotation of the map
        CLGeocoder *gcrev = [[CLGeocoder alloc] init];
        [gcrev reverseGeocodeLocation:coffeeHouseLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            
            U1MR_LocationAnnotation *annotation = [[U1MR_LocationAnnotation alloc]
                                                   initWithCoordinate:[coffeeHouseLocation coordinate]
                                                   title:coffeeHouseName
                                                   subtitle:coffeeHouseComment];
            [[[self detailViewController] mapView] addAnnotation:annotation];
        }];
        
    }
    
}

// Method handles when an annotation is selected
- (void) selectAnnotationAtLocation:(CLLocation *)loc {
    
    // The location that has been selected
    CLLocationCoordinate2D myCoordinate = [loc coordinate];
    
    // Check if the location matches an annotation location and if so, show the annotation as selected
    for (id<MKAnnotation> annotation in [[[self detailViewController] mapView] annotations]) {
        if (([annotation coordinate].latitude == myCoordinate.latitude) &&
            ([annotation coordinate].longitude == myCoordinate.longitude))
            [[[self detailViewController] mapView] selectAnnotation:annotation animated:YES];
    }
}

// Method to calculate the proximity of the coffee house to the user and sort the list
- (void) sortCoffeeHouseList {
    
    // Loop to iterate through each coffee house
    for (int i = 0; i < [[self coffeeHouseList] count]; i++) {
        
        // Get the dictionary of information for the coffee house that corresponds to i
        NSDictionary *coffeeHouse = [[self coffeeHouseList] objectAtIndex:i];
        
        // Extract the location of the coffee house from the dictionary
        CLLocation *coffeeHouseLocation = [[CLLocation alloc]
                                           initWithLatitude:[[coffeeHouse objectForKey:@"latitude"] doubleValue]
                                           longitude:[[coffeeHouse objectForKey:@"longitude"] doubleValue]];
        
        // Calculate the distance between the user and the coffee house (the proximity)
        CLLocationDistance distanceFromUser = [coffeeHouseLocation distanceFromLocation:[self userLocation]];
        
        // Create a new mutable dictionary that is the same as the previous one and then add the proximity to it
        NSMutableDictionary *coffeeHouseWithProximity = [[NSMutableDictionary alloc] initWithDictionary:coffeeHouse];
        [coffeeHouseWithProximity setValue:[NSNumber numberWithDouble: distanceFromUser] forKey:@"proximity"];
        
        // Replace the old dictionary with the new dictionary containing the proximity
        [[self coffeeHouseList] replaceObjectAtIndex:i withObject:coffeeHouseWithProximity];
         
    }
    
    // Sort the coffee houses by closest proximity
    NSArray *sortedArray;
    sortedArray = [[self coffeeHouseList] sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSNumber *first = [(NSMutableDictionary *)a objectForKey:@"proximity"];
        NSNumber *second = [(NSMutableDictionary *)b objectForKey:@"proximity"];
        return [first compare:second];
    }];
    
    // Set the coffee house list array to be the new sorted array
    [self setCoffeeHouseList:[NSMutableArray arrayWithArray:sortedArray]];
    
    // Reload the table to update the list
    [[self tableView] reloadData];
}

// =================================================
#pragma mark - Table View
// =================================================

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // 1 section for the coffee houses
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Get the number of coffee houses in the array
    return [[self coffeeHouseList] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    // Re-use table view cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    // Get the coffee house dictionary and extract the name
    NSDictionary *coffeeHouse = [[self coffeeHouseList] objectAtIndex:[indexPath row]];
    NSString *coffeeHouseName = [coffeeHouse objectForKey:@"name"];
    
    // Set the cell title as the coffee house name
    [[cell textLabel] setText:coffeeHouseName];
    
    // Extract the proximity to the user
    double distanceFromUser = [[coffeeHouse objectForKey:@"proximity"] doubleValue];
    NSString *distanceFromUserString;
    
    // Set the text colour to be black incase it was previously red
    [[cell detailTextLabel] setTextColor:[UIColor blackColor]];
    
    // Check if the users location is nil, i.e. unknown or none.
    if ([self userLocation] == nil) {
        distanceFromUserString = [NSString stringWithFormat:@"User location unknown."];
    }
    // Check if the users location is less that 1km to change the format to metres.
    else if (distanceFromUser < 1000) {
        distanceFromUserString = [NSString stringWithFormat:@"%.0f Metres Away",
                                            [[coffeeHouse objectForKey:@"proximity"] doubleValue]];
        // If the proximity is less than 200 metres make the text colour red
        if (distanceFromUser < 200) {
            [[cell detailTextLabel] setTextColor:[UIColor redColor]];
        }
    }
    // Otherwise the user is over 1km away so format the proximity in km
    else {
        distanceFromUserString = [NSString stringWithFormat:@"%.01f Kilometres Away",
                                  [[coffeeHouse objectForKey:@"proximity"] doubleValue]/1000];
    }

    [[cell detailTextLabel] setText:distanceFromUserString];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Don't keep the row selected
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    // As a coffee house has been selected, stop following the user
    [[[self detailViewController] mapView] setUserTrackingMode:MKUserTrackingModeNone];
    
    // Get the coffee house dictionary that has been selected
    NSDictionary *coffeeHouse = [[self coffeeHouseList] objectAtIndex:[indexPath row]];
    
    // Extract the location
    CLLocation *coffeeHouseLocation = [[CLLocation alloc]
                                       initWithLatitude:[[coffeeHouse objectForKey:@"latitude"] doubleValue]
                                       longitude:[[coffeeHouse objectForKey:@"longitude"] doubleValue]];
    
    // Call the method to show the annotation as selected
    [self selectAnnotationAtLocation:coffeeHouseLocation];
    
    // Center the map around the selected coffee house
    [[[self detailViewController] mapView] setCenterCoordinate:[coffeeHouseLocation coordinate] animated:YES];

}

@end
