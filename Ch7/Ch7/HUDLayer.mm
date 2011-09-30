//
//  HUDLayer.mm
//  Ch7
//
//  Created by Kyle Roche on 9/5/11.
//  Copyright (c) 2011 Isidorey. All rights reserved.
//

#import "HUDLayer.h"
//#import "HelloWorldLayer.h"

@implementation HUDLayer

int counter = 0;

- (id)init {
    
    if ((self = [super init])) {
        _counterLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Explosions: %d", counter] fontName:@"Marker Felt" fontSize:24];
        
        // ask director the the window size
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        // position the label on the center of the screen
        _counterLabel.position =  ccp( size.width * 0.85 , size.height * 0.9 );
        
        // add the label as a child to this Layer
        [self addChild: _counterLabel z:10];
      
    }
    return self;
}

- (void)incrementCounter {
   counter++;
    _counterLabel.string = [NSString stringWithFormat:@"Explosions: %d", counter];
}

@end
