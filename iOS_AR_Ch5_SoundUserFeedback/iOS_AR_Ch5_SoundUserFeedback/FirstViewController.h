//
//  FirstViewController.h
//  iOS_AR_Ch5_SoundUserFeedback
//
//  Created by Kyle Roche on 7/16/11.
//  Copyright 2011 Isidorey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface FirstViewController : UIViewController <AVAudioPlayerDelegate> {
    SystemSoundID _systemSound;
    AVAudioPlayer *_audioPlayer;
}

- (IBAction)systemSoundAction;
- (IBAction)avAudioPlayerAction;
- (IBAction)vibrate;

@end
