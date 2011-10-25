//
//  EndLayer.m
//  Ch8
//
//  Created by Kyle Roche on 10/24/11.
//  Copyright 2011 2lemetry. All rights reserved.
//

#import "EndLayer.h"
#import "ActionLayer.h"

@implementation EndLayer
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	EndLayer *layer = [EndLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (id)init {
    
    if ((self = [super init])) {
        
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        CCLabelBMFont *titleLabel;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            titleLabel = [CCLabelBMFont labelWithString:@"New Game" fntFile:@"Arial-hd.fnt"];
        } else {
            titleLabel = [CCLabelBMFont labelWithString:@"New Game" fntFile:@"Arial.fnt"];    
        }
        
        CCMenuItemLabel *newGameItem = [CCMenuItemLabel itemWithLabel:titleLabel target:self selector:@selector(playTapped:)];
        newGameItem.position = ccp(winSize.width * 0.8, winSize.height * 0.3);
        
        CCMenu *menu = [CCMenu menuWithItems:newGameItem, nil];
        menu.position = CGPointZero;
        
        [self addChild:menu];
        
    }
    return self;
}


- (void)playTapped:(id)sender {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionRadialCCW transitionWithDuration:1.0 scene:[ActionLayer scene]]];
}

@end
