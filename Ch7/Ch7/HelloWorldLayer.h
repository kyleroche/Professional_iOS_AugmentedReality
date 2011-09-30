//
//  HelloWorldLayer.h
//  Ch7
//
//  Created by Kyle Roche on 9/5/11.
//  Copyright Isidorey 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "CCTouchDispatcher.h"
#import "HUDLayer.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer {
    HUDLayer *_hud;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
- (id)initWithHUD:(HUDLayer *)hud;
@end
