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
//		File name: CloudNoisePassVS
//		Purpose: Calculate NDC areas

// LAYOUT ATTRIBUTES
layout (location = 0) in vec4 aPos;

// VARYING
out vec2 vTexCoord;

// Main: Set the position and divide the plane into 64 sections
void main()
{
	

	gl_Position = aPos;

	// Calculate the NDC
	vec2 NDCadjusted = aPos.xy * .5 + .4;
	// Multiply the NDC by 8 to get 64 sections
	// This is for getting a random point in each NDC section to make the worley noise
	NDCadjusted *= 8.;
	vTexCoord = NDCadjusted;
}