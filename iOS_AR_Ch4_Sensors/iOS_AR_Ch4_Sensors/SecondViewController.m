//
//  SecondViewController.m
//  iOS_AR_Ch4_Sensors
//
//  Created by Kyle Roche on 7/5/11.
//  Copyright 2011 Isidorey. All rights reserved.
//

#import "SecondViewController.h"


@implementation SecondViewController
@synthesize motionManager;
@synthesize rollLabel, rollProgressView, pitchLabel, pitchProgressView, yawLabel, yawProgressView;
@synthesize imageView;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    self.motionManager = [[[CMMotionManager alloc] init] autorelease];
    motionManager.deviceMotionUpdateInterval = 1.0/60.0;
    
    if (motionManager.isDeviceMotionAvailable) {
        [motionManager startDeviceMotionUpdates];
        [motionManager startGyroUpdates];
        timer = [NSTimer scheduledTimerWithTimeInterval:1/30.0
                                                 target:self 
                                               selector:@selector(doGyroUpdate)
                                               userInfo:nil 
                                                repeats:YES];
	} 
    [super viewDidLoad];
}

-(void)doGyroUpdate {
	float rotation;
    float rate = motionManager.gyroData.rotationRate.z;
	if (fabs(rate) > .2) {
		float direction = rate > 0 ? 1 : -1;
		rotation += direction * M_PI/90.0;
		imageView.transform = CGAffineTransformMakeRotation(rotation);
        NSLog(@"Rotation: %f", rotation);
	}
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

- (void)readGyroscope {
    CMDeviceMotion *currentDeviceMotion = motionManager.deviceMotion;
    CMAttitude *currentAttitude = currentDeviceMotion.attitude;
    
    NSLog(@"Attitude: %@", currentAttitude);
    rollLabel.text = [NSString stringWithFormat:@"ROLL: %f", currentAttitude.roll];
    rollProgressView.progress = ABS(currentAttitude.roll);
    pitchLabel.text = [NSString stringWithFormat:@"PITCH: %f", currentAttitude.pitch];
    pitchProgressView.progress = ABS(currentAttitude.pitch);
    yawLabel.text = [NSString stringWithFormat:@"YAW: %f", currentAttitude.yaw];
    yawProgressView.progress = ABS(currentAttitude.yaw);  

    

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc
{
    [motionManager release];
    motionManager = nil;
    [rollLabel release];
    rollLabel = nil;
    [rollProgressView release];
    rollProgressView = nil;
    [pitchLabel release];
    pitchLabel = nil;
    [pitchProgressView release];
    pitchProgressView = nil;
    [yawLabel release];
    yawLabel = nil;
    [yawProgressView release];
    yawProgressView = nil;
    [imageView release];
    imageView = nil;
    [super dealloc];
}

@end
