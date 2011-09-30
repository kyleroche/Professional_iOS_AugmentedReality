//
//  FirstViewController.m
//  iOS_AR_Ch5_SoundUserFeedback
//
//  Created by Kyle Roche on 7/16/11.
//  Copyright 2011 Isidorey. All rights reserved.
//

#import "FirstViewController.h"


@implementation FirstViewController

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)systemSoundAction {
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"waterfall" ofType:@"caf"];
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    AudioServicesCreateSystemSoundID((CFURLRef)soundFileURL, &_systemSound);
    AudioServicesPlaySystemSound(_systemSound);
}

- (void)avAudioPlayerAction {
    NSError *setCategoryError = nil;
	[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:&setCategoryError];
	
	NSString *backgroundMusicPath = [[NSBundle mainBundle] pathForResource:@"backgroundMusic" ofType:@"caf"];
	NSURL *backgroundMusicURL = [NSURL fileURLWithPath:backgroundMusicPath];
	NSError *error;
    
	_audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
	[_audioPlayer play];
}

- (void)vibrate {
    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
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
