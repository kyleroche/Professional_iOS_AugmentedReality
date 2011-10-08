//
//  ARController.h
//  Ch11
//
//  Created by Kyle Roche on 10/4/11.
//  Copyright (c) 2011 Apress. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@class ARCoordinate;
@class ARGeoCoordinate;

@interface ARController : NSObject <UIAccelerometerDelegate, CLLocationManagerDelegate> {
	NSMutableArray *_coordinates;
}

@property (nonatomic, retain) UIViewController *rootViewController;
@property (nonatomic, retain) UIImagePickerController *pickerController;
@property (nonatomic, retain) UIView *hudView;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) UIAccelerometer *accelerometer;

@property (nonatomic) UIDeviceOrientation deviceOrientation;
@property (nonatomic) double range;

@property (nonatomic, retain) CLLocation *deviceLocation;
@property (nonatomic, retain) CLHeading *deviceHeading;

@property (nonatomic, retain) ARCoordinate *coordinate;
@property (nonatomic) double viewAngle;

- (id)initWithViewController:(UIViewController *)viewController;
- (void)presentModalARControllerAnimated:(BOOL)animated;

- (void)addCoordinate:(ARCoordinate *)coordinate animated:(BOOL)animated;
- (void)removeCoordinate:(ARCoordinate *)coordiante animated:(BOOL)animated;

@end
