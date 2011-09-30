//
//  headingViewController.h
//  iOS_AR_Ch4_Sensors
//
//  Created by Kyle Roche on 9/15/11.
//  Copyright (c) 2011 Isidorey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface headingViewController : UIViewController <CLLocationManagerDelegate> {

}
@property (retain, nonatomic) IBOutlet UIImageView *compassImage;
@property (retain, nonatomic) IBOutlet UILabel *trueHeadingLabel;
@property (retain, nonatomic) IBOutlet UILabel *magneticHeadingLabel;
@property (retain, nonatomic) IBOutlet UILabel *orientationLabel;

- (float)heading:(float)heading fromOrientation:(UIDeviceOrientation) orientation; 
- (NSString *)stringFromOrientation:(UIDeviceOrientation) orientation;

@end
