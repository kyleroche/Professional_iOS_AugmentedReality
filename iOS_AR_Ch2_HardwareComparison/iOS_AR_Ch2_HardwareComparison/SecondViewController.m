//
//  SecondViewController.m
//  iOS_AR_Ch2_HardwareComparison
//
//  Created by Kyle Roche on 6/13/11.
//  Copyright 2011 Isidorey. All rights reserved.
//

#import "SecondViewController.h"


@implementation SecondViewController


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    BOOL audioAvailable = audioSession.inputIsAvailable;
    
    if (audioAvailable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Audio" 
                                                        message:@"Audio Available" 
                                                       delegate:self 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Audio" 
                                                        message:@"Audio NOT Available" 
                                                       delegate:self 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
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


- (void)viewDidUnload
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc
{
    [super dealloc];
}

@end
