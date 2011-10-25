//
//  AppDelegate.h
//  Ch8
//
//  Created by Kyle Roche on 10/23/11.
//  Copyright 2lemetry 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ActionLayer.h"

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate, AVCaptureVideoDataOutputSampleBufferDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
    
    AVCaptureSession *_session;
    UIView *_cameraView;
    UIImageView *_imageView;
    BOOL _settingImage;
}

+ (AppDelegate *)instance;

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic) BOOL isPlaying;
@property (nonatomic, retain) ActionLayer *actionLayer;

@end
