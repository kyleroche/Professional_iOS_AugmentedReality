//
//  ARAnnotation.h
//  Ch11
//
//  Created by Kyle Roche on 10/5/11.
//  Copyright (c) 2011 Apress. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ARCoordinate;
@interface ARAnnotation : UIView {
    
}

- (id)initWithCoordinate:(ARCoordinate *)coordinate;

@end
