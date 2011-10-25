/*==============================================================================
Copyright (c) 2010-2011 QUALCOMM Austria Research Center GmbH .
All Rights Reserved.
Qualcomm Confidential and Proprietary
			
@file 
    MultiTarget.h

@brief
    Header file for MultiTarget class.

==============================================================================*/
#ifndef _QCAR_MULTITARGETHEADERFILE__
#define _QCAR_MULTITARGETHEADERFILE__

// Include files
#include <QCAR/Trackable.h>
#include <QCAR/Matrices.h>
#include <QCAR/Trackable.h>

namespace QCAR
{

// Forward declarations
struct Matrix34F;

/// A set of multiple targets with a fixed spatial relation
/**
 *  Methods to create/destroy or modify a MultiTarget must not be
 *  called while the Tracker is working at the same time. Doing so will make
 *  these methods return false. This means that none of these methods
 *  should be called from the rendering thread.
 *  The suggested way of doing this is during the execution of UpdateCallback,
 *  which guarantees that the Tracker is not working concurrently.
 *  Alternatively the Tracker can be stopped explicitly. However, this is a
 *  very expensive operation.
 */
class QCAR_API MultiTarget : public Trackable
{
public:
    /// Creates a new MultiTarget and registers it at the tracker
    /**
     *  Use MultiTarget::destroy() to destroy the returned MultiTarget
     *  if it is no longer required.
     *  This method must not be called while the tracker is working or it will
     *  return NULL.
     */
    static MultiTarget* create(const char* name);

    /// Destroys a MultiTarget
    /**
     *  This method must not be called while the tracker is working or it will
     *  return false.
     */
    static bool destroy(MultiTarget* MultiTarget);

    /// Returns the number of Trackables that form the MultiTarget.
    virtual int getNumParts() const = 0;

    /// Provides write access to a specific Trackable.
    /**
     *  Returns NULL if the index is invalid.
     */
    virtual Trackable* getPart(int idx) = 0;

    /// Provides read-only access to a specific Trackable.
    /**
     *  Returns NULL if the index is invalid.
     */
    virtual const Trackable* getPart(int idx) const = 0;

    /// Provides write access to a specific Trackable.
    /**
     *  Returns NULL if no Trackable with the given name exists
     *  in the MultiTarget.
     */
    virtual Trackable* getPart(const char* name) = 0;

    /// Provides read-only access to a specific Trackable.
    /**
     *  Returns NULL if no Trackable with the given name exists
     *  in the MultiTarget.
     */
    virtual const Trackable* getPart(const char* name) const = 0;

    /// Adds a Trackable to the MultiTarget.
    /**
     *  Returns the index of the new part on success.
     *  Returns -1 in case of error, e.g. when adding a Part that is already
     *  added or when the Tracker is currently running. Use the returned index
     *  to set the Part's pose via setPartPose().
     */
    virtual int addPart(Trackable* trackable) = 0;

    /// Removes a Trackable from the MultiTarget.
    /**
     *  Returns true on success.
     *  Returns false if the index is invalid or if the Tracker is currently
     *  running.
     */
    virtual bool removePart(int idx) = 0;

    /// Defines a Part's spatial offset to the MultiTarget center
    /**
     *  Per default a new Part has zero offset (no translation, no rotation).
     *  In this case the pose of the Part is identical with the pose of the
     *  MultiTarget. If there is more than one Part in a MultiTarget
     *  then at least one must have an offset, or the Parts are co-located.
     *  Returns false if the index is invalid or the Tracker is currently
     *  running.
     */
    virtual bool setPartOffset(int idx, const Matrix34F& offset) = 0;

    /// Retrieves the spatial offset of a Part to the MultiTarget center
    /**
     *  Returns false if the Part's index is invalid.
     */
    virtual bool getPartOffset(int idx, Matrix34F& offset) const = 0;
};

} // namespace QCAR

#endif //_QCAR_MULTITARGETHEADERFILE__
