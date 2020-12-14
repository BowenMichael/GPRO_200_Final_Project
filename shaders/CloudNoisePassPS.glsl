#version 450

uniform float uTime;

in vec2 vTexCoord;

out vec4 rtFragColor;

vec2 random2(vec2 p)
{
	return fract(sin(vec2(dot(p,vec2(100.,326.7)),dot(p,vec2(465.5,163.3))))*30492.46587);
}

void main()
{
	
	vec2 posRegion = floor(vTexCoord);
	vec2 posLocal = fract(vTexCoord);

	vec3 color = vec3(1.0);


	float minDist = 1.0;
	for(int y = -1; y <= 1; y++)
	{
		for(int x = -1; x <= 1; x++)
		{
			vec2 neighbor = vec2(float(x), float(y));
			vec2 point = random2(posRegion + neighbor);
			vec2 diff = neighbor + point - posLocal;
			float dist2 = dot(diff, diff);
			minDist = min(minDist, dist2);
		}
	}

	color -= sqrt(minDist);
	color *= 0.5;

	rtFragColor = vec4(color, 1.0);
	//rtFragColor = vec4(fract(vTexCoord), 0.0, 1.0);
}