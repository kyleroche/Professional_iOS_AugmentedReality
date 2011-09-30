//
//  MapAnnotation.m
//  iOS_AR_Ch3_LocationServices
//
//  Created by Kyle Roche on 6/29/11.
//  Copyright 2011 Isidorey. All rights reserved.
//

#import "MapAnnotation.h"


@implementation MapAnnotation
@synthesize coordinate, titletext, subtitletext;

- (NSString *)subtitle{
	return subtitletext;
}
- (NSString *)title{
	return titletext;
}

-(void)setTitle:(NSString*)strTitle {
	self.titletext = strTitle;
}

-(void)setSubTitle:(NSString*)strSubTitle {
	self.subtitletext = strSubTitle;
}

-(id)initWithCoordinate:(CLLocationCoordinate2D) c{
	coordinate=c;
	return self;
}
@end

