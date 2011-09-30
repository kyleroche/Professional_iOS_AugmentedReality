//
//  HUDLayer.h
//  Ch7
//
//  Created by Kyle Roche on 9/5/11.
//  Copyright (c) 2011 Isidorey. All rights reserved.
//

#import "cocos2d.h"

@interface HUDLayer : CCLayer {
    CCLabelTTF *_counterLabel;
}

- (void)incrementCounter;

@end
