/*==============================================================================
Copyright (c) 2010-2011 QUALCOMM Austria Research Center GmbH .
All Rights Reserved.
Qualcomm Confidential and Proprietary
			
@file 
    VideoBackgroundConfig.h

@brief
    Header file for VideoBackgroundConfig struct.

==============================================================================*/
#ifndef _QCAR_VIDEOBACKGROUNDCONFIG_H_
#define _QCAR_VIDEOBACKGROUNDCONFIG_H_

// Include files
#include <QCAR/Vectors.h>

namespace QCAR
{

/// Video background configuration
struct VideoBackgroundConfig
{
    /// Enables/disables rendering of the video background.
    bool mEnabled;

    /// Enables/disables synchronization of video background and tracking data.
    /**
     *  Depending on the video background rendering mode this may not always be
     *  possible. If deactivated the video background always shows the latest
     *  camera image.
     */
    bool mSynchronous;

    /// Relative position of the video background in the render target in
    /// pixels.
    /**
     *  Describes the offset of the center of video background to the
     *  center of the screen (viewport) in pixels. A value of (0,0) centers the
     *  video background, whereas a value of (-10,15) moves the video background
     *  10 pixels to the left and 15 pixels upwards.
     */
    Vec2I mPosition;

    /// Width and height of the video background in pixels
    /**
     *  Using the device's screen size for this parameter scales the image to
     *  fullscreen. Notice that if the camera's aspect ratio is different than
     *  the screen's aspect ratio this will create a non-uniform stretched
     *  image.
     */
    Vec2I mSize;
};

} // namespace QCAR

#endif //_QCAR_RENDERER_H_
