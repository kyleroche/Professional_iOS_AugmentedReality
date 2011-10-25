/*==============================================================================
Copyright (c) 2010-2011 QUALCOMM Austria Research Center GmbH .
All Rights Reserved.
Qualcomm Confidential and Proprietary
			
@file 
    VirtualButton.h

@brief
    Header file for VirtualButton class.

==============================================================================*/
#ifndef _QCAR_VIRTUALBUTTON_H_
#define _QCAR_VIRTUALBUTTON_H_

// Include files
#include <QCAR/NonCopyable.h>
#include <QCAR/Vectors.h>

namespace QCAR
{

class Area;


/// A virtual button on a trackable
/**
 *  Methods to create/destroy or modify a VirtualButton must not be
 *  called while the Tracker is working at the same time. Doing so will make
 *  these methods return false. This means that none of these methods
 *  should be called from the rendering thread.
 *  The suggested way of doing this is during the execution of UpdateCallback,
 *  which guarantees that the Tracker is not working concurrently.
 *  Alternatively the Tracker can be stopped explicitly. However, this is a
 *  very expensive operation.
 */
class QCAR_API VirtualButton : private NonCopyable
{
public:
    /// Sensitivity of press detection
    enum SENSITIVITY {
        HIGH,           ///< Fast detection
        MEDIUM,         ///< Balananced between fast and robust
        LOW             ///< Robust detection
    };

    /// Defines a new area for the button area in 3D scene units (the coordinate system is local to the ImageTarget).
    /**
     *  This method must not be called while the tracker is working or it will
     *  return false.
     */
    virtual bool setArea(const Area& area) = 0;

    /// Returns the currently set Area
    virtual const Area& getArea() const = 0;
    
    /// Sets the sensitivity of the virtual button
    /**
     *  Sensitivity allows deciding between fast and robust button press
     *  measurements. This method must not be called while the tracker is
     *  working or it will return false.
     */
    virtual bool setSensitivity(SENSITIVITY sensitivity) = 0;

    /// Enables or disables a virtual button
    /**
     *  This method must not be called while the tracker is working or it will
     *  return false.
     */
    virtual bool setEnabled(bool enabled) = 0;

    /// Returns true if the virtual button is active (updates while tracking).
    virtual bool isEnabled() const = 0;

    /// Returns the name of the button as ASCII string.
    virtual const char* getName() const = 0;

    /// Returns true if the virtual button is pressed.
    virtual bool isPressed() const = 0;

    virtual int getID() const = 0;
};

} // namespace QCAR

#endif //_QCAR_VIRTUALBUTTON_H_
