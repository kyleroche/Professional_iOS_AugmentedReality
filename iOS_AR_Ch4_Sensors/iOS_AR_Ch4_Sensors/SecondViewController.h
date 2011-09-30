//
//  SecondViewController.h
//  iOS_AR_Ch4_Sensors
//
//  Created by Kyle Roche on 7/5/11.
//  Copyright 2011 Isidorey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface SecondViewController : UIViewController {
    CMMotionManager *motionManager;
    
    UILabel *rollLabel;
    UILabel *pitchLabel;
    UILabel *yawLabel;
    
    UIProgressView *rollProgressView;
    UIProgressView *pitchProgressView;
    UIProgressView *yawProgressView;
    
    UIImageView *imageView;

    NSTimer *timer;
}

@property (nonatomic, retain) CMMotionManager *motionManager;

@property (nonatomic, retain) IBOutlet UILabel *rollLabel;
@property (nonatomic, retain) IBOutlet UILabel *pitchLabel;
@property (nonatomic, retain) IBOutlet UILabel *yawLabel;

@property (nonatomic, retain) IBOutlet UIProgressView *rollProgressView;
@property (nonatomic, retain) IBOutlet UIProgressView *pitchProgressView;
@property (nonatomic, retain) IBOutlet UIProgressView *yawProgressView;

@property (nonatomic, retain) IBOutlet UIImageView *imageView;

- (IBAction)readGyroscope;

@end
