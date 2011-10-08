//
//  ARController.m
//  Ch11
//
//  Created by Kyle Roche on 10/4/11.
//  Copyright (c) 2011 Apress. All rights reserved.
//

#import "ARController.h"
#import "ARCoordinate.h"
#import "ARGeoCoordinate.h"
#import "ARAnnotation.h"

@interface ARController (Private)
- (void)updateCurrentLocation:(CLLocation *)newLocation;
- (void)updateLocations;
- (void)updateCurrentCoordinate;
- (BOOL)viewportContainsCoordinate:(ARCoordinate *)coordinate;
- (double)deltaAzimuthForCoordinate:(ARCoordinate *)coordinate;
- (CGPoint)pointForCoordinate:(ARCoordinate *)coordinate;
- (BOOL)isNorthForCoordinate:(ARCoordinate *)coordinate;
@end

@implementation ARController
@synthesize rootViewController = _rootViewController;
@synthesize pickerController = _pickerController;
@synthesize hudView = _hudView;
@synthesize locationManager = _locationManager;
@synthesize accelerometer = _accelerometer;

@synthesize deviceOrientation = _deviceOrientation;
@synthesize range = _range;

@synthesize deviceHeading = _deviceHeading;
@synthesize deviceLocation = _deviceLocation;

@synthesize coordinate = _coordinate;

@synthesize viewAngle = _viewAngle;

- (id)initWithViewController:(UIViewController *)viewController {
    self.rootViewController = viewController;
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    self.hudView = [[UIView alloc] initWithFrame:screenBounds];
    self.rootViewController.view = self.hudView;
    
    self.pickerController = [[[UIImagePickerController alloc] init] autorelease];
	self.pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
	self.pickerController.cameraViewTransform = CGAffineTransformScale( self.pickerController.cameraViewTransform, 1.13f,  1.13f);
	
	self.pickerController.showsCameraControls = NO;
	self.pickerController.navigationBarHidden = YES;
	self.pickerController.cameraOverlayView = _hudView;
	
	self.locationManager = [[CLLocationManager alloc] init];
	self.locationManager.headingFilter = kCLHeadingFilterNone;
	self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	self.locationManager.delegate = self;
	[self.locationManager startUpdatingHeading];
	[self.locationManager startUpdatingLocation];
    
	_accelerometer = [UIAccelerometer sharedAccelerometer];
	_accelerometer.updateInterval = 0.25;
	_accelerometer.delegate = self;

    _coordinates = [[NSMutableArray alloc] init];
    _range = _hudView.bounds.size.width / 12; // new
    _deviceLocation = [[CLLocation alloc] initWithLatitude:37.33231 longitude:-122.03118];	 // new 
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];

    // set some initial values
    _coordinate = [[ARCoordinate alloc] initWithRadialDistance:1.0 inclination:0 azimuth:0];
    
    return self;
}

- (void)presentModalARControllerAnimated:(BOOL)animated {
    [self.rootViewController presentModalViewController:[self pickerController] animated:animated];
    _hudView.frame = _pickerController.view.bounds;
}

- (void)deviceOrientationDidChange:(NSNotification *)notification {
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    UIApplication *app = [UIApplication sharedApplication];
    
    if ( orientation != UIDeviceOrientationUnknown && 
        orientation != UIDeviceOrientationFaceUp && 
        orientation != UIDeviceOrientationFaceDown) {
		
		CGAffineTransform transform = CGAffineTransformMakeRotation(degreesToRadians(0));
		CGRect bounds = [[UIScreen mainScreen] bounds];
		[app setStatusBarHidden:YES];
		[app setStatusBarOrientation:UIInterfaceOrientationPortrait animated: NO];
		
		if (orientation == UIDeviceOrientationLandscapeLeft) {
			transform		   = CGAffineTransformMakeRotation(degreesToRadians(90));
			bounds.size.width  = [[UIScreen mainScreen] bounds].size.height;
			bounds.size.height = [[UIScreen mainScreen] bounds].size.width;
			[app setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated: NO];
            
		} else if (orientation == UIDeviceOrientationLandscapeRight) {
			transform		   = CGAffineTransformMakeRotation(degreesToRadians(-90));
			bounds.size.width  = [[UIScreen mainScreen] bounds].size.height;
			bounds.size.height = [[UIScreen mainScreen] bounds].size.width;
			[app setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated: NO];
			
		} else if (orientation == UIDeviceOrientationPortraitUpsideDown) {
			transform = CGAffineTransformMakeRotation(degreesToRadians(180));
			[app setStatusBarOrientation:UIInterfaceOrientationPortraitUpsideDown animated: NO];
            
		}
		_hudView.transform = transform;
		_hudView.bounds = bounds;
		_range = _hudView.bounds.size.width / 12;
        
	}
	_deviceOrientation = orientation;
}

- (void)updateCurrentLocation:(CLLocation *)newLocation {
	self.deviceLocation = newLocation;
	
	//NSLog(@"updateCurrentLocation: self.currentLocation = %@", self.deviceLocation );
	
	for (ARGeoCoordinate *geoLocation in _coordinates ) {
		if ( [geoLocation isKindOfClass:[ARGeoCoordinate class]]) {
			//NSLog(@"updateCurrentLocation: origin = %@", self.deviceLocation );
			[geoLocation calibrateUsingOrigin:self.deviceLocation];
		}
	}
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
	if (newHeading.headingAccuracy > 0) {
		_deviceHeading = newHeading;
		[self updateCurrentCoordinate];
	}
}

- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager {
	return YES;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	if (newLocation != oldLocation) {
		[self updateCurrentLocation:newLocation];
	}
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	//NSLog(@"Received Core Location error %@", error);
	[self.locationManager stopUpdatingLocation];
}

- (void)updateCurrentCoordinate {
	
	double adjustment = 0;
	if (_deviceOrientation == UIDeviceOrientationLandscapeLeft)
		adjustment = degreesToRadians(270); 
	else if (_deviceOrientation == UIDeviceOrientationLandscapeRight)
		adjustment = degreesToRadians(90);
	else if (_deviceOrientation == UIDeviceOrientationPortraitUpsideDown)
		adjustment = degreesToRadians(180);
    
	_coordinate.azimuth = degreesToRadians(_deviceHeading.magneticHeading) - adjustment;
    
	[self updateLocations];
}

- (void)updateLocations {
   // NSLog(@"Coordinate count: %d", [_coordinates count]);
	if ( !_coordinates || [_coordinates count] == 0 ) return;
	
	int totalDisplayed	= 0;
    
	for (ARCoordinate *item in _coordinates) {
		//NSLog(@"looking at coordinate");
		UIView *viewToDraw = item.annotation;
		
		if ([self viewportContainsCoordinate:item]) {
			
            //NSLog(@"found point in viewport");
			CGPoint point = [self pointForCoordinate:item];
			float width	 = viewToDraw.bounds.size.width;
			float height = viewToDraw.bounds.size.height;
          
			viewToDraw.frame = CGRectMake(point.x - width / 2.0, point.y - (height / 2.0), width, height);
			
			if ( !([viewToDraw superview]) ) {
				[_hudView addSubview:viewToDraw];
				[_hudView sendSubviewToBack:viewToDraw];
			}		
			totalDisplayed++;
            
		} else {
			[viewToDraw removeFromSuperview];
		}
	}
}

- (void)addCoordinate:(ARCoordinate *)coordinate animated:(BOOL)animated {
    //NSLog(@"Adding Coordinate");
    ARAnnotation *annotation = [[ARAnnotation alloc] initWithCoordinate:coordinate];
    coordinate.annotation = annotation;
    [annotation release];
    
	[_coordinates addObject:coordinate];
}

- (void)removeCoordinate:(ARCoordinate *)coordinate animated:(BOOL)animated {
	[_coordinates removeObject:coordinate];
}

- (BOOL)viewportContainsCoordinate:(ARCoordinate *)coordinate {
    
	double deltaAzimuth = [self deltaAzimuthForCoordinate:coordinate];
	BOOL result	= NO;
	if (deltaAzimuth <= degreesToRadians(_range)) {
		result = YES;
	}
	
	return result;
}

- (double)deltaAzimuthForCoordinate:(ARCoordinate *)coordinate {
	
	double currentAzimuth = _coordinate.azimuth;
	double pointAzimuth	  = coordinate.azimuth;
	
	double deltaAzimith = ABS( pointAzimuth - currentAzimuth);
	
	if (currentAzimuth < degreesToRadians(_range) && 
		pointAzimuth > degreesToRadians(360-_range)) {
		deltaAzimith	= (currentAzimuth + ((M_PI * 2.0) - pointAzimuth));
	} else if (pointAzimuth < degreesToRadians(_range) && 
			   currentAzimuth > degreesToRadians(360-_range)) {
		deltaAzimith	= (pointAzimuth + ((M_PI * 2.0) - currentAzimuth));
	}
	return deltaAzimith;
}

-(BOOL)isNorthForCoordinate:(ARCoordinate *)coordinate {
	
	BOOL isBetweenNorth = NO;
	double currentAzimuth = _coordinate.azimuth;
	double pointAzimuth	= coordinate.azimuth;	
    
	if ( currentAzimuth < degreesToRadians(_range) && 
        pointAzimuth > degreesToRadians(360-_range) ) {
		isBetweenNorth = YES;
	} else if ( pointAzimuth < degreesToRadians(_range) && 
               currentAzimuth > degreesToRadians(360-_range)) {
		isBetweenNorth = YES;
	}
	return isBetweenNorth;
}

- (CGPoint)pointForCoordinate:(ARCoordinate *)coordinate {
    
	CGPoint point;
	CGRect viewBounds = _hudView.bounds;
	
	double currentAzimuth = _coordinate.azimuth;
	double pointAzimuth	= coordinate.azimuth;
	double pointInclination	= coordinate.inclination;
    
	double deltaAzimuth = [self deltaAzimuthForCoordinate:coordinate];
	BOOL isBetweenNorth	= [self isNorthForCoordinate:coordinate];
	
	if ((pointAzimuth > currentAzimuth && !isBetweenNorth) || 
		(currentAzimuth > degreesToRadians(360-_range) && 
		 pointAzimuth < degreesToRadians(_range))) {
			
            // Right side of Azimuth			
            point.x = (viewBounds.size.width / 2) + ((deltaAzimuth / degreesToRadians(1)) * 12);  
        } else {
			
            // Left side of Azimuth
            point.x = (viewBounds.size.width / 2) - ((deltaAzimuth / degreesToRadians(1)) * 12);	
        }	
	point.y = (viewBounds.size.height / 2) 
    + (radiansToDegrees(M_PI_2 + _viewAngle)  * 2.0)
    + ((pointInclination / degreesToRadians(1)) * 12);
	
	return point;
}

@end
