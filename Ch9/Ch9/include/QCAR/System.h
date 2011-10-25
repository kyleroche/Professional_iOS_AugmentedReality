/*==============================================================================
Copyright (c) 2010-2011 QUALCOMM Austria Research Center GmbH .
All Rights Reserved.
Qualcomm Confidential and Proprietary
			
@file 
    System.h

@brief
    Definitions of DLL Export MACROS.

==============================================================================*/
#ifndef _QCAR_SYSTEM_H_
#define _QCAR_SYSTEM_H_

// Include files
#if defined(_WIN32_WCE) || defined(WIN32)
#  define QCAR_IS_WINDOWS
#endif


// Define exporting/importing of methods from module
//
#ifdef QCAR_IS_WINDOWS

#  ifdef QCAR_EXPORTS
#    define QCAR_API __declspec(dllexport)
#  elif defined(QCAR_STATIC)
#    define QCAR_API
#  else
#    define QCAR_API __declspec(dllimport)
#  endif

#else // !QCAR_IS_WINDOWS

#  ifdef QCAR_EXPORTS
#    define QCAR_API __attribute__((visibility("default"))) 
#  elif defined(QCAR_STATIC)
#    define QCAR_API
#  else
#    define QCAR_API __attribute__((visibility("default")))
#  endif

#endif


#endif // _QCAR_SYSTEM_H_
