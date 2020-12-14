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
//		File name: CloudsVS
//		Purpose: Put the plane into clip space and calculate NDC

// UNIFORMS
uniform mat4 uProjMat;
uniform mat4 uViewMat;
uniform mat4 uModelMat;

// LAYOUT ATTRIBUTES
layout (location = 0 ) in vec4 aPos;

// VARYING
out vec4 vTexCoord;

// Main: Appropriately calculates position and passes NDC
void main()
{
	// Place the plane into clip space
	gl_Position = uProjMat * uViewMat * uModelMat * aPos;
	// Calculate the NDC
	vTexCoord = aPos * .5 + .5;
}