//
//  ActionLayer.m
//  Ch8
//
//  Created by Kyle Roche on 10/23/11.
//  Copyright 2011 2lemetry. All rights reserved.
//

#import "ActionLayer.h"
#import "AppDelegate.h"
#import "EndLayer.h"

@implementation ActionLayer
@synthesize detector, isProcessingRequest;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	ActionLayer *layer = [ActionLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (id)init {
    if (self = [super init]) {
        //CGSize winSize = [CCDirector sharedDirector].winSize;
        
        NSDictionary *detectorOptions = [NSDictionary dictionaryWithObjectsAndKeys:CIDetectorAccuracyLow, CIDetectorAccuracy, nil];
        self.detector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:detectorOptions];
        
        //[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"pumpkins.plist"];
        pumpkinBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"pumpkins.png"];
        [self addChild:pumpkinBatchNode];
        
        pumpkin = [CCSprite spriteWithSpriteFrameName:@"pumpkin5.png"];
        pumpkin.position = ccp(0,0);
        pumpkin.opacity = 0;
        [self addChild:pumpkin];
        
        // Start the game
        isProcessingRequest = NO;
        pumpkin_count = 12;
        [AppDelegate instance].actionLayer = self;
        [AppDelegate instance].isPlaying = YES;
        
        self.isTouchEnabled = YES;
    }
    return self;
}

- (void)facialRecognitionRequest:(UIImage *)image {
    //NSLog(@"Image is: %f by %f", image.size.width, image.size.height);
    
    if (!isProcessingRequest) {
        isProcessingRequest = YES;
        //NSLog(@"Detecting Faces");
        NSArray *arr = [detector featuresInImage:[CIImage imageWithCGImage:[image CGImage]]];
        
        if ([arr count] > 0) {
            //NSLog(@"Faces found.");
            for (int i = 0; i < 1; i++) { //< [arr count]; i++) {
                CIFaceFeature *feature = [arr objectAtIndex:i];
                double xPosition = (feature.leftEyePosition.x + feature.rightEyePosition.x+feature.mouthPosition.x)/(3*image.size.width) ;
                double yPosition = (feature.leftEyePosition.y + feature.rightEyePosition.y+feature.mouthPosition.y)/(3*image.size.height);
                
                double dist = sqrt(pow((feature.leftEyePosition.x - feature.rightEyePosition.x),2)+pow((feature.leftEyePosition.y - feature.rightEyePosition.y),2))/image.size.width;
                
                yPosition += dist;
                CGSize size = [[CCDirector sharedDirector] winSize];
                pumpkin.opacity = 255;
                pumpkin.scale = 5*(size.width*dist)/256.0;
                
                //int randomPumpkin = ((arc4random() % 10) + 5);
                [pumpkin setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"pumpkin%d.png", pumpkin_count + 4]]];
                CCMoveTo *moveAction = [CCMoveTo actionWithDuration:0 position:ccp((size.width * (xPosition)), (size.height * ((yPosition))))];
                [pumpkin runAction:moveAction];
            }
        } else {
            pumpkin.opacity = 0;
        }    
    }
    isProcessingRequest = NO;
}

- (void)registerWithTouchDispatcher {
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event { 
    return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = [self convertTouchToNodeSpace:touch];
    if (CGRectContainsPoint(pumpkin.boundingBox, location)) {
        pumpkin_count--;
        
        emitter = [CCParticleSystemQuad particleWithFile:@"PumpkinExplosion.plist"];
		emitter.position = ccp(location.x, location.y);
        [self addChild:emitter z:1];
        
        if (pumpkin_count == 0) {
            NSLog(@"You won");
            isProcessingRequest = YES;
            [AppDelegate instance].isPlaying = NO;
            [[CCDirector sharedDirector] replaceScene:[EndLayer scene]];
        }
    }
    //NSLog(@"Touch %@: ", NSStringFromCGPoint(location));
}


- (void)dealloc {
    [super dealloc];
    [detector release];
    detector = nil;
}

@end
