#version 450

layout (location = 0) in vec4 aPos;

out vec2 vTexCoord;

void main()
{

	gl_Position = aPos;

	vec2 temp = aPos.xy * .5 + .5;
	temp *= 10.;
	vTexCoord = temp;
}
