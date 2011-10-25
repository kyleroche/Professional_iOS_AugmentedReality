/*==============================================================================
Copyright (c) 2010-2011 QUALCOMM Austria Research Center GmbH .
All Rights Reserved.
Qualcomm Confidential and Proprietary
			
@file 
    Tracker.h

@brief
    Header file for Tracker class.

==============================================================================*/
#ifndef _QCAR_TRACKER_H_
#define _QCAR_TRACKER_H_

// Include files
#include <QCAR/CameraCalibration.h>
#include <QCAR/NonCopyable.h>

namespace QCAR
{

// Forward declarations
class Trackable;

/// Tracker interface
class QCAR_API Tracker : private NonCopyable
{
public:

    /// Enumeration of the different tracker types
    enum TYPE {
        IMAGE_TARGET = 1,   ///< Tracker type tracks ImageTargets and
                            ///< MultiTargets.
        MARKER = 2,         ///< Tracker type tracks marker type targets.
        ALL = 0xffff        ///< Use this to activate all available tracker
                            ///< types.
    };

    /// Provides access to the Tracker singleton
    static Tracker& getInstance();

    /// Starts reading the configuration file and initializes all required
    /// trackers, then advances internal dataset loading state
    /**
     *  Return value is the progress in percent (0-100).
     *
     *  Load can be called more than once per application lifetime.
     *  For all subsequent calls it frees all run-time data not required anymore
     *  and loads new tracking data.
     */
    virtual int load() = 0;

    /// Activates one or more trackers.
    /**
     *  flags takes the value of one or more values of the TYPE enumeration.
     *  Use bitwise or ('|') to combine values.
     *  Returns false if a selected tracker is not available.
     *  Notice: Not every target type has its own tracker type.
     *  and MultiTargets are both tracked via the IMAGE_TARGET tracker.
     */
    virtual bool activate(unsigned int flags) = 0;

    /// Deactivates one or more trackers.
    /**
     *  flags takes the value of one or more values of the TYPE enumeration.
     *  Use bitwise or ('|') to combine values.
     *  Notice: Not every target type has its own tracker type. E.g.
     *  ImageTargets and MultiTargets are both tracked via the IMAGE_TARGET
     *  tracker.
     */
    virtual void deactivate(unsigned int flags) = 0;

    /// Starts the Tracker
    /**
     *  The tracker must have loaded a dataset before it can start. The method
     *  returns false if the start fails (e.g. because no dataset has been loaded
     *  yet). The Tracker needs to be stopped before Trackables can be modified.
     */
    virtual bool start() = 0;

    /// Stops the Tracker
    /**
     *  The Tracker needs to be stopped before Trackables can be modified.
     */
    virtual void stop() = 0;

    /// Provides read-only access to camera calibration data.
    virtual const CameraCalibration& getCameraCalibration() const = 0;

    /// Returns the overall number of 3D trackable objects known to the tracker.
    /**
     *  Trackables that are part of other trackables (e.g. an ImageTarget that
     *  is part of a MultiTarget) is not counted here and not delivered
     *  by Tracker::getTrackable().
     */
    virtual int getNumTrackables() const = 0;
    
    /// Returns a pointer to a trackable object.
    /**
     *  Trackables that are part of other trackables (e.g. an ImageTarget that
     *  is part of a MultiTarget) is not delivered by this method.
     *  Such trackables can be accesses via the trackable they are part of.
     *  E.g. use MultiTarget::getPart() to access the respective ImageTargets.
     */
    virtual Trackable* getTrackable(int idx) const = 0;
    
    /// Returns the number of trackable currently being tracked.
    /**
     *  This data is always up to date and not synced (in contrast to state
     *  objects).
     */
    virtual int getNumActiveTrackables() const = 0;

    /// Provides access to a trackable object currently being tracked.
    /**
     *  This data is always up to date and not synced (in contrast to State
     *  objects). Returns NULL if idx is invalid.
     */
    virtual Trackable* getActiveTrackable(int idx) const = 0;
};

} // namespace QCAR

#endif //_QCAR_TRACKER_H_
