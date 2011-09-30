//
//  ViewController.h
//  mobile
//
//  Created by Kyle Roche on 8/29/11.
//  Copyright (c) 2011 Isidorey. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import "StringOGL.h"


@interface ViewController : UIViewController <StringOGLDelegate> {
    EAGLContext *context;
    StringOGL *stringOGL;
    float projectionMatrix[16];
    BOOL animating;
}
- (void)startAnimation;
- (void)stopAnimation;

@end
