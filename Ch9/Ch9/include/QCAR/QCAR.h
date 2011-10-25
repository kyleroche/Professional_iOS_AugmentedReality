/*==============================================================================
Copyright (c) 2010-2011 QUALCOMM Austria Research Center GmbH .
All Rights Reserved.
Qualcomm Confidential and Proprietary
			
@file 
    QCAR.h

@brief
    Header file for global QCAR methods.

==============================================================================*/
#ifndef _QCAR_QCAR_H_
#define _QCAR_QCAR_H_

// Include files
#include <QCAR/System.h>

namespace QCAR
{

// Forward declarations
class UpdateCallback;
class VideoSource;

/// Initialization flags
/**
 *  Use when calling QCAR::init()
 */
enum INIT_FLAGS {
    GL_11 = 1,          ///< Enables OpenGL ES 1.1 rendering
    GL_20 = 2,          ///< Enables OpenGL ES 2.0 rendering
    ROTATE_IOS_90 = 4,  ///< <b>iOS:</b> Rotates rendering 90 degrees
    ROTATE_IOS_180 = 8, ///< <b>iOS:</b> Rotates rendering 180 degrees
    ROTATE_IOS_270 = 16 ///< <b>iOS:</b> Rotates rendering 270 degrees
};

/// Return codes for init() function
enum {
    INIT_ERROR = -1,                            ///< Error during initialization
    INIT_DEVICE_NOT_SUPPORTED = -2,             ///< The device is not supported
    INIT_CANNOT_DOWNLOAD_DEVICE_SETTINGS = -3   ///< The device could not download start-up settings through a network connection.
};


/// Pixel encoding types
enum PIXEL_FORMAT {
    UNKNOWN_FORMAT = 0,         ///< Unknown format - default pixel type for
                                ///< undefined images
    RGB565 = 1,                 ///< A color pixel stored in 2 bytes using 5
                                ///< bits for red, 6 bits for green and 5 bits
                                ///< for blue
    RGB888 = 2,                 ///< A color pixel stored in 3 bytes using
                                ///< 8 bits each
    GRAYSCALE = 4,              ///< A grayscale pixel stored in one byte
    YUV = 8,                    ///< A color pixel stored in 12 or more bits
                                ///< using Y, U and V planes
};


/// Use when calling QCAR::setHint()
enum HINT {
    /// How many image targets to detect and track at the same time
    /**
     *  This hint tells the tracker how many image shall be processed
     *  at most at the same time. E.g. if an app will never require
     *  tracking more than two targets this value should be set to 2.
     *  Default is: 1.
     */
    HINT_MAX_SIMULTANEOUS_IMAGE_TARGETS = 0,

    /// Enables splitting the detection of new image targets over multiple
    /// frames
    /**
     *  This hint tells the tracker that detection of currently untracked
     *  image targets shall be split over multiple frames. The tracker will
     *  therefore require less time per frame but longer to find new targets.
     *  Default value is 0 (no multi-frame detection).
     */
    HINT_IMAGE_TARGET_MULTI_FRAME_ENABLED = 1,

    /// Defines how many milliseconds will be spent on detection and tracking
    /// per frame in multi-frame mode
    /**
     *  Multi-frame mode works time-based: Only as much work is done per frame
     *  as fits into a given time budget. The remaining work is postponed to the
     *  next frame. The number of frames can be limited using
     *  HINT_IMAGE_TARGET_MULTI_FRAME_ENABLED. If this value is set too low,
     *  then no targets might ever be detected. This value is only effective if
     *  multi-frame detection is enabled. Default value is 25 (milliseconds).
     */
    HINT_IMAGE_TARGET_MILLISECONDS_PER_MULTI_FRAME = 2
};


/// Sets QCAR initialization parameters
/**
 Called to set the QCAR initialization parameters prior to calling QCAR::init().
 Refer to the enumeration QCAR::INIT_FLAGS for applicable flags.
 Returns an integer (0 on success).
 <BR>
 <b>ANDROID:</b> Not implemented.<BR>
 <b>iOS:</b> Available for use.<BR>
 */
int QCAR_API setInitParameters(int flags);


/// Initializes QCAR
/**
 Called to initialize QCAR.  Initialization is progressive, so this function
 should be called repeatedly until it returns 100 or a negative value.
 Returns an integer representing the percentage complete (negative on error).
 */
int QCAR_API init();


/// Deinitializes QCAR
void QCAR_API deinit();


/// Loads files required to initialize the tracker
int QCAR_API load();


/// Sets a hint for the QCAR SDK
/**
 *  Hints help the SDK to understand the developer's needs.
 *  However, depending on the device or SDK version the hints
 *  might not be taken into consideration.
 *  Returns false if the hint is unknown or deprecated.
 *  For a boolean value 1 means true and 0 means false.
 */
bool QCAR_API setHint(unsigned int hint, int value);


/// Registers an object to be called when new tracking data is available
void QCAR_API registerCallback(UpdateCallback* object);


/// Enables the delivery of certain pixel formats via the State object
/**
 *  Per default the state object will only contain images in formats
 *  that are required for internal processing, such as gray scale for
 *  tracking. setFrameFormat() can be used to enforce the creation of
 *  images with certain pixel formats. Notice that this might include
 *  additional overhead.
 */
bool QCAR_API setFrameFormat(PIXEL_FORMAT format, bool enabled);


/// Returns the number of bits used to store a single pixel of a given format
/**
 *  Returns 0 if the format is unknown.
 */
int QCAR_API getBitsPerPixel(PIXEL_FORMAT format);


/// Indicates whether the rendering surface needs to support an alpha channel
/// for transparency
bool QCAR_API requiresAlpha();


/// Returns the number of bytes for a buffer with a given size and format
/**
 *  Returns 0 if the format is unknown.
 */
int QCAR_API getBufferSize(int width, int height, PIXEL_FORMAT format);


/// Executes AR-specific tasks upon the onResume activity event
void QCAR_API onResume();


/// Executes AR-specific tasks upon the onResume activity event
void QCAR_API onPause();


/// Executes AR-specific tasks upon the onSurfaceCreated render surface event
void QCAR_API onSurfaceCreated();


/// Executes AR-specific tasks upon the onSurfaceChanged render surface event
void QCAR_API onSurfaceChanged(int width, int height);
} // namespace QCAR

#endif //_QCAR_QCAR_H_
