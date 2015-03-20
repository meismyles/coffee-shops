//
//  U1MR_DetailViewController.m
//  CoffeeShop13
//
//  Created by Myles Ringle on 11/12/2013.
//  Copyright (c) 2013 Myles Ringle. All rights reserved.
//

#import "U1MR_DetailViewController.h"
#import "U1MR_CoffeeHouseTableViewController.h"

@interface U1MR_DetailViewController () {
    UIBarButtonItem *refreshButton;
}

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (assign, nonatomic) BOOL viewJustAppeared;

@end

@implementation U1MR_DetailViewController

@synthesize delegate;

// =================================================
#pragma mark - Life Cycle
// =================================================

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Set BOOL so we know the map view has just appeared
    [self setViewJustAppeared:YES];
    
    // Set the view title and add the user centering/tracking button to the navigation bar
    [[self navigationItem] setTitle:@"Map"];
    refreshButton = [[MKUserTrackingBarButtonItem alloc] initWithMapView:[self mapView]];
    [[self navigationItem] setRightBarButtonItem:refreshButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Start updating the location when the view appears
    [[self locationManager] startUpdatingLocation];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    // Stop updating the location when the view disappears
    [[self locationManager] stopUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// =================================================
#pragma mark - Core Location Methods
// =================================================

// Lazy instantiation of the location manager
- (CLLocationManager *)locationManager {
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
        [_locationManager setDistanceFilter:25];
        [_locationManager setDelegate:self];
        // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
    }
    return _locationManager;
}

// =================================================
#pragma mark - Core Location Delegate Methods
// =================================================

// Method handles when user location updates with no error.
- (void) locationManager:(CLLocationManager *)manager
     didUpdateToLocation:(CLLocation *)newLocation
            fromLocation:(CLLocation *)oldLocation {

    // Set the last location property so the last known location of the user is known
    [self setLastLocation:newLocation];
    
    // If the view has just appeared for the first time, refresh the coffee house VC by passing the new
    // location but also start tracking the user.
    if ([self viewJustAppeared]) {
        [[self delegate] setUsersCurrentLocation:newLocation]; // update the users location in the coffee house VC
        [self setViewJustAppeared:NO]; // set this NO so we don't re-enter this block next time
        [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES]; // start tracking the users location.
        return;
    }
    
    // Ensure that if we do something here, it is because we *are* in a different location
    if (([newLocation coordinate].latitude == [oldLocation coordinate].latitude) &&
        ([newLocation coordinate].longitude == [oldLocation coordinate].longitude)) {
        return;
    }

    // Update the users location in the coffee house VC
    [[self delegate] setUsersCurrentLocation:newLocation];
}

// Method handles when user location fails to update
- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    // For now, do nothing other than report to the log
    NSLog(@"Unable to get location events");
}

// =================================================
#pragma mark - Split View
// =================================================

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
