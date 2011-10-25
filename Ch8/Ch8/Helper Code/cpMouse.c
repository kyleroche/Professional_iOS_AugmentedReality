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

#include "cpMouse.h"
#include <stdio.h>

static void mouseUpdateVelocity(cpBody *body, cpVect gravity, cpFloat damping, cpFloat dt) {
    cpMouse *mouse = (cpMouse *)body->data;
	
    /*
     *  Calculate the velocity based on the distance moved since the
     *  last time we calculated velocity. We use a weighted average
     *  of the new velocity and the old velocity to make everything
     *  a bit smoother.
     */
    const cpVect newVelocity = cpvmult(mouse->moved, 1.0f/dt);
	
    body->v = cpvadd(cpvmult(body->v, 0.7f),
                     cpvmult(newVelocity, 0.3f));
	
    mouse->moved = cpvzero;
}

static void mouseUpdatePosition(cpBody *body, cpFloat dt) {
}

cpMouse* cpMouseAlloc() {
    return (cpMouse *)malloc(sizeof(cpMouse));
}

cpMouse* cpMouseInit(cpMouse *mouse, cpSpace *space) {
    mouse->space = space;
    mouse->moved = cpvzero;
	
    mouse->body = cpBodyNew((cpFloat)INFINITY, (cpFloat)INFINITY);
    mouse->body->velocity_func = &mouseUpdateVelocity;
    mouse->body->position_func = &mouseUpdatePosition;
    mouse->body->data = (void*)mouse;
	mouse->body->p = cpvzero;
	mouse->body->v = cpvzero;
	
    mouse->joint1 = NULL;
    mouse->joint2 = NULL;
	
    cpSpaceAddBody(mouse->space, mouse->body);
	
    return mouse;
}

cpMouse* cpMouseNew(cpSpace *space) {
    return cpMouseInit(cpMouseAlloc(), space);
}

void cpMouseDestroy(cpMouse *mouse) {
    cpMouseRelease(mouse);
	
    cpSpaceRemoveBody(mouse->space, mouse->body);
	cpBodyFree(mouse->body);
}

void cpMouseFree(cpMouse *mouse) {
    if (mouse) {
        cpMouseDestroy(mouse);
        free(mouse);
    }
}

void cpMouseMove(cpMouse *mouse, const cpVect position) {
    mouse->moved = cpvadd(mouse->moved, cpvsub(position, mouse->body->p));
    mouse->body->p = position;
}

static cpConstraint* addMouseJoint(cpMouse *mouse, cpBody *body, cpVect offset) {
	cpConstraint *joint = cpPivotJointNew(mouse->body, body, cpvadd(mouse->body->p, offset));
	joint->maxForce = 20000;
//	joint->biasCoef = 0.5f;
	cpSpaceAddConstraint(mouse->space, joint);
	return joint;
}

void cpMouseGrab(cpMouse *mouse, const cpVect position, const bool lockAngle) {
    cpMouseRelease(mouse);
	mouse->body->p = position;
	
	cpShape *shape = cpSpacePointQueryFirst(mouse->space, mouse->body->p, GRABABLE_MASK_BIT, 0);
    if (shape) {
        if (lockAngle) {
            /*
             *  I'd like to just use one joint that would lock the angle
             *  for me, but that doesn't exist yet, so we'll set up two
             *  pivot joints between our bodies
             */
            mouse->joint1 = addMouseJoint(mouse, shape->body, cpv(-5,0));
            mouse->joint2 = addMouseJoint(mouse, shape->body, cpv(5,0));
        } else {
            mouse->joint1 = addMouseJoint(mouse, shape->body, cpvzero);
        }
    }
}

void cpMouseRelease(cpMouse *mouse) {
    if (mouse->joint1) {
		cpSpaceRemoveConstraint(mouse->space, mouse->joint1);
		cpConstraintFree(mouse->joint1);
		mouse->joint1 = NULL;
	}
	if (mouse->joint2) {	
		cpSpaceRemoveConstraint(mouse->space, mouse->joint2);
		cpConstraintFree(mouse->joint2);
		mouse->joint2 = NULL;
	}
}
