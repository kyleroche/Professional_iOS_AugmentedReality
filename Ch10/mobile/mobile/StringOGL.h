//
//  StringOGL.h
//  String
//
//  Created by Johan Øverbye on 18.11.10.
//  Copyright 2010 String Labs Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#include "TrackerOutput.h"

#if TARGET_IPHONE_SIMULATOR
#error String does not support the iOS Simulator, as it lacks a camera API. Please build for Device instead.
#endif

@protocol StringOGLDelegate

@required
- (void)render;

@optional
- (void)handleSnapshot: (UIImage *)snapshot;

@end

@class EAGLContext;

#if defined(STRING_OGL_INTERNAL)
@interface StringOGL (Public)
#else
@interface StringOGL : NSObject {}
#endif

// Initialization
- (id)initWithDelegate: (NSObject<StringOGLDelegate> *)delegate 
		context: (EAGLContext *)context 
		frameBuffer: (unsigned)frameBuffer
		leftHanded: (BOOL)leftHanded;

- (void)setProjectionMatrix: (const float *)projectionMatrix 
		viewport: (const int *)viewport 
		orientation: (UIInterfaceOrientation)orientation
		reorientIPhoneSplash: (BOOL)reorientIPhoneSplash;

- (void)setProjectionMatrix: (const float *)projectionMatrix 
		viewport: (const int *)viewport 
		displayOrientation: (unsigned)displayOrientation 
		outputOrientation: (unsigned)outputOrientation
		reorientIPhoneSplash: (BOOL)reorientIPhoneSplash;

- (int)loadImageMarker: (NSString *)filename ofType: (NSString *)ext;
- (void)unloadImageMarkers;

// Flow control
- (unsigned)pause;
- (unsigned)resume;
- (BOOL)isPaused;
- (void)takeSnapshotAndPause;
- (void)enableAR: (BOOL)enable; // Currently for internal use. AR is enabled by default.

// Tracking data
- (unsigned)getMarkerInfoMatrixBased: (struct MarkerInfoMatrixBased *)markerInfo maxMarkerCount: (unsigned)maxMarkerCount;
- (unsigned)getMarkerInfoQuaternionBased: (struct MarkerInfoQuaternionBased *)markerInfo maxMarkerCount: (unsigned)maxMarkerCount;

// Video buffers. Available in Developer, Pro and Campaign builds.
- (void)getCurrentVideoBuffer: (unsigned *)buffer viewToVideoTextureTransform: (float *)viewToVideoTextureTransform;

@end
