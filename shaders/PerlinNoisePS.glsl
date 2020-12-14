#version 450
#define PI 3.14159265358979323846

uniform vec2 uRes;
uniform float uTime;
uniform vec2 mousePos;

in vec4 color;
in vec4 vTexCoord;
out vec4 outNoise;


//Aleternitave perlin function: https://gist.github.com/patriciogonzalezvivo/670c22f3966e662d2f83

//Perlin Noise Function from: https://en.wikipedia.org/wiki/Perlin_noise


/* Function to linearly interpolate between a0 and a1
 * Weight w should be in the range [0.0, 1.0]
 */
float interpolate(float a0, float a1, float w) {
    /* // You may want clamping by inserting:
     * if (0.0 > w) return a0;
     * if (1.0 < w) return a1;
     */
    return (a1 - a0) * w + a0;
    /* // Use this cubic interpolation [[Smoothstep]] instead, for a smooth appearance:
     * return (a1 - a0) * (3.0 - w * 2.0) * w * w + a0;
     *
     * // Use [[Smootherstep]] for an even smoother result with a second derivative equal to zero on boundaries:
     * return (a1 - a0) * (x * (w * 6.0 - 15.0) * w * w *w + 10.0) + a0;
     */
}

/* Create random direction vector
 */
vec2 randomGradient(int ix, int iy) {
    // Random float. No precomputed gradients mean this works for any number of grid coordinates
    float random = 2920.f * sin(ix * 21942.f + iy * 171324.f + 8912.f) * cos(ix * 23157.f * iy * 217832.f + 9758.f);
    return vec2 (cos(random),sin(random));
}

// Computes the dot product of the distance and gradient vectors.
float dotGridGradient(int ix, int iy, float x, float y) {
    // Get gradient from integer coordinates
    vec2 gradient = randomGradient(ix, iy);

    // Compute the distance vector
    float dx = x - float(ix);
    float dy = y - float(iy);

    // Compute the dot-product
    return (dx*gradient.x + dy*gradient.y);
}

// Compute Perlin noise at coordinates x, y
float perlin(float x, float y) {
    // Determine grid cell coordinates
    int x0 = int(x);
    int x1 = x0 + 1;
    int y0 = int(y);
    int y1 = y0 + 1;

    // Determine interpolation weights
    // Could also use higher order polynomial/s-curve here
    float sx = x - float(x0);
    float sy = y - float(y0);

    // Interpolate between grid point gradients
    float n0, n1, ix0, ix1, value;

    n0 = dotGridGradient(x0, y0, x, y);
    n1 = dotGridGradient(x1, y0, x, y);
    ix0 = interpolate(n0, n1, sx);

    n0 = dotGridGradient(x0, y1, x, y);
    n1 = dotGridGradient(x1, y1, x, y);
    ix1 = interpolate(n0, n1, sx);

    value = interpolate(ix0, ix1, sy);
    return value;
}

float fbm(in vec2 texCoord, inout float frequency, inout float amplitude, inout float height)
{
	float scale =2;// 5 * (mousePos.y); //Size of the waves
	int seed = 98;
	float lacunarity = 2; //<1
	float persistance = .5; //0-1
	
	vec2 sampleXY = vTexCoord.xy * scale * frequency + seed ;
		 
	 //original
	float perlinValue = perlin(sampleXY.x, sampleXY.y) *.5 +.1 ;
	height += perlinValue * amplitude;
		
	amplitude *= persistance;
	frequency *= lacunarity;
	return height;
}

void main() {
	
	int ocataves = 8; //number of combinations of waves
	float amplitude = 1; //Height of the waves
	float freq = 1; //length of the waves	
	
	float height;
	
	outNoise.x = perlin(vTexCoord.x * 10., vTexCoord.y * 10.) * 2.;
	fbm(vTexCoord.xy, freq, amplitude, height);
	fbm(vTexCoord.xy, freq, amplitude, height);
	outNoise.y = height * 2.;
	fbm(vTexCoord.xy, freq, amplitude, height);
	fbm(vTexCoord.xy, freq, amplitude, height);
	fbm(vTexCoord.xy, freq, amplitude, height);
	fbm(vTexCoord.xy, freq, amplitude, height);
	

	//height = mix(1.0, -1.0, height);
   outNoise.z = height*2;
}