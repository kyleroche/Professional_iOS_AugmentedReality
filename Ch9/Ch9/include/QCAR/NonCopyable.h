/*==============================================================================
Copyright (c) 2010-2011 QUALCOMM Austria Research Center GmbH .
All Rights Reserved.
Qualcomm Confidential and Proprietary
			
@file 
    NonCopyable.h

@brief
    Header file for NonCopyable class.

==============================================================================*/
#ifndef _QCAR_NONCOPYABLE_H_
#define _QCAR_NONCOPYABLE_H_

// Include files
#include <QCAR/System.h>

namespace QCAR
{

/// Base class for objects that can not be copied
class QCAR_API NonCopyable
{
protected:
    NonCopyable()  {}  ///< Standard constructor
    ~NonCopyable()  {} ///< Standard destructor

private: 
    NonCopyable(const NonCopyable &);             ///< Hidden copy constructor
    NonCopyable& operator= (const NonCopyable &); ///< Hidden assignment operator
};

} // namespace QCAR

#endif //_QCAR_NONCOPYABLE_H_
