//
//  MapAnnotation.h
//  iOS_AR_Ch3_LocationServices
//
//  Created by Kyle Roche on 6/29/11.
//  Copyright 2011 Isidorey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapAnnotation : NSObject<MKAnnotation> {
    CLLocationCoordinate2D coordinate;  
    NSString *subtitletext;  
    NSString *titletext;  
}  
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;  
@property (readwrite, retain) NSString *titletext;  
@property (readwrite, retain) NSString *subtitletext;  
-(id)initWithCoordinate:(CLLocationCoordinate2D) coordinate;  
- (NSString *)subtitle;  
- (NSString *)title;  
-(void)setTitle:(NSString*)strTitle;  
-(void)setSubTitle:(NSString*)strSubTitle;  

@end  
