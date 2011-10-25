//
//  CPSprite.h
//  Ch8
//
//  Created by Kyle Roche on 10/23/11.
//  Copyright (c) 2011 2lemetry. All rights reserved.
//

#import "cocos2d.h"
#import "chipmunk.h"

typedef enum {
    kCollisionTypeGround = 0x1,
    kCollisionTypeCat,
    kCollisionTypeBed
} CollisionType;

@interface CPSprite : CCSprite {
    cpBody *body;
    cpShape *shape;
    cpSpace *space;
    BOOL canBeDestroyed;
}

@property (assign) cpBody *body;

- (void)update;
- (void)createBoxAtLocation:(CGPoint)location;
- (id)initWithSpace:(cpSpace *)theSpace location:(CGPoint)location spriteFrameName:(NSString *)spriteFrameName;
- (void)destroy;

@end
