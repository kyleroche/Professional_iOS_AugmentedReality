//
//  ARGeoCoordinate.h
//  Ch11
//
//  Created by Kyle Roche on 10/5/11.
//  Copyright (c) 2011 Apress. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "ARCoordinate.h"

@interface ARGeoCoordinate : ARCoordinate {
    
}

@property (nonatomic, retain) CLLocation *geoLocation;

- (id)initWithCoordinate:(CLLocation *)location name:(NSString *)name place:(NSString *)place;
- (id)initWithCoordinateAndOrigin:(CLLocation *)location name:(NSString *)name place:(NSString *)place origin:(CLLocation *)origin;
- (float)angleFromCoordinate:(CLLocationCoordinate2D)first second:(CLLocationCoordinate2D)second;
- (void)calibrateUsingOrigin:(CLLocation *)origin;
@end
