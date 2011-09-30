//
//  HUDLayer.mm
//  Ch13
//
//  Created by Kyle Roche on 9/27/11.
//  Copyright 2011 Isidorey. All rights reserved.
//

#import "HUDLayer.h"

@implementation HUDLayer

- (id)init {
    if ((self = [super init])) {
         
    }
    return self;
}

- (void)loadCrosshair:(NSString *)mood x:(double)x y:(double)y {
    CGSize size = [[CCDirector sharedDirector] winSize];
    
     CCLabelTTF *label = [CCLabelTTF labelWithString:@"test" fontName:@"Marker Felt" fontSize:48];
    // position the label on the center of the screen
    label.position =  ccp( size.width /2 , size.height/2 );
    // add the label as a child to this Layer
    [self addChild: label];
    
    CCSprite *crosshair = [CCSprite spriteWithFile:@"crosshair.png" rect:CGRectMake(0,0,390,390)];
    crosshair.position = ccp((size.width * (x/100)), (size.height * (1 - (y/100))));
    [self addChild:crosshair];		
}
@end
