#version 450
//   Copyright 2020 Michael Bowen, Colin Deane
//
//		File name: PerlinNoisePassVS
//		Purpose: Set up the texCoord NDC

//Uniforms
uniform mat4 uViewMat;
uniform mat4 uViewProjMat;
uniform mat4 uModelMat;

//attribute
layout (location = 0) in vec4 aPos;

//varying
out vec4 vTexCoord;

void main() {
	//Pos Pipeline
	gl_Position = aPos;

	//NDC
    vTexCoord = aPos * .5 + .5;
}