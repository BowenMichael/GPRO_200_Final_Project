#version 450

layout (location = 0) in vec4 aPos;

out vec2 vTexCoord;

void main()
{
	

	gl_Position = aPos;

	vec2 temp = aPos.xy * .5 + .4;
	temp *= 8.;
	vTexCoord = temp;
}