//
//  FirstViewController.h
//  iOS_AR_Ch2_HardwareComparison
//
//  Created by Kyle Roche on 6/13/11.
//  Copyright 2011 Isidorey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <CoreMotion/CoreMotion.h>

@interface FirstViewController : UIViewController {

}
- (BOOL) isVideoCameraAvailable;
- (BOOL) isGyroscopeAvailable;

@end
