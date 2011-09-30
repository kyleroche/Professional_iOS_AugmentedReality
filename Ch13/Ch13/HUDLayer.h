//
//  HUDLayer.h
//  Ch13
//
//  Created by Kyle Roche on 9/27/11.
//  Copyright 2011 Isidorey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface HUDLayer : CCLayer {
    
}

- (void)loadCrosshair:(NSString *)mood x:(double)x y:(double)y;

@end
