//
//  EAGLView.m
//  Ch9
//
//  Created by Kyle Roche on 10/24/11.
//  Copyright (c) 2011 2lemetry. All rights reserved.
//

#import "EAGLView.h"
#import <QuartzCore/QuartzCore.h>
#import <QCAR/QCAR.h>
#import <QCAR/CameraDevice.h>
#import <QCAR/Tracker.h>
#import <QCAR/VideoBackgroundConfig.h>
#import <QCAR/Renderer.h>
#import <QCAR/Tool.h>
#import <QCAR/Trackable.h>

#import "Cube.h"

@interface EAGLView (PrivateMethods)
- (void)setFramebuffer;
- (BOOL)presentFramebuffer;
- (void)createFramebuffer;
- (void)deleteFramebuffer;
- (void)updateApplicationStatus:(status)newStatus;
- (void)bumpAppStatus;
- (void)initApplication;
- (void)initQCAR;
- (void)initApplicationAR;
- (void)loadTracker;
- (void)startCamera;
- (void)stopCamera;
- (void)configureVideoBackground;
- (void)initRendering;
@end

@implementation EAGLView

+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)coder
{
    self = [super initWithCoder:coder];
    
	if (self) {
        NSLog(@"Initialising EAGLView");
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        
        eaglLayer.opaque = TRUE;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:FALSE], kEAGLDrawablePropertyRetainedBacking,
                                        kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat,
                                        nil];
        
        context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        QCARFlags = QCAR::GL_20;
        
        NSLog(@"QCAR OpenGL flag: %d", QCARFlags);
        
        if (!context) {
            NSLog(@"Failed to create ES context");
        }
    }
    
    return self;
}

- (void)createFramebuffer
{
	if (context && !defaultFramebuffer) {
        [EAGLContext setCurrentContext:context];
        
        // Create default framebuffer object
        glGenFramebuffers(1, &defaultFramebuffer);
        glBindFramebuffer(GL_FRAMEBUFFER, defaultFramebuffer);
        
        // Create colour render buffer and allocate backing store
        glGenRenderbuffers(1, &colorRenderbuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, colorRenderbuffer);
        
        // Allocate the renderbuffer's storage (shared with the drawable object)
        [context renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer *)self.layer];
        glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &framebufferWidth);
        glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &framebufferHeight);
        
        // Create the depth render buffer and allocate storage
        glGenRenderbuffers(1, &depthRenderbuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, depthRenderbuffer);
        glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, framebufferWidth, framebufferHeight);
        
        // Attach colour and depth render buffers to the frame buffer
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, colorRenderbuffer);
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthRenderbuffer);
        
        // Leave the colour render buffer bound so future rendering operations will act on it
        glBindRenderbuffer(GL_RENDERBUFFER, colorRenderbuffer);
        
        if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) {
            NSLog(@"Failed to make complete framebuffer object %x", glCheckFramebufferStatus(GL_FRAMEBUFFER));
        }
    }
}

- (void)deleteFramebuffer
{
    if (context) {
        [EAGLContext setCurrentContext:context];
		if (defaultFramebuffer) {
            glDeleteFramebuffers(1, &defaultFramebuffer);
            defaultFramebuffer = 0;
        }
        
        if (colorRenderbuffer) {
            glDeleteRenderbuffers(1, &colorRenderbuffer);
            colorRenderbuffer = 0;
        }
        
        if (depthRenderbuffer) {
            glDeleteRenderbuffers(1, &depthRenderbuffer);
            depthRenderbuffer = 0;
        } 
	}
}


- (void)setFramebuffer
{
    if (context) {
        [EAGLContext setCurrentContext:context];
        
        if (!defaultFramebuffer) {
            // Perform on the main thread to ensure safe memory allocation for
            // the shared buffer.  Block until the operation is complete to
            // prevent simultaneous access to the OpenGL context
            [self performSelectorOnMainThread:@selector(createFramebuffer) withObject:self waitUntilDone:YES];
        }
		glBindFramebuffer(GL_FRAMEBUFFER, defaultFramebuffer);
        
	}
}

- (BOOL)presentFramebuffer
{
    BOOL success = FALSE;
    
    if (context) {
        [EAGLContext setCurrentContext:context];
        
        glBindRenderbuffer(GL_RENDERBUFFER, colorRenderbuffer);
        
        success = [context presentRenderbuffer:GL_RENDERBUFFER];
    }
    
    return success;
}

- (void)layoutSubviews
{
    [self deleteFramebuffer];
}

- (void)onCreate
{
    NSLog(@"EAGLView onCreate()");
    appStatus = APPSTATUS_UNINITED;
    [self updateApplicationStatus:APPSTATUS_INIT_APP];
}


- (void)onDestroy
{
    NSLog(@"EAGLView onDestroy()");
    
    // Deinitialise QCAR SDK
    QCAR::deinit();
}


- (void)onResume
{
    NSLog(@"EAGLView onResume()");
    // QCAR-specific resume operation
    QCAR::onResume();
    
    if (APPSTATUS_CAMERA_STOPPED == appStatus) {
        [self updateApplicationStatus:APPSTATUS_CAMERA_RUNNING];
    }
}


- (void)onPause
{
    NSLog(@"EAGLView onPause()");
    // QCAR-specific pause operation
    QCAR::onPause();
    
    if (APPSTATUS_CAMERA_RUNNING == appStatus) {
        [self updateApplicationStatus:APPSTATUS_CAMERA_STOPPED];
    }
}

- (void)updateApplicationStatus:(status)newStatus
{
    if (newStatus != appStatus && APPSTATUS_ERROR != appStatus) {
        appStatus = newStatus;
        
        switch (appStatus) {
            case APPSTATUS_INIT_APP:
                [self initApplication];
                [self updateApplicationStatus:APPSTATUS_INIT_QCAR];
                break;
                
            case APPSTATUS_INIT_QCAR:
                [self performSelectorInBackground:@selector(initQCAR) withObject:nil];
                break;
                
            case APPSTATUS_INIT_APP_AR:
                [self initApplicationAR];
                [self updateApplicationStatus:APPSTATUS_INIT_TRACKER];
                break;
                
            case APPSTATUS_INIT_TRACKER:
                [self performSelectorInBackground:@selector(loadTracker) withObject:nil];
                break;
                
            case APPSTATUS_INITED:
                QCAR::setHint(QCAR::HINT_IMAGE_TARGET_MULTI_FRAME_ENABLED, 1);
                QCAR::setHint(QCAR::HINT_IMAGE_TARGET_MILLISECONDS_PER_MULTI_FRAME, 25);
                [self updateApplicationStatus:APPSTATUS_CAMERA_RUNNING];
                break;
                
            case APPSTATUS_CAMERA_RUNNING:
                [self startCamera];
                break;
                
            case APPSTATUS_CAMERA_STOPPED:
                [self stopCamera];
                break;
                
            default:
                NSLog(@"updateApplicationStatus: invalid app status");
                break;
        }
    }
    
    if (APPSTATUS_ERROR == appStatus) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Application initialisation failed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
    }
}


- (void)bumpAppStatus
{
    [self updateApplicationStatus:(status)(appStatus + 1)];
}

- (void)loadTracker
{
    int nPercentComplete = 0;
    
    // Background thread must have its own autorelease pool
    // Load the tracker data
    do {
        nPercentComplete = QCAR::Tracker::getInstance().load();
    } while (0 <= nPercentComplete && 100 > nPercentComplete);
    
    if (0 > nPercentComplete) {
        appStatus = APPSTATUS_ERROR;
    }
    
    // Continue execution on the main thread
    [self performSelectorOnMainThread:@selector(bumpAppStatus) withObject:nil waitUntilDone:NO];
    
}

- (void)initApplication
{
    screenRect = [[UIScreen mainScreen] bounds];
    
    NSLog(@"Screen rect %@",screenRect);
    
    QCAR::onSurfaceCreated();
    QCAR::onSurfaceChanged(screenRect.size.height, screenRect.size.width);
}

- (void)initQCAR
{
    QCAR::setInitParameters(QCARFlags);
    
    int nPercentComplete = 0;
    
    do {
        nPercentComplete = QCAR::init();
    } while (0 <= nPercentComplete && 100 > nPercentComplete);
    
    NSLog(@"QCAR::init percent: %d", nPercentComplete);
    
    if (0 > nPercentComplete) {
        appStatus = APPSTATUS_ERROR;
    }    
    
    [self performSelectorOnMainThread:@selector(bumpAppStatus) withObject:nil waitUntilDone:NO];  
} 

- (void)initApplicationAR
{
    [self initRendering];
}

- (void)startCamera
{
    NSLog(@"Start Camera!");
    // Initialise the camera
    if (QCAR::CameraDevice::getInstance().init()) {
        // Configure video background
        [self configureVideoBackground];
        
        // Select the default mode
        if (QCAR::CameraDevice::getInstance().selectVideoMode(QCAR::CameraDevice::MODE_DEFAULT)) {
            // Start camera capturing
            if (QCAR::CameraDevice::getInstance().start()) {
                // Start the tracker
                QCAR::Tracker::getInstance().start();
                
                // Cache the projection matrix
                const QCAR::CameraCalibration& cameraCalibration = QCAR::Tracker::getInstance().getCameraCalibration();
                projectionMatrix = QCAR::Tool::getProjectionGL(cameraCalibration, 2.0f, 2000.0f);
                [self onResume];
            }
        }
    }
}


////////////////////////////////////////////////////////////////////////////////
// Stop capturing images from the camera
- (void)stopCamera
{
    QCAR::Tracker::getInstance().stop();
    QCAR::CameraDevice::getInstance().stop();
    QCAR::CameraDevice::getInstance().deinit();
}

- (void)configureVideoBackground
{
    // Get the default video mode
    QCAR::CameraDevice& cameraDevice = QCAR::CameraDevice::getInstance();
    QCAR::VideoMode videoMode = cameraDevice.getVideoMode(QCAR::CameraDevice::MODE_DEFAULT);
    
    // Configure the video background
    QCAR::VideoBackgroundConfig config;
    config.mEnabled = true;
    config.mSynchronous = true;
    config.mPosition.data[0] = 0.0f;
    config.mPosition.data[1] = 0.0f;
    
    // Compare aspect ratios of video and screen.  If they are different
    // we use the full screen size while maintaining the video's aspect
    // ratio, which naturally entails some cropping of the video.
    // Note - screenRect is portrait but videoMode is always landscape,
    // which is why "width" and "height" appear to be reversed.
    float arVideo = (float)videoMode.mWidth / (float)videoMode.mHeight;
    float arScreen = screenRect.size.height / screenRect.size.width;
    
    if (arVideo > arScreen)
    {
        // Video mode is wider than the screen.  We'll crop the left and right edges of the video
        config.mSize.data[0] = (int)screenRect.size.width * arVideo;
        config.mSize.data[1] = (int)screenRect.size.width;
    }
    else
    {
        // Video mode is taller than the screen.  We'll crop the top and bottom edges of the video.
        // Also used when aspect ratios match (no cropping).
        config.mSize.data[0] = (int)screenRect.size.height;
        config.mSize.data[1] = (int)screenRect.size.height / arVideo;
    }
    
    // Set the config
    QCAR::Renderer::getInstance().setVideoBackgroundConfig(config);
}

-(void)loadShaders {
    // Loading shaders for light only
    
    shader = [[GLProgram alloc] initWithVertexShaderFilename:@"SimpleLightShader" fragmentShaderFilename:@"SimpleLightShader"];
    [shader addAttribute:@"a_position"];
    [shader addAttribute:@"a_texCoord"];
    [shader addAttribute:@"a_normal"];
    
    if (![shader link])
	{
        // Compilation failed
		NSLog(@"light shader link failed");
		NSString *progLog = [shader programLog];
		NSLog(@"Program Log: %@", progLog); 
		NSString *fragLog = [shader fragmentShaderLog];
		NSLog(@"Frag Log: %@", fragLog);
		NSString *vertLog = [shader vertexShaderLog];
		NSLog(@"Vert Log: %@", vertLog);
		shader = nil;
	} else {
        NSLog(@"Light Shader compiled successfuly!");
    }
    
    shaderPositionAttribute = [shader attributeIndex:@"a_position"];
    shaderNormalAttribute   = [shader attributeIndex:@"a_normal"];
    shaderColorUniform = [shader uniformIndex:@"a_color"];
    shaderModelViewMatrixUniform = [shader uniformIndex:@"modelViewMatrix"];
    shaderProjectionMatrixUniform = [shader uniformIndex:@"projectionMatrix"];
}

- (void)initRendering
{
    // Define the clear colour
    glClearColor(0.0f, 0.0f, 0.0f, QCAR::requiresAlpha() ? 0.0f : 1.0f);
    
    [self loadShaders];
}

- (void)renderFrameQCAR
{
    [self setFramebuffer];
    
    // Clear colour and depth buffers
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    QCAR::State state = QCAR::Renderer::getInstance().begin();
    
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_CULL_FACE);
    
    for (int i = 0; i < state.getNumActiveTrackables(); ++i) {
        // Get the trackable
        const QCAR::Trackable* trackable = state.getActiveTrackable(i);
        QCAR::Matrix44F modelViewMatrix = QCAR::Tool::convertPose2GLMatrix(trackable->getPose());
    
        [shader use];
        
        float Sash_Kd [] = {0.589414,0.042139,0.042139};
        // Set the sampler texture unit to 0
        glUniformMatrix4fv(shaderProjectionMatrixUniform, 1, 0, &projectionMatrix.data[0]);
        glUniformMatrix4fv(shaderModelViewMatrixUniform, 1, 0, &modelViewMatrix.data[0]);
        glUniform3fv(shaderColorUniform, 1, Sash_Kd);
        
        
        glVertexAttribPointer(shaderPositionAttribute, 3, GL_FLOAT, GL_FALSE, 0, (const GLvoid*)&cubeVertices[0]);
        glVertexAttribPointer(shaderNormalAttribute, 3, GL_FLOAT, GL_FALSE, 0, (const GLvoid*)&cubeNormals[0]);
        
        glEnableVertexAttribArray(shaderPositionAttribute);
        glEnableVertexAttribArray(shaderNormalAttribute);
        
        glDrawElements(GL_TRIANGLES, NUM_CUBE_INDEX, GL_UNSIGNED_SHORT, (const GLvoid*)&cubeIndices[0]);
    }
    
    glDisable(GL_DEPTH_TEST);
    glDisable(GL_CULL_FACE);
    
    QCAR::Renderer::getInstance().end();
    [self presentFramebuffer];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
