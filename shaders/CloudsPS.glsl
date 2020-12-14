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
//		File name: CloudsPS
//		Purpose: Calculate the color on the plane by sampling from perlin and worley noise.

// UNIFORMS
uniform sampler2D uTex;
uniform sampler2D uTex2;
uniform float uTime;

// VARYING
in vec4 vTexCoord;

// OUTPUT
out vec4 rtFragColor;

// smoothst: Performs smoothstep manually (no clamp)
float smoothst(float h)
{
	return h * h * (3. - 2. * h);
}

// Main: Samples textures and weights them all togethers
void main()
{
	// Cloud is just a float since it
	float cloud = 0.;
	// Samples from two textures, one of which at different speeds
	vec4 cloudsHorizontal = texture(uTex, vec2(vTexCoord.x, vTexCoord.y - 0.02 * uTime));
	vec4 cloudsShape = texture(uTex2, vec2(vTexCoord.x, vTexCoord.y - 0.04 * uTime));
	
	// The idea of weighted noise comes from Inigo Quilez' 2D dynamic clouds
	//		Link: https://iquilezles.untergrund.net/www/articles/dynclouds/dynclouds.htm
	// x == the lowest res FBM noise, least weight
	cloud += 0.0125 * cloudsHorizontal.x;
	// y == more focused FBM noise, middle weight
	cloud += 0.25 * cloudsHorizontal.y;
	// z == most focused FBM noise, highest level weight
	cloud += 0.50 * cloudsHorizontal.z;
	// r == Worley noise for the shape, middle weight
	cloud += 0.25 * cloudsShape.r;
	
	// Set output color to be a mix of blue and white for the cloud
	// Smoothstep is used for better looking clouds
	rtFragColor = mix(vec4(0.33, 0.61, 0.92, 1.0), vec4(1.0), smoothst(cloud));
}