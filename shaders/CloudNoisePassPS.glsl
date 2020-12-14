#version 450
//   Copyright 2020 Michael Bowen, Colin Deane
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//	   		http://www.apache.org/licenses/LICENSE-2.0
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.
//
//		File name: CloudNoisePassPS
//		Purpose: Calculate Worley noise based on the input region of NDC

// VARYING
in vec2 vTexCoord;

// OUTPUT COLOR
out vec4 rtFragColor;

// random2: calculates a random vector based on input vector
//		Source: https://thebookofshaders.com/12/
vec2 random2(vec2 p)
{
	return fract(sin(vec2(dot(p,vec2(100.,326.7)),dot(p,vec2(465.5,163.3))))*30492.46587);
}

// Main: calculates inverse Worley noise
//		Source: https://thebookofshaders.com/12/
void main()
{
	// Get the region position (a.k.a. which subsection of the NDC the fragment is in)
	vec2 posRegion = floor(vTexCoord);
	// Get the local position (a.k.a. where in the subsection the fragment is in)
	vec2 posLocal = fract(vTexCoord);
	// Set the based color to white
	// This means fragments closer to the scatterred points will be white
	vec3 color = vec3(1.0);

	// Set the min distance
	float minDist = 1.0;
	// Loop through the neighboring cells to find the closest point
	// This is a lot faster than looking through all the points
	for(int y = -1; y <= 1; y++)
	{
		for(int x = -1; x <= 1; x++)
		{
			// Create a region vector using x and y
			vec2 neighbor = vec2(float(x), float(y));
			// Get the random point in that subsection
			
			// Because of how the regions are set up, 
			// this should return the same point for all locations in a subsections
			vec2 point = random2(posRegion + neighbor);
			// Get the difference from the local position 
			vec2 diff = neighbor + point - posLocal;
			// Get the distance squared (faster than getting the distance)
			float dist2 = dot(diff, diff);
			// Still have to find the minimum
			minDist = min(minDist, dist2);
		}
	}

	// Subtract from white by the sqrt of min distance (since the distance is squared in the loop)
	color -= sqrt(minDist);
	// Dim the noise so it doesn't have as much of an effect in the clouds
	color *= 0.5;

	// Set the color, ranges from 0-0.5
	rtFragColor = vec4(color, 1.0);
}