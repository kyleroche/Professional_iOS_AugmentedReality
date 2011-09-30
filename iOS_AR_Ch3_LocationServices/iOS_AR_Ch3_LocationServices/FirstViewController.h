//
//  FirstViewController.h
//  iOS_AR_Ch3_LocationServices
//
//  Created by Kyle Roche on 6/13/11.
//  Copyright 2011 Isidorey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface FirstViewController : UIViewController <CLLocationManagerDelegate> {
    UITextView *locationTextView;
}

@property (nonatomic, retain) IBOutlet UITextView *locationTextView;
- (void)startStandardUpdates;
- (void)startSignificantChangeUpdates;
- (void)startRegionMonitoring;

@end
