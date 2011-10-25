//
//  CPSprite.m
//  Ch8
//
//  Created by Kyle Roche on 10/23/11.
//  Copyright (c) 2011 2lemetry. All rights reserved.
//

#import "CPSprite.h"

@implementation CPSprite
@synthesize body;

- (void)update {    
    self.position = body->p;
    self.rotation = CC_RADIANS_TO_DEGREES(-1 * body->a);
}

- (void)createBoxAtLocation:(CGPoint)location {
    
    float mass = 1.0;
    body = cpBodyNew(mass, cpMomentForBox(mass, self.contentSize.width, self.contentSize.height));
    body->p = location;
    body->data = self;
    cpSpaceAddBody(space, body);
    
    shape = cpBoxShapeNew(body, self.contentSize.width, self.contentSize.height);
    shape->e = 0.3; 
    shape->u = 1.0;
    shape->data = self;
    shape->group = 1;
    cpSpaceAddShape(space, shape);
    
}

- (id)initWithSpace:(cpSpace *)theSpace location:(CGPoint)location spriteFrameName:(NSString *)spriteFrameName {
    
    if ((self = [super initWithSpriteFrameName:spriteFrameName])) {
        
        space = theSpace;
        canBeDestroyed = YES;
        [self createBoxAtLocation:location];
        
    }
    return self;
    
}

- (void)destroy {
    
    if (!canBeDestroyed) return;
    
    cpSpaceRemoveBody(space, body);
    cpSpaceRemoveShape(space, shape);
    [self removeFromParentAndCleanup:YES];
}

@end
