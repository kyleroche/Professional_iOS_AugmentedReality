/*==============================================================================
Copyright (c) 2010-2011 QUALCOMM Austria Research Center GmbH .
All Rights Reserved.
Qualcomm Confidential and Proprietary
			
@file 
    TubeTarget.h

@brief
    Header file for TubeTarget class.

==============================================================================*/
#ifndef _QCAR_TUBETARGET_H_
#define _QCAR_TUBETARGET_H_

// Include files
#include <QCAR/Trackable.h>

namespace QCAR
{

/// A tube
class QCAR_API TubeTarget : public Trackable
{
public:
    /// Returns the radius of the target (in 3D scene units).
    virtual float getRadius() const = 0;

    /// Returns the height of the target (in 3D scene units).
    virtual float getHeight() const = 0;

    /// Returns the arc-length of the target (in 3D scene units).
    virtual float getArcLength() const = 0;
};

} // namespace QCAR

#endif //_QCAR_TUBETARGET_H_
