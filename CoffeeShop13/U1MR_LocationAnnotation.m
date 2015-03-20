//
//  U1MR_LocationAnnotation.m
//  CoffeeShop13
//
//  Created by Myles Ringle on 15/12/2013.
//  Copyright (c) 2013 Myles Ringle. All rights reserved.
//

#import "U1MR_LocationAnnotation.h"

@interface U1MR_LocationAnnotation ()

@property (nonatomic, readwrite, copy) NSString *title;
@property (nonatomic, readwrite, copy) NSString *subtitle;
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;

@end

@implementation U1MR_LocationAnnotation

// Creates a new coordinate object with a title, subtitle and coordinate.
- (id)initWithCoordinate:(CLLocationCoordinate2D)newCoordinate title:(NSString *)newTitle subtitle:(NSString *)newSubtitle {
    
    if ((self = [super init])) {
        // Setting the various annotation properties.
        [self setTitle:[newTitle copy]];
        [self setSubtitle:[newSubtitle copy]];
        [self setCoordinate:newCoordinate];
    }
    return self;
}

@end
