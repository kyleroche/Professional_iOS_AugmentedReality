//
//  MenuLayer.h
//  Ch8
//
//  Created by Kyle Roche on 10/23/11.
//  Copyright 2011 2lemetry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "chipmunk.h"
#import "cpMouse.h"
#import "CPSprite.h"

@interface MenuLayer : CCLayer {
    cpSpace *space;
    cpBody *ground;
    cpMouse *mouse;
    
    CCSpriteBatchNode *pumpkinBatchNode;
    CPSprite *menuPumpkin1;
}

+ (id)scene;

@end
