//
//  TrackerOutput.h
//  String
//
//  Created by Johan Øverbye on 25.11.10.
//  Copyright 2010 String Labs Ltd. All rights reserved.
//

#pragma once

struct MarkerInfoQuaternionBased
{
	float 
		orientation[4],
		position[3],
		color[3];
	
	unsigned
		imageID,
		uniqueInstanceID;
};

struct MarkerInfoMatrixBased
{
	float 
		transform[16],
		color[3];
	
	unsigned
		imageID,
		uniqueInstanceID;
};
