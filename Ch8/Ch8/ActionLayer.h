//
//  ActionLayer.h
//  Ch8
//
//  Created by Kyle Roche on 10/23/11.
//  Copyright 2011 2lemetry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ActionLayer : CCLayer {
    CCSpriteBatchNode *pumpkinBatchNode;
    CCSprite *pumpkin;
    int pumpkin_count;
    
    CCParticleSystemQuad *emitter;
}

@property (nonatomic) BOOL isProcessingRequest;
@property (nonatomic, retain) CIDetector *detector;

+(CCScene *) scene;
- (void)facialRecognitionRequest:(UIImage *)image;

@end
