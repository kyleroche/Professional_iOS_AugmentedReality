//
//  RootViewController.m
//  Ch11
//
//  Created by Kyle Roche on 10/4/11.
//  Copyright (c) 2011 Apress. All rights reserved.
//

#import "RootViewController.h"
#import "ARController.h"
#import "ARGeoCoordinate.h"
#import "FBConnect.h"

@implementation RootViewController
@synthesize arController = _arController;
@synthesize facebook = _facebook;

static NSString* kAppId = @"";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    _arController = [[ARController alloc] initWithViewController:self];
    
    ARGeoCoordinate *tempCoordinate;
	CLLocation		*tempLocation;
    
	tempLocation = [[CLLocation alloc] initWithLatitude:39.550051 longitude:-105.782067];
    tempCoordinate = [[ARGeoCoordinate alloc] initWithCoordinate:tempLocation name:@"Kyle Roche" place:@"Denver"];
	//[self.arController addCoordinate:tempCoordinate animated:NO];
    NSLog(@"Added Coordinate: %@", tempCoordinate);
	[tempLocation release];
    
    _permissions =  [[NSArray arrayWithObjects:@"read_stream", @"publish_stream", @"offline_access", @"friends_checkins", nil] retain];
    _facebook = [[Facebook alloc] initWithAppId:kAppId andDelegate:self];
    [_facebook authorize:_permissions];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self.arController presentModalARControllerAnimated:NO];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)fbDidLogin {
    NSLog(@"LOGGED IN");
    _friendsRequest = [_facebook requestWithGraphPath:@"me/friends" andDelegate:self];
}

-(void)fbDidNotLogin:(BOOL)cancelled {
    NSLog(@"did not login");
}

/**
 * Called when the request logout has succeeded.
 */
- (void)fbDidLogout {
    NSLog(@"LOGOUT");
}
/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}


////////////////////////////////////////////////////////////////////////////////
// FBRequestDelegate

/**
 * Called when the Facebook API request has returned a response. This callback
 * gives you access to the raw response. It's called before
 * (void)request:(FBRequest *)request didLoad:(id)result,
 * which is passed the parsed response object.
 */
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"received response");
}

/**
 * Called when a request returns and its response has been parsed into
 * an object. The resulting object may be a dictionary, an array, a string,
 * or a number, depending on the format of the API response. If you need access
 * to the raw response, use:
 *
 * (void)request:(FBRequest *)request
 *      didReceiveResponse:(NSURLResponse *)response
 */
- (void)request:(FBRequest *)request didLoad:(id)result {
    if (request == _friendsRequest) {
        //NSLog(@"RESULT: %@", result);
        
        for (int i = 21; i < 22; i++) {
            [_facebook requestWithGraphPath:[NSString stringWithFormat:@"%@/checkins", [[[result objectForKey:@"data"] objectAtIndex:i] objectForKey:@"id"]] andDelegate:self];
        }
    } else {
        if ([[result objectForKey:@"data"] count] > 0) {
            NSLog(@"RESULT: %@", [[result objectForKey:@"data"] objectAtIndex:0]);
            NSLog(@"PLACE: %@", [[[result objectForKey:@"data"] objectAtIndex:0] objectForKey:@"place"]);
            
            NSString *placeName = [[[[result objectForKey:@"data"] objectAtIndex:0] objectForKey:@"place"] objectForKey:@"name"];
            NSString *placeLat = [[[[[result objectForKey:@"data"] objectAtIndex:0] objectForKey:@"place"] objectForKey:@"location"] objectForKey:@"latitude"];
            NSString *placeLong = [[[[[result objectForKey:@"data"] objectAtIndex:0] objectForKey:@"place"] objectForKey:@"location"] objectForKey:@"longitude"];
            NSString *checkinMessage = [[[result objectForKey:@"data"] objectAtIndex:0] objectForKey:@"message"];
            
            NSLog(@"plave %@", placeName);
            
            ARGeoCoordinate *tempCoordinate;
            CLLocation		*tempLocation;
            
            tempLocation = [[CLLocation alloc] initWithLatitude:[placeLat floatValue] longitude:[placeLong floatValue]];
            tempCoordinate = [[ARGeoCoordinate alloc] initWithCoordinate:tempLocation name:checkinMessage place:placeName];
            [self.arController addCoordinate:tempCoordinate animated:NO];
            NSLog(@"Added Coordinate: %@", tempCoordinate);
            [tempLocation release];
        }
    }
};

/**
 * Called when an error prevents the Facebook API request from completing
 * successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"ERROR: %@", [error localizedDescription]);
    NSLog(@"USER: %@", [error userInfo]);
    NSLog(@"Err details: %@", [error description]);
};

- (void)dialogDidComplete:(FBDialog *)dialog {
    NSLog(@"publish successful");
}


@end
