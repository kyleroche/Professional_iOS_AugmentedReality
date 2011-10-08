//
//  ARCoordinate.m
//  Ch11
//
//  Created by Kyle Roche on 10/5/11.
//  Copyright (c) 2011 Apress. All rights reserved.
//

#import "ARCoordinate.h"

@implementation ARCoordinate

@synthesize name = _name;
@synthesize place = _place;
@synthesize distance = _distance;
@synthesize inclination = _inclination;
@synthesize azimuth = _azimuth;
@synthesize annotation = _annotation;

- (id)initWithRadialDistance:(double)distance inclination:(double)inclination azimuth:(double)azimuth {
    if (self = [super init]) {
        _distance = distance;
        _inclination = inclination;
        _azimuth = azimuth;
    }
    return self;
}

- (void)dealloc {
    [_name release];
    _name = nil;
    [_place release];
    _place = nil;
    [_annotation release];
    _annotation = nil;
}

@end
