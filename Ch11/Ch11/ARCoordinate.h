//
//  ARCoordinate.h
//  Ch11
//
//  Created by Kyle Roche on 10/5/11.
//  Copyright (c) 2011 Apress. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ARAnnotation;

@interface ARCoordinate : NSObject {

}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *place;
@property (nonatomic) double distance;
@property (nonatomic) double inclination;
@property (nonatomic) double azimuth;

@property (nonatomic, retain) ARAnnotation *annotation;

- (id)initWithRadialDistance:(double)distance inclination:(double)inclination azimuth:(double)azimuth;
@end
