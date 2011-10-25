/*==============================================================================
Copyright (c) 2010-2011 QUALCOMM Austria Research Center GmbH .
All Rights Reserved.
Qualcomm Confidential and Proprietary
			
@file 
    CameraDevice.h

@brief
    Header file for CameraDevice class.

==============================================================================*/
#ifndef _QCAR_CAMERADEVICE_H_
#define _QCAR_CAMERADEVICE_H_

// Include files
#include <QCAR/NonCopyable.h>
#include <QCAR/VideoMode.h>

namespace QCAR
{

/// Implements access to the phone's built-in camera
class QCAR_API CameraDevice : private NonCopyable
{
public:
    enum MODE
    {
        MODE_DEFAULT = -1,              ///< Default camera mode
        MODE_OPTIMIZE_SPEED = -2,       ///< Fast camera mode
        MODE_OPTIMIZE_QUALITY = -3      ///< High-quality camera mode
    };

    enum FOCUS_MODE 
    {
        FOCUS_MODE_AUTO,        ///< Default focus mode
        FOCUS_MODE_FIXED,       ///< Fixed focus mode
        FOCUS_MODE_INFINITY,    ///< Focus set to infinity
        FOCUS_MODE_MACRO        ///< Macro mode for close up focus
    };

    /// Returns the CameraDevice singleton instance.
    static CameraDevice& getInstance();

    /// Initializes the camera.
    virtual bool init() = 0;

    /// Deinitializes the camera.
    /**
     *  Any resources created or used so far are released.
     */
    virtual bool deinit() = 0;

    /// Starts the camera. Frames are being delivered.
    /**
     *  Depending on the type of the camera it may be necessary to perform
     *  configuration tasks before it can be started.
     */
    virtual bool start() = 0;

    /// Stops the camera if video feed is not required (e.g. in non-AR mode
    /// of an application).
    virtual bool stop()  = 0;

    /// Returns the number of available video modes.
    /**
     *  This is device specific and can differ between mobile devices or Android
     *  versions.
     */
    virtual int getNumVideoModes() = 0;

    /// Returns the video mode currently selected.
    /**
     *  If no video mode is set then QCAR chooses a video mode.
     */
    virtual VideoMode getVideoMode(int nIndex) = 0;

    /// Chooses a video mode out of the list of modes
    virtual bool selectVideoMode(int index) = 0;

    /**
     * Enable the torch mode on the device if the device supports 
     * this API. 
     * 
     * @param on 
     * 
     * @return bool - True if the device supports this and we were 
     *                able to turn the camera torch on, False
     *                otherwise
     */
    virtual bool setFlashTorchMode(bool on) = 0;

    /**
     * Start the autofocus process.  This method will return false 
     * if autofocus is not supported on the current device or if 
     * autofocus is currently running on the device.  True will be 
     * returned if an autofocus was successfully requested. 
     * 
     * @return bool 
     */
    virtual bool startAutoFocus() = 0;

    /**
     * Stops the autofocus process if it is currently working, 
     * otherwise this is a no-op.  This method returns false if 
     * autofocus is not supported on the current device. 
     * 
     * @return bool 
     */
    virtual bool stopAutoFocus() = 0;

    /**
     * Set the active focus mode.  This method returns false if the 
     * requested focus mode is not supported on this device. 
     * 
     * @param focusMode 
     * 
     * @return bool 
     */
    virtual bool setFocusMode(int focusMode) = 0;
};

} // namespace QCAR

#endif // _QCAR_CAMERADEVICE_H_
