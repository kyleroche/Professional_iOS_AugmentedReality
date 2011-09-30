//
//  AppDelegate.h
//  Ch13
//
//  Created by Kyle Roche on 9/26/11.
//  Copyright Isidorey 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "FaceDetectionLayer.h"

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate, AVCaptureVideoDataOutputSampleBufferDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
    
    AVCaptureSession *_session;
    UIView *_cameraView;
    UIImageView *_imageView;
    
    BOOL _settingImage;
    
    FaceDetectionLayer *_layer;
    NSTimer *_timer;
}

@property (nonatomic, retain) UIWindow *window;

- (void)setupCaptureSession;

@end
