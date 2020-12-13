#version 450

uniform sampler2D uTex;

in vec4 vTexCoord;

out vec4 rtFragColor;
void main()
{
	vec2 coord = vec2(vTexCoord) *.5 + .5;
	rtFragColor = texture(uTex, coord).rrrr;
}
