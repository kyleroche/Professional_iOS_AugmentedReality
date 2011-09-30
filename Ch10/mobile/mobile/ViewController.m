//
//  ViewController.m
//  mobile
//
//  Created by Kyle Roche on 8/29/11.
//  Copyright (c) 2011 Isidorey. All rights reserved.
//

#import "ViewController.h"
#import "EAGLView.h"

@implementation ViewController

- (void)createProjectionMatrix: (float *)matrix verticalFOV: (float)verticalFOV aspectRatio: (float)aspectRatio nearClip: (float)nearClip farClip: (float)farClip
{
	memset(matrix, 0, sizeof(*matrix) * 16);
	
	float tan = tanf(verticalFOV * M_PI / 360.f);
	
	matrix[0] = 1.f / (tan * aspectRatio);
	matrix[5] = 1.f / tan;
	matrix[10] = (farClip + nearClip) / (nearClip - farClip);
	matrix[11] = -1.f;
	matrix[14] = (2.f * farClip * nearClip) / (nearClip - farClip);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    animating = NO;
    // Creating OpenGL ES Context
    
    EAGLContext *aContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
    
    if (!aContext)
        NSLog(@"Failed to create ES context");
    else if (![EAGLContext setCurrentContext:aContext])
        NSLog(@"Failed to set ES context current");
    
    context = aContext;
    
    EAGLView *eaglView = (EAGLView *)self.view;
    
    [(EAGLView *)self.view setContext:context];
    [(EAGLView *)self.view setFrameBuffer];
    
    int viewport[4] = {0, 0, eaglView.framebufferWidth, eaglView.framebufferHeight};
    viewport[1] = (eaglView.framebufferHeight - viewport[3]) / 2;
    
    glViewport(viewport[0], viewport[1], viewport[2], viewport[3]);
    
    float aspectRatio = viewport[2] / (float)viewport[3];
    
    [self createProjectionMatrix: projectionMatrix verticalFOV: 47.22f aspectRatio: aspectRatio nearClip: 0.1f farClip: 100.f];
    
    // Initialize String
    stringOGL = [[StringOGL alloc] initWithDelegate: self context: aContext frameBuffer:[eaglView defaultFramebuffer] leftHanded: NO];
        
    [stringOGL setProjectionMatrix:projectionMatrix viewport:viewport orientation:[self interfaceOrientation] reorientIPhoneSplash:YES];
    
    // Load image markers
    [stringOGL loadImageMarker: @"bookcover" ofType: @"png"];
    
}

- (void)render
{
    
    [(EAGLView *)self.view setFrameBuffer];
    
    static const GLfloat squareVertices[] = {
        -0.33f, -0.33f,
        0.33f, -0.33f,
        -0.33f,  0.33f,
        0.33f,  0.33f,
    };
    
    static const GLubyte squareColors[] = {
        255, 255,   0, 255,
        0,   255, 255, 255,
        0,     0,   0,   0,
        255,   0, 255, 255,
    };
    
	const int maxMarkerCount = 10;
	struct MarkerInfoMatrixBased markerInfo[10];
	
	int markerCount = [stringOGL getMarkerInfoMatrixBased: markerInfo maxMarkerCount: maxMarkerCount];
    for (int i = 0; i < markerCount; i++)
	{
        glMatrixMode(GL_PROJECTION);
        glLoadMatrixf(projectionMatrix);
        
        glMatrixMode(GL_MODELVIEW);
        glLoadIdentity();
        glMultMatrixf(markerInfo[i].transform);
        
        glVertexPointer(2, GL_FLOAT, 0, squareVertices);
        glEnableClientState(GL_VERTEX_ARRAY);
        glColorPointer(4, GL_UNSIGNED_BYTE, 0, squareColors);
        glEnableClientState(GL_COLOR_ARRAY);
        
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);        
        
    }
}

- (void)startAnimation
{
    if (!animating) {
        [stringOGL resume];
        
        animating = TRUE;
    }
}

- (void)stopAnimation
{
    if (animating) {
        [stringOGL pause];
        animating = FALSE;
    }
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
- (void)viewWillAppear:(BOOL)animated
{
    [self startAnimation];
    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self stopAnimation];
    
    [super viewWillDisappear:animated];
}
- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
