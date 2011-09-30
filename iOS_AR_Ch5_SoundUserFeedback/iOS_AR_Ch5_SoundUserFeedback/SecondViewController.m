//
//  SecondViewController.m
//  iOS_AR_Ch5_SoundUserFeedback
//
//  Created by Kyle Roche on 7/16/11.
//  Copyright 2011 Isidorey. All rights reserved.
//

#import "SecondViewController.h"


@implementation SecondViewController

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)setupRecorder {
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/recording.caf"];
    NSDictionary *recordSettings = [[NSDictionary alloc] initWithObjectsAndKeys: 
                                    [NSNumber numberWithFloat: 44100.0], AVSampleRateKey, 
                                    [NSNumber numberWithInt: kAudioFormatAppleLossless], AVFormatIDKey, 
                                    [NSNumber numberWithInt: 1], AVNumberOfChannelsKey, 
                                    [NSNumber numberWithInt: AVAudioQualityMax], AVEncoderAudioQualityKey,nil];
    
    _soundRecorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:filePath] 
                                                                 settings: recordSettings error: nil];
    _soundRecorder.delegate = self;
    [_soundRecorder record];
}

- (void)stopRecorder {
    [_soundRecorder stop];
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    NSLog(@"did finish recording");
}

- (void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder {
    NSLog(@"recording was interrupted");
}

- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder {
    NSLog(@"interruption ended... back to it");
}

- (void)playAudioRecording {
    NSString * filePath = [NSHomeDirectory() stringByAppendingPathComponent: @"Documents/recording.caf"];
    AVAudioPlayer *newPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: [NSURL fileURLWithPath:filePath] error: nil];
    newPlayer.delegate = self;
    [newPlayer play];
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
