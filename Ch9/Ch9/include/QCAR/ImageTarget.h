/*==============================================================================
Copyright (c) 2010-2011 QUALCOMM Austria Research Center GmbH .
All Rights Reserved.
Qualcomm Confidential and Proprietary
			
@file 
    ImageTarget.h

@brief
    Header file for ImageTarget class.

==============================================================================*/
#ifndef _QCAR_IMAGETARGET_H_
#define _QCAR_IMAGETARGET_H_

// Include files
#include <QCAR/Trackable.h>
#include <QCAR/Vectors.h>

namespace QCAR
{

// Forward declarations
class Area;
class VirtualButton;

/// A flat natural feature target
class QCAR_API ImageTarget : public Trackable
{
public:
    /// Returns the size (width and height) of the target (in 3D scene units).
    virtual Vec2F getSize() const = 0;

    /// Returns the number of virtual buttons defined for this ImageTarget.
    virtual int getNumVirtualButtons() const = 0;

    /// Provides write access to a specific virtual button.
    virtual VirtualButton* getVirtualButton(int idx) = 0;

    /// Provides read-only access to a specific virtual button.
    virtual const VirtualButton* getVirtualButton(int idx) const = 0;

    /// Returns a virtual button by its name
    /**
     *  Returns NULL if no virtual button with that name
     *  exists in this ImageTarget
     */
    virtual VirtualButton* getVirtualButton(const char* name) = 0;

    /// Returns a virtual button by its name
    /**
     *  Returns NULL if no virtual button with that name
     *  exists in this ImageTarget
     */
    virtual const VirtualButton* getVirtualButton(const char* name) const = 0;

    /// Creates a new virtual button and adds it to the ImageTarget
    virtual VirtualButton* createVirtualButton(const char* name, const Area& area) = 0;

    /// Removes and destroys one of the ImageTarget's virtual buttons
    virtual bool destroyVirtualButton(VirtualButton* button) = 0;
};

} // namespace QCAR

#endif //_QCAR_IMAGETARGET_H_
