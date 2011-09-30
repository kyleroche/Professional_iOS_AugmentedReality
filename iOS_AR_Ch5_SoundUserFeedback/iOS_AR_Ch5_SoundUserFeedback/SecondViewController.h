//
//  SecondViewController.h
//  iOS_AR_Ch5_SoundUserFeedback
//
//  Created by Kyle Roche on 7/16/11.
//  Copyright 2011 Isidorey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@interface SecondViewController : UIViewController <AVAudioRecorderDelegate, AVAudioPlayerDelegate>{
    AVAudioRecorder *_soundRecorder;
}

- (IBAction)setupRecorder;
- (IBAction)stopRecorder;
- (IBAction)playAudioRecording;

@end
