//
//  MenuLayer.m
//  Ch8
//
//  Created by Kyle Roche on 10/23/11.
//  Copyright 2011 2lemetry. All rights reserved.
//

#import "MenuLayer.h"
#import "drawSpace.h"
#import "ActionLayer.h"

@implementation MenuLayer

+ (id)scene {
    CCScene *scene = [CCScene node];
    MenuLayer *layer = [MenuLayer node];
    [scene addChild:layer];
    return scene;
}

- (void)createGround {    
    // 1
    CGSize winSize = [CCDirector sharedDirector].winSize; 
    CGPoint lowerLeft = ccp(0, 0);
    CGPoint lowerRight = ccp(winSize.width, 0);
    
    // 2
    ground = cpBodyNewStatic();
    
    // 3
    float radius = 10.0;
    cpShape *groundShape = cpSegmentShapeNew(ground, lowerLeft, lowerRight, radius);
    
    // 4
    groundShape->e = 0.5; // elasticity
    groundShape->u = 1.0; // friction 
    
    // 5
    cpSpaceAddShape(space, groundShape);    
}

- (void)createSpace {
    space = cpSpaceNew();
    space->gravity = ccp(0, -750);
    cpSpaceResizeStaticHash(space, 400, 200);
    cpSpaceResizeActiveHash(space, 200, 200);
}

- (void)createBoxAtLocation:(CGPoint)location {
    
    float boxSize = 60.0;
    float mass = 1.0;
    cpBody *body = cpBodyNew(mass, cpMomentForBox(mass, boxSize, boxSize));
    body->p = location;
    cpSpaceAddBody(space, body);
    
    cpShape *shape = cpBoxShapeNew(body, boxSize, boxSize);
    shape->e = 1.0; 
    shape->u = 1.0;
    cpSpaceAddShape(space, shape);
    
}

- (void)update:(ccTime)dt {
    cpSpaceStep(space, dt);
    for (CPSprite *sprite in pumpkinBatchNode.children) {
        [sprite update];
    }
}

- (void)draw {
    
    drawSpaceOptions options = {
        0, // drawHash
        0, // drawBBs,
        1, // drawShapes
        4.0, // collisionPointSize
        4.0, // bodyPointSize,
        2.0 // lineThickness
    };
    
    drawSpace(space, &options);
    
}

- (void)registerWithTouchDispatcher {
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    cpMouseGrab(mouse, touchLocation, false);
    return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    cpMouseMove(mouse, touchLocation);
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    cpMouseRelease(mouse);
}

- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
    cpMouseRelease(mouse);    
}

- (void)dealloc {
    cpMouseFree(mouse);
    cpSpaceFree(space);
    [super dealloc];
}

- (void)newGameTapped:(id)sender {
    CCLOG(@"New game tapped!");
    [[CCDirector sharedDirector] replaceScene:[CCTransitionRadialCCW transitionWithDuration:1.0 scene:[ActionLayer node]]];
}

- (id)init {
    if (self = [super init]) {
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        [self createSpace];
        [self createGround];
        //[self createBoxAtLocation:ccp(100,100)];
        //[self createBoxAtLocation:ccp(200,200)];
        
        [self scheduleUpdate];
        
        mouse = cpMouseNew(space);
        self.isTouchEnabled = YES;
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"pumpkins.plist"];
        pumpkinBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"pumpkins.png"];
        [self addChild:pumpkinBatchNode];
        
        menuPumpkin1 = [[[CPSprite alloc] initWithSpace:space location:ccp(347, 328) spriteFrameName:@"pumpkin15.png"] autorelease];
        [pumpkinBatchNode addChild:menuPumpkin1];
        
        cpConstraint *pumpkin1 = cpDampedSpringNew(menuPumpkin1.body, ground, ccp(-100,100), ccp(250,700), 100, 5, 1);
        cpSpaceAddConstraint(space, pumpkin1);
        
        CCLabelBMFont *newGame;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            newGame = [CCLabelBMFont labelWithString:@"New Game" fntFile:@"Arial-hd.fnt"];
        } else {
            newGame = [CCLabelBMFont labelWithString:@"New Game" fntFile:@"Arial.fnt"];    
        }
        
        CCMenuItemLabel *newGameItem = [CCMenuItemLabel itemWithLabel:newGame target:self selector:@selector(newGameTapped:)];
        newGameItem.position = ccp(winSize.width * 0.8, winSize.height * 0.3);
        
        CCMenu *menu = [CCMenu menuWithItems:newGameItem, nil];
        menu.position = CGPointZero;
        [self addChild:menu];
        
    }
    return self;
}

@end
