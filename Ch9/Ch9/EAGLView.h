//
//  EAGLView.h
//  Ch9
//
//  Created by Kyle Roche on 10/24/11.
//  Copyright (c) 2011 2lemetry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <QCAR/Tool.h>
#import <QCAR/UIGLViewProtocol.h>
#import "GLProgram.h"

typedef enum _status {
    APPSTATUS_UNINITED,
    APPSTATUS_INIT_APP,
    APPSTATUS_INIT_QCAR,
    APPSTATUS_INIT_APP_AR,
    APPSTATUS_INIT_TRACKER,
    APPSTATUS_INITED,
    APPSTATUS_CAMERA_STOPPED,
    APPSTATUS_CAMERA_RUNNING,
    APPSTATUS_ERROR
} status;

@interface EAGLView : UIView <UIGLViewProtocol> {
    EAGLContext *context; // OpenGL Context
    
    // The pixel dimensions of the CAEAGLLayer.
    GLint framebufferWidth;		// Width and height of the buffer
    GLint framebufferHeight;	
    
    // The OpenGL ES names for the framebuffer and renderbuffers used to render
    // to this view.
    GLuint defaultFramebuffer;	//
    GLuint colorRenderbuffer;	// Buffer's handles
    GLuint depthRenderbuffer;	//
    
    // OpenGL projection matrix
    QCAR::Matrix44F projectionMatrix; // Projection matrix to multiply 3d coordinates.
    
    CGRect screenRect; // Size of screen
	int QCARFlags; // Qualcomm AR SDK settings flags
	status appStatus;           // Current app status (See enumeration above)
    
    
    // OpenGL ES 2.0 Shader to render graphics
    
    GLProgram * shader;
    
    GLint shaderPositionAttribute, shaderNormalAttribute, shaderModelViewMatrixUniform, shaderProjectionMatrixUniform, shaderColorUniform;
}

- (void)renderFrameQCAR;
- (void)onCreate;
- (void)onDestroy;
- (void)onResume;
- (void)onPause;
@end