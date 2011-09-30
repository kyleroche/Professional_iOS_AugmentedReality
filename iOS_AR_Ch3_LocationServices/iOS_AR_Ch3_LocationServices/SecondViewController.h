//
//  SecondViewController.h
//  iOS_AR_Ch3_LocationServices
//
//  Created by Kyle Roche on 6/13/11.
//  Copyright 2011 Isidorey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MapAnnotation.h"

@interface SecondViewController : UIViewController <MKMapViewDelegate, MKReverseGeocoderDelegate>{
    IBOutlet MKMapView *mapView;
    UISegmentedControl *buttonBarSegmentedControl;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UISegmentedControl *buttonBarSegmentedControl;

- (void)setupSegmentedControl;

@end
