//
//  U1MR_LocationAnnotation.h
//  CoffeeShop13
//
//  Created by Myles Ringle on 15/12/2013.
//  Copyright (c) 2013 Myles Ringle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface U1MR_LocationAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

// Creates a new coordinate object with a title, subtitle and coordinate.
- (id)initWithCoordinate:(CLLocationCoordinate2D)newCoordinate title:(NSString *)newTitle subtitle:(NSString *)newSubtitle;

@end