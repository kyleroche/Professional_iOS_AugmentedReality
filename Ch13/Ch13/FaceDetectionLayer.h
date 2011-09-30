//
//  FaceDetectionLayer.h
//  Ch13
//
//  Created by Kyle Roche on 9/27/11.
//  Copyright 2011 Isidorey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "HUDLayer.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"

@interface FaceDetectionLayer : CCLayer {
    //HUDLayer *_hud;
    BOOL _sendingRequest;
    
    //CCLabelTTF * label;
    CCSprite *crosshair;
}

@property (retain) UIViewController * root;
@property (retain) CCLabelTTF * label;

//+ (CCScene *)scene; 
//- (id)initWithHUD:(HUDLayer *)hud;
- (void)facialRecognitionRequest:(UIImage *)image;
@end
