#version 450

uniform sampler2D uTex;
uniform sampler2D uTex2;
uniform float uTime;

in vec4 vTexCoord;

out vec4 rtFragColor;
void main()
{
	
	float cloud = 0.;
	vec4 cloudsHorizontal = texture(uTex, vec2(vTexCoord.x, vTexCoord.y - 0.02 * uTime));
	vec4 cloudsHorizontal2 = texture(uTex, vec2(vTexCoord.x, vTexCoord.y - 0.01 * uTime));
	vec4 cloudsShape = texture(uTex2, vec2(vTexCoord.x, vTexCoord.y - 0.02 * uTime));
	cloud += 0.0125 * cloudsHorizontal.x;
	cloud += 0.25 * cloudsHorizontal2.y;
	cloud += 0.50 * cloudsHorizontal.z;
	cloud += 0.25 * cloudsShape.r;
	
	rtFragColor = vec4(cloud);
	rtFragColor = mix(vec4(0.33, 0.61, 0.92, 1.0), vec4(1.0), cloud);
}