#version 450

uniform mat4 uProjMat;
uniform mat4 uViewMat;
uniform mat4 uModelMat;

layout (location = 0 ) in vec4 aPos;

out vec4 vTexCoord;

void main()
{
	gl_Position = uProjMat * uViewMat * uModelMat * aPos;
	vTexCoord = aPos * .5 + .5;
}