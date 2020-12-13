#version 450

uniform sampler2D uTex;
uniform float uTime;

in vec4 vTexCoord;

out vec4 rtFragColor;
void main()
{
	float cloud = 0.;
	vec4 cloudsHorizontal = texture(uTex, vec2(vTexCoord.x + (uTime * .02), vTexCoord.y + (uTime * 0.01)));
	vec4 cloudsHorizontal2 = texture(uTex, vec2(vTexCoord.x + (uTime * .05), vTexCoord.y + (uTime * 0.01)));
	cloud += 0.125 * cloudsHorizontal.x;
	cloud += 0.25 * cloudsHorizontal2.y;
	cloud += 0.25 * cloudsHorizontal.z;
	
	rtFragColor = vec4(cloud);
	rtFragColor = mix(vec4(0.53, 0.81, 0.92, 1.0), vec4(1.0), cloud);
}