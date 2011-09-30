//
//  SecondViewController.m
//  iOS_AR_Ch3_LocationServices
//
//  Created by Kyle Roche on 6/13/11.
//  Copyright 2011 Isidorey. All rights reserved.
//

#import "SecondViewController.h"


@implementation SecondViewController
@synthesize mapView;
@synthesize buttonBarSegmentedControl;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    mapView.delegate=self;  
    
    [self.view addSubview:mapView];  
    
    [NSThread detachNewThreadSelector:@selector(displayMap) toTarget:self withObject:nil]; 
    [self setupSegmentedControl];
    [super viewDidLoad];
}

- (void)displayMap {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    CLLocationCoordinate2D coords; 
    coords.latitude = 37.33188; 
    coords.longitude = -122.029497; 
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.002389, 0.005681);
    MKCoordinateRegion region = MKCoordinateRegionMake(coords, span); 
    
    
    MapAnnotation *addAnnotation = [[[MapAnnotation alloc] initWithCoordinate:coords] retain];  
    [addAnnotation setTitle:@"My Annotation Title"];  
    [addAnnotation setSubTitle:@"this is my subtitle property"];
    [mapView addAnnotation:addAnnotation]; 
    
    [mapView setRegion:region animated:YES];
    
    [pool drain];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark {
    NSLog(@"return %@", placemark.addressDictionary);
}
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error {
    NSLog(@"fail %@", error);
}
- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation{  
    MKPinAnnotationView *annView=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MyPin"];  
    annView.animatesDrop=TRUE;  
    annView.canShowCallout = YES;  
    [annView setSelected:YES];  
    annView.pinColor = MKPinAnnotationColorPurple;  
    annView.calloutOffset = CGPointMake(-50, 5);  
    return annView;  
} 

- (void)setupSegmentedControl {
    buttonBarSegmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Standard", @"Satellite", @"Hybrid", nil]];
    [buttonBarSegmentedControl setFrame:CGRectMake(30, 50, 280-30, 30)];
    buttonBarSegmentedControl.selectedSegmentIndex = 0.0;	// start by showing the normal picker
	[buttonBarSegmentedControl addTarget:self action:@selector(toggleToolBarChange:) forControlEvents:UIControlEventValueChanged];
	buttonBarSegmentedControl.segmentedControlStyle = UIScrollViewIndicatorStyleWhite;
	buttonBarSegmentedControl.backgroundColor = [UIColor clearColor];
    buttonBarSegmentedControl.tintColor = [UIColor blackColor];
	[buttonBarSegmentedControl setAlpha:0.8];
    
	[self.view addSubview:buttonBarSegmentedControl];
}

- (void)toggleToolBarChange:(id)sender
{
	UISegmentedControl *segControl = sender;
    
	switch (segControl.selectedSegmentIndex)
	{
		case 0:	// Map
		{
  			[mapView setMapType:MKMapTypeStandard];
			break;
		}
		case 1: // Satellite
		{
            CLLocationCoordinate2D coords; 
            coords.latitude = 37.33188; 
            coords.longitude = -122.029497; 
            
            MKReverseGeocoder *geoCoder = [[MKReverseGeocoder alloc] initWithCoordinate:coords]; 
            [geoCoder setDelegate:self]; 
            [geoCoder start];

			[mapView setMapType:MKMapTypeSatellite];
			break;
		}
		case 2: // Hybrid
		{
			[mapView setMapType:MKMapTypeHybrid];
			break;
		}
	}
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
    [mapView release];
    mapView = nil;
    [buttonBarSegmentedControl release];
    buttonBarSegmentedControl = nil;
    [super dealloc];
}

@end
