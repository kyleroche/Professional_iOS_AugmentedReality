/*==============================================================================
Copyright (c) 2010-2011 QUALCOMM Austria Research Center GmbH .
All Rights Reserved.
Qualcomm Confidential and Proprietary
			
@file 
    Trackable.h

@brief
    Header file for Trackable class.

==============================================================================*/
#ifndef _QCAR_TRACKABLE_H_
#define _QCAR_TRACKABLE_H_

// Include files
#include <QCAR/NonCopyable.h>
#include <QCAR/Matrices.h>
#include <QCAR/System.h>

namespace QCAR
{

/// Base class for all objects that can be tracked in 6DOF.
/**
 *  A Trackable is an object who's pose can be estimated in six
 *  degrees of freedom (3D, 6DOF). Every Trackable has a name, an id,
 *  a type, a pose and a status (e.g. tracked).
 *  See the TYPE enum for a list of all classes that derive from Trackable.
 */
class QCAR_API Trackable : private NonCopyable
{
public:
    /// Types of Trackables
    enum TYPE {
        UNKNOWN_TYPE,       ///< A trackable of unknown type
        IMAGE_TARGET,       ///< A trackable of ImageTarget type
        MULTI_TARGET,       ///< A trackable of MultiTarget type
        MARKER,             ///< A trackable of Marker type
    };

    /// Status of a Trackables
    enum STATUS {
        UNKNOWN,            ///< The state of the trackable is unknown
        UNDEFINED,          ///< The state of the trackable is not defined
                            ///< (this trackable does not have a state)
        NOT_FOUND,          ///< The trackable was not found
        DETECTED,           ///< The trackable was detected
        TRACKED             ///< The trackable was tracked
    };

    /// Returns the type of 3D object (e.g. MARKER)
    virtual TYPE getType() const = 0;

    /// Returns true if the object is of or derived of the given type
    virtual bool isOfType(TYPE type) const = 0;

    /// Returns the tracking status
    virtual STATUS getStatus() const = 0;

    /// Returns a unique id for all 3D trackable objects
    virtual int getId() const = 0;

    /// Returns the Trackable's name
    virtual const char* getName() const = 0;

    /// Returns the current pose matrix in row-major order
    virtual const Matrix34F& getPose() const = 0;

    virtual ~Trackable()  {}
};

} // namespace QCAR

#endif //_QCAR_TRACKABLE_H_
