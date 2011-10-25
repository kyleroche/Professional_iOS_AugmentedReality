/*==============================================================================
Copyright (c) 2010-2011 QUALCOMM Austria Research Center GmbH .
All Rights Reserved.
Qualcomm Confidential and Proprietary
==============================================================================*/

/**
 @file UIGLViewProtocol.h
 
 @brief Header file for UIGLViewProtocol protocol.
        <BR>
        <b>iOS:</b> This header file is specific to the iOS platform.<BR>
 */

#ifndef _UIGLVIEWPROTOCOL_H_
#define _UIGLVIEWPROTOCOL_H_

/**
 UIGLViewProtocol protocol.  The apps's UIView-derived class must conform to
 UIGLViewProtocol to allow QCAR to call the renderFrameQCAR method when it
 wishes to render the current frame.
 <BR>
 <b>iOS:</b> This protocol applies only to the iOS platform.<BR>
 */
@protocol UIGLViewProtocol
/// Called by QCAR to render the current frame
- (void)renderFrameQCAR;
@end

#endif // _UIGLVIEWPROTOCOL_H_
