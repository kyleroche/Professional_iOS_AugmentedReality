//
//  EAGLView.h
//  mobile
//
//  Created by Kyle Roche on 8/29/11.
//  Copyright (c) 2011 Isidorey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

@class EAGLContext;

@interface EAGLView : UIView {
    GLint framebufferWidth;
    GLint framebufferHeight;
    
    GLuint defaultFramebuffer, colorRenderbuffer;
    GLuint depthRenderbuffer;
}

@property (nonatomic, retain) EAGLContext *context;
@property (nonatomic, readonly) GLuint defaultFramebuffer;
@property (nonatomic, readonly) GLint framebufferWidth;
@property (nonatomic, readonly) GLint framebufferHeight;

- (void)setFrameBuffer;
@end

