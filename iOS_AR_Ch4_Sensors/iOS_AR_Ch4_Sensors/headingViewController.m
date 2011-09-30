//
//  headingViewController.m
//  iOS_AR_Ch4_Sensors
//
//  Created by Kyle Roche on 9/15/11.
//  Copyright (c) 2011 Isidorey. All rights reserved.
//

#import "headingViewController.h"

@implementation headingViewController
@synthesize compassImage;
@synthesize trueHeadingLabel;
@synthesize magneticHeadingLabel;
@synthesize orientationLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.headingFilter = 5;
    if ([CLLocationManager locationServicesEnabled] && [CLLocationManager headingAvailable]) {
        [locationManager startUpdatingHeading];
        [locationManager startUpdatingLocation];
    } else {
        NSLog(@"Error starting location updates");
    }
}

- (float)heading:(float)heading fromOrientation:(UIDeviceOrientation)orientation {
    float correctedHeading = heading;
    
    switch (orientation) {
        case UIDeviceOrientationPortrait: 
            break;
        case UIDeviceOrientationPortraitUpsideDown: 
            correctedHeading = heading + 180.0f; 
            break;
        case UIDeviceOrientationLandscapeLeft: 
            correctedHeading = heading + 90.0f; 
            break;
        case UIDeviceOrientationLandscapeRight: 
            correctedHeading = heading - 90.0f; 
            break;
        default: 
            break;
    }
    while ( heading > 360.0f ) {
        correctedHeading = heading - 360; 
    }
    return correctedHeading;
}

- (NSString *)stringFromOrientation:(UIDeviceOrientation) orientation {
    NSString *orientationString; 
    switch (orientation) {
        case UIDeviceOrientationPortrait: 
            orientationString = @"Portrait"; 
            break;
        case UIDeviceOrientationPortraitUpsideDown: 
            orientationString = @"Portrait Upside Down"; 
            break;
        case UIDeviceOrientationLandscapeLeft: 
            orientationString = @"Landscape Left"; 
            break;
        case UIDeviceOrientationLandscapeRight: 
            orientationString = @"Landscape Right"; 
            break;
        case UIDeviceOrientationFaceUp: 
            orientationString = @"Face Up"; 
            break;
        case UIDeviceOrientationFaceDown: 
            orientationString = @"Face Down"; 
            break;
        case UIDeviceOrientationUnknown: 
            orientationString = @"Unknown"; 
            break;
        default:
            orientationString = @"Not Known"; 
            break;
    }
    return orientationString; 
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    if (newHeading.headingAccuracy > 0) {
        //float magneticHeading = newHeading.magneticHeading;
        //float trueHeading = newHeading.trueHeading;
        UIDevice *device = [UIDevice currentDevice];
        orientationLabel.text = [self stringFromOrientation:device.orientation];
        
        float magneticHeading = [self heading:newHeading.magneticHeading fromOrientation:device.orientation];
        float trueHeading = [self heading:newHeading.trueHeading fromOrientation:device.orientation];
        
        magneticHeadingLabel.text = [NSString stringWithFormat:@"%f", magneticHeading];
        trueHeadingLabel.text = [NSString stringWithFormat:@"%f", trueHeading];
        
        float heading = -1.0f * M_PI * newHeading.magneticHeading / 180.0f;
        compassImage.transform = CGAffineTransformMakeRotation(heading);
    }
}

- (void)viewDidUnload
{
    [self setCompassImage:nil];
    [self setTrueHeadingLabel:nil];
    [self setMagneticHeadingLabel:nil];
    [self setOrientationLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [compassImage release];
    [trueHeadingLabel release];
    [magneticHeadingLabel release];
    [orientationLabel release];
    [super dealloc];
}
@end
