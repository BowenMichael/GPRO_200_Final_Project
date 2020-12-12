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
	vec2 i_st = floor(vTexCoord);
	vec2 f_st = fract(vTexCoord);
	
	vec3 color = vec3(1.0);
	
	
	float m_dist = 1.0;
	for(int y = -1; y <= 1; y++)
	{
		for(int x = -1; x <= 1; x++)
		{
			vec2 neighbor = vec2(float(x), float(y));
			vec2 point = random2(i_st + neighbor);
			//point.x = 0.5 + 0.5 * fract(uTime + point.x);
			vec2 diff = neighbor + point - f_st;
			float dist = length(diff);
			m_dist = min(m_dist, dist);
		}
	}
	
	color -= m_dist;
	
	rtFragColor = vec4(color, 1.0);
	//rtFragColor = vec4(fract(vTexCoord), 0.0, 1.0);
}
