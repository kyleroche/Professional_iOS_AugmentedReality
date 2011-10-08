//
//  ARAnnotation.m
//  Ch11
//
//  Created by Kyle Roche on 10/5/11.
//  Copyright (c) 2011 Apress. All rights reserved.
//

#import "ARAnnotation.h"
#import "ARCoordinate.h"
#import "AppDelegate.h"
#import "RootViewController.h"
#import "FBConnect.h"

#define ANNOTATION_WIDTH 150
#define ANNOTATION_HEIGHT 200

@implementation ARAnnotation
static NSString* kAppId = @"";

- (id)initWithCoordinate:(ARCoordinate *)coordinate
{
    CGRect annotationFrame = CGRectMake(0, 0, ANNOTATION_WIDTH, ANNOTATION_HEIGHT);
    
    if (self = [super initWithFrame:annotationFrame]) {
        UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [shareButton setFrame:CGRectMake(0, 0, 32, 32)];
        [shareButton setBackgroundImage:[UIImage imageNamed:@"Facebook-Places.png"] forState:UIControlStateNormal];
        [shareButton addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:shareButton];

        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, ANNOTATION_WIDTH, 20.0)];
        
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textAlignment = UITextAlignmentCenter;
        nameLabel.text = coordinate.name;
        [nameLabel sizeToFit];
        [nameLabel setFrame:CGRectMake(40, 0, nameLabel.bounds.size.width + 8.0, nameLabel.bounds.size.height + 8.0)];
        [self addSubview:nameLabel];
        
        UILabel *placeLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, ANNOTATION_WIDTH, 20.0)];
        placeLabel.backgroundColor = [UIColor clearColor];
        placeLabel.textAlignment = UITextAlignmentCenter;
        placeLabel.text = coordinate.place;
        [placeLabel sizeToFit];
        [placeLabel setFrame:CGRectMake(40, 25, placeLabel.bounds.size.width + 8.0, placeLabel.bounds.size.height + 8.0)];
        [self addSubview:placeLabel];
        
		[self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (IBAction)shareButtonClicked:(id)sender {
    AppDelegate *_appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    RootViewController *_rootViewController = _appDelegate.rootViewController;
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   kAppId, @"app_id",
                                   @"http://amzn.com/1430239123", @"link",
                                   @"http://bit.ly/qILSZh", @"picture",
                                   @"Facebook Places AR App", @"name",
                                   @"Sharing information on a Facebook Place", @"caption",
                                   @"Look, All my Facebook places are in Augmented Reality view.", @"description",
                                   @"Buy the book",  @"message",
                                   nil];
    
    [_rootViewController.facebook dialog:@"feed"
            andParams:params
          andDelegate:_rootViewController];
}
@end
