/*==============================================================================
            Copyright (c) 2010-2011 QUALCOMM Incorporated.
            All Rights Reserved.
            Qualcomm Confidential and Proprietary
            
@file 
    Cube.h

@brief
    Geometry for a cube used in the samples.

==============================================================================*/

#ifndef _QCAR_CUBE_H_
#define _QCAR_CUBE_H_


#define NUM_CUBE_VERTEX 24
#define NUM_CUBE_INDEX 36


static const float cubeVertices[NUM_CUBE_VERTEX * 3] =
{
    -12.00f,  -12.00f,   12.00f, // front
     12.00f,  -12.00f,   12.00f,
     12.00f,   12.00f,   12.00f,
    -12.00f,   12.00f,   12.00f,

    -12.00f,  -12.00f,  -12.00f, // back
     12.00f,  -12.00f,  -12.00f,
     12.00f,   12.00f,  -12.00f,
    -12.00f,   12.00f,  -12.00f,

    -12.00f,  -12.00f,  -12.00f, // left
    -12.00f,  -12.00f,   12.00f,
    -12.00f,   12.00f,   12.00f,
    -12.00f,   12.00f,  -12.00f,

     12.00f,  -12.00f,  -12.00f, // right
     12.00f,  -12.00f,   12.00f,
     12.00f,   12.00f,   12.00f,
     12.00f,   12.00f,  -12.00f,

    -12.00f,   12.00f,   12.00f, // top
     12.00f,   12.00f,   12.00f,
     12.00f,   12.00f,  -12.00f,
    -12.00f,   12.00f,  -12.00f,

    -12.00f,  -12.00f,   12.00f, // bottom
     12.00f,  -12.00f,   12.00f,
     12.00f,  -12.00f,  -12.00f,
    -12.00f,  -12.00f,  -12.00f
};

static const float cubeTexCoords[NUM_CUBE_VERTEX * 2] =
{
    0, 0,
    1, 0,
    1, 1,
    0, 1,

    1, 0,
    0, 0,
    0, 1,
    1, 1,

    0, 0,
    1, 0,
    1, 1,
    0, 1,

    1, 0,
    0, 0,
    0, 1,
    1, 1,

    0, 0,
    1, 0,
    1, 1,
    0, 1,

    1, 0,
    0, 0,
    0, 1,
    1, 1
};

static const float cubeNormals[NUM_CUBE_VERTEX * 3] =
{
    0, 0, 1,
    0, 0, 1,
    0, 0, 1,
    0, 0, 1,

    0, 0, -1,
    0, 0, -1,
    0, 0, -1,
    0, 0, -1,

    0, -1, 0,
    0, -1, 0,
    0, -1, 0,
    0, -1, 0,

    0, 1, 0,
    0, 1, 0,
    0, 1, 0,
    0, 1, 0,

    1, 0, 0,
    1, 0, 0,
    1, 0, 0,
    1, 0, 0,

    -1, 0, 0,
    -1, 0, 0,
    -1, 0, 0,
    -1, 0, 0
};

static const unsigned short cubeIndices[NUM_CUBE_INDEX] =
{
     0,  1,  2,  0,  2,  3, // front
     4,  6,  5,  4,  7,  6, // back
     8,  9, 10,  8, 10, 11, // left
    12, 14, 13, 12, 15, 14, // right
    16, 17, 18, 16, 18, 19, // top
    20, 22, 21, 20, 23, 22  // bottom
};


#endif // _QC_AR_CUBE_H_
