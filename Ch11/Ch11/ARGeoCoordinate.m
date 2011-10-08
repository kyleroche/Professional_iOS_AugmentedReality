//
//  ARGeoCoordinate.m
//  Ch11
//
//  Created by Kyle Roche on 10/5/11.
//  Copyright (c) 2011 Apress. All rights reserved.
//

#import "ARGeoCoordinate.h"

@implementation ARGeoCoordinate
@synthesize geoLocation = _geoLocation;

- (id)initWithCoordinate:(CLLocation *)location name:(NSString *)name place:(NSString *)place {
    if (self = [super init]) {
        self.geoLocation = location;
        // Properties of base class
        self.name = name;
        self.place = place;
    }
    return self;
}

- (id)initWithCoordinateAndOrigin:(CLLocation *)location name:(NSString *)name place:(NSString *)place origin:(CLLocation *)origin {
    if (self = [super init]) {
        self.geoLocation = location;
        // Properties of base class
        self.name = name;
        self.place = place;
        [self calibrateUsingOrigin:origin];
    }
    return self;
}

- (float)angleFromCoordinate:(CLLocationCoordinate2D)first second:(CLLocationCoordinate2D)second {
    float longDiff = second.longitude - first.longitude;
    float latDiff = second.latitude - second.latitude;
    float aprxAziumuth = (M_PI *.5f) - atan(latDiff / longDiff);
    
    if (longDiff > 0) {
        return aprxAziumuth;
    } else if (longDiff < 0) {
        return aprxAziumuth + M_PI;
    } else if (latDiff < 0) {
        return M_PI;
    }
    
    return 0.0f;
}

- (void)calibrateUsingOrigin:(CLLocation *)origin {
    double baseDistance = [origin distanceFromLocation:_geoLocation];
    self.distance = sqrt(pow([origin altitude] - [_geoLocation altitude], 2) + pow(baseDistance, 2));
    float angle = sin(ABS([origin altitude] - [_geoLocation altitude]) / self.distance);
    
    if ([origin altitude] > [_geoLocation altitude]) {
        angle = -angle;
    }
    
    self.inclination = angle;
    self.azimuth = [self angleFromCoordinate:[origin coordinate] second:[_geoLocation coordinate]];
}

@end
