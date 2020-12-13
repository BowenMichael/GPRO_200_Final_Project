#version 450

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