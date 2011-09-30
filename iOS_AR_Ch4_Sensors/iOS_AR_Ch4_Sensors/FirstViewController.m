//
//  FirstViewController.m
//  iOS_AR_Ch4_Sensors
//
//  Created by Kyle Roche on 7/5/11.
//  Copyright 2011 Isidorey. All rights reserved.
//

#import "FirstViewController.h"


@implementation FirstViewController
@synthesize xLabel, yLabel, zLabel, xProgressView, yProgressView, zProgressView, accelerometer;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    accelerometer = [UIAccelerometer sharedAccelerometer];
	accelerometer.updateInterval = .25;
	accelerometer.delegate = self;

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

-(void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
	xLabel.text = [NSString stringWithFormat:@"%@%f", @"X: ", acceleration.x];
	yLabel.text = [NSString stringWithFormat:@"%@%f", @"Y: ", acceleration.y];
	zLabel.text = [NSString stringWithFormat:@"%@%f", @"Z: ", acceleration.z];
	
	xProgressView.progress = ABS(acceleration.x);
	yProgressView.progress = ABS(acceleration.y);
	zProgressView.progress = ABS(acceleration.z);
    
    double const kThreshold = 2.0;
    if (   ABS(acceleration.x) > kThreshold
        || ABS(acceleration.y) > kThreshold
        || ABS(acceleration.z) > kThreshold) {
        NSLog(@"Shake Detected!");
    }
}

- (void)viewDidUnload
{
    //accelerometer.delegate = nil;
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc
{
    [xLabel release];
    xLabel = nil;
    [yLabel release];
    yLabel = nil;
    [zLabel release];
    zLabel = nil;
    [xProgressView release];
    xProgressView = nil;
    [yProgressView release];
    yProgressView = nil;
    [zProgressView release];
    zProgressView = nil;
    [accelerometer release];
    accelerometer = nil;
    [super dealloc];
}

@end
