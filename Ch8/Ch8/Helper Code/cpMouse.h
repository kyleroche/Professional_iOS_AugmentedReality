/* Copyright (c) 2008 Tommy Thorsen
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#include <stdlib.h>
#import "chipmunk.h"

#ifndef _CHIPMUNK_MOUSE_H_
#define _CHIPMUNK_MOUSE_H_

#ifdef __cplusplus
extern "C" {
#endif
	
#define GRABABLE_MASK_BIT (1<<31)
#define NOT_GRABABLE_MASK (~GRABABLE_MASK_BIT)

	
typedef struct cpMouse {
	cpBody *body;
	cpConstraint *joint1;
	cpConstraint *joint2;
	
	cpSpace *space;
	cpVect moved;
} cpMouse;

cpMouse *cpMouseAlloc();
cpMouse *cpMouseInit(cpMouse *mouse, cpSpace *space);

/**
 *  Create an instance of the mouse interface. This will cause an object
 *  and a shape to be added to your space. The shape has the highest bit
 *  of the "layers" bitfield set, to avoid unwanted collisions. This means
 *  you probably shouldn't use that bit for any of your other shapes
 */
cpMouse *cpMouseNew(cpSpace *space);

void cpMouseDestroy(cpMouse *mouse);

/**
 *  Free the mouse object
 */
void cpMouseFree(cpMouse *mouse);

/**
 *  Updated the position of the mouse object
 *
 *  \param position
 *      The new position in world coordinates
 */
void cpMouseMove(cpMouse *mouse, const cpVect position);

/**
 *  Make the mouse object hold on to a body if it is currently hovering
 *  over one. This causes a pivot joint to be set up between the mouse
 *  body and the selected body.
 *
 *  If the mouse is not hovering over a body, nothing happens.
 *
 *  \param lockAngle
 *      A boolean parameter which should be 1 if you want to keep the
 *      body from rotating as you're holding it, or 0 if you just want
 *      to hold the body with a simple pivot.
 */
void cpMouseGrab(cpMouse *mouse, const cpVect position, const bool lockAngle);

/**
 *  Release any objects grabbed with cpMouseGrab.
 */
void cpMouseRelease(cpMouse *mouse);
	
#ifdef __cplusplus
}
#endif

#endif
