//
//  U1MR_DetailViewController.h
//  CoffeeShop13
//
//  Created by Myles Ringle on 11/12/2013.
//  Copyright (c) 2013 Myles Ringle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@protocol U1MR_DetailViewControllerDelegate;

@interface U1MR_DetailViewController : UIViewController <UISplitViewControllerDelegate,CLLocationManagerDelegate>

@property (nonatomic, weak) id <U1MR_DetailViewControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocation *lastLocation;

@end

// Protocol and method for the delegate
@protocol U1MR_DetailViewControllerDelegate

- (void)setUsersCurrentLocation:(CLLocation *)usersLocation;

@end
