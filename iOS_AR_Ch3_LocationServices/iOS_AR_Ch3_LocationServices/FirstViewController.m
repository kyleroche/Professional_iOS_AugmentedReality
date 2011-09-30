//
//  FirstViewController.m
//  iOS_AR_Ch3_LocationServices
//
//  Created by Kyle Roche on 6/13/11.
//  Copyright 2011 Isidorey. All rights reserved.
//

#import "FirstViewController.h"


@implementation FirstViewController
@synthesize locationTextView;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [self startStandardUpdates];
    //[self startSignificantChangeUpdates];
    
    if ([CLLocationManager regionMonitoringAvailable]) {
        [self startRegionMonitoring];
    }
    [super viewDidLoad];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

// use standard update location service
- (void)startStandardUpdates
{
    CLLocationManager *locationManager = [[CLLocationManager alloc] init]; 
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = 500;
    
    [locationManager startUpdatingLocation];
}

- (void)startRegionMonitoring
{
    NSLog(@"Starting region monitoring");
    CLLocationManager *locationManager = [[CLLocationManager alloc] init]; 
    locationManager.delegate = self;
    
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(37.787359, -122.408227);
    CLRegion *region = [[CLRegion alloc] initCircularRegionWithCenter:coord radius:1000.0 identifier:@"San Francisco"];
    
    [locationManager startMonitoringForRegion:region desiredAccuracy:kCLLocationAccuracyKilometer];
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Region Alert" 
                                                    message:@"You entered the region" 
                                                   delegate:self 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Region Alert" 
                                                    message:@"You exited the region" 
                                                   delegate:self 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}


// use significant-change location service
- (void)startSignificantChangeUpdates
{
    CLLocationManager *locationManager = [[CLLocationManager alloc] init]; 
    locationManager.delegate = self;
    [locationManager startMonitoringSignificantLocationChanges];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    /*
    NSDate* eventDate = newLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0)
    {
        //locationTextView.text = [NSString stringWithFormat:@"latitude %+.6f, longitude %+.6f\n",
        //                       newLocation.coordinate.latitude,
        //                       newLocation.coordinate.longitude];
        
        CLLocationDistance dist = [newLocation distanceFromLocation:oldLocation] / 1000;
        locationTextView.text = [NSString stringWithFormat:@"distance %5.1f traveled"];
        
    } else {
        locationTextView.text = @"Update was old";
        // you'd probably just do nothing here and ignore the event
    }
    */
    
    
    locationTextView.text = [NSString stringWithFormat:@"%6.2f m. ", newLocation.altitude];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc
{
    [locationTextView release];
    locationTextView = nil;
    [super dealloc];
}

@end
