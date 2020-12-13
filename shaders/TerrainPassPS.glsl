#version 450

//Uniforms
uniform sampler2D uTex;

//varying
in vec4 vNormal;
in vec4 vPosition;
in vec4 vDiffuseColor;
in vec4 vSpecularColor;
in vec4 vTexCoord;
in vec4 vCameraPosition;
in mat4 vMat;
in float vHeight;

//output
out vec4 rtFragColor;

//Global variables
const int maxLights = 1;
float globalAmbientIntensity = .1;
vec4 globalAmbientColor = vec4(1.0);

//Global Structures
struct sLight
{
	vec4 center;
    vec4 color;
    float intensity;
};

void initPointLight(out sLight light, in vec3 center, in vec4 color, in float intensity)
{
  	light.center = vec4(center, 1.0);
    light.color = color;
    light.intensity = intensity;
    
}

//Global Functions
float squareValue(float v){
	return v*v;
}

float lengthSq(vec3 x)
{
    return dot(x, x);
}

float lengthSq(vec4 x)
{
    return dot(x, x);
}

float powerOfTwo (in float base, in int power){
    for(int i = power - 1; i >= 0; --i){
    	base *= base;
    }
	return base;
}

float calcDiffuseI(in sLight light, in vec4 surface, in vec4 surfaceNorm, inout vec4 normLightVec)
{
	vec4 lightVec = light.center - surface;
   float sqLightVecLen = lengthSq(lightVec);
    normLightVec = lightVec * inversesqrt(sqLightVecLen);
   float diffuseCoefficent = max(0.0, (dot(surfaceNorm, normLightVec)));
   float attenuation = (1.0 - sqLightVecLen/squareValue(light.intensity));
   return diffuseCoefficent * attenuation;

}

float calcSpecularI(in sLight light, in vec4 cameraPosition, in vec4 surface, in vec4 surfaceNorm, in vec4 normLightVec ){
   vec4 viewVec = cameraPosition - surface;
   vec4 normViewVec = viewVec * inversesqrt(lengthSq(viewVec));
   vec4 halfWayVec = reflect(-normLightVec, surfaceNorm);//normLightVec + normViewVec; //NOT HALF WAY VECTOR ACTUALLY REFLECTION VECTOR
   vec4 normHalfVec = halfWayVec * inversesqrt(lengthSq(halfWayVec));
   float specCoefficent = max(0.0, dot(surfaceNorm, normHalfVec));
   return powerOfTwo(specCoefficent, 8);
}

vec4 phongReflectance(in sLight light, in vec4 surface, in vec4 surfaceNorm, in vec4 diffuseColor, in vec4 specularColor, in vec4 camera){
	//Diffuse Intensity
   //Function
   vec4 normLightVec;
   float diffuseIntensity = calcDiffuseI(light, surface, surfaceNorm, normLightVec);
   
   //Specular Intensity
   //Function
   float specualarIntensity = calcSpecularI(light, camera, surface, surfaceNorm, normLightVec);
   
   //Final Color Calculation
   return ((diffuseIntensity * diffuseColor + specualarIntensity * specularColor)    * light.color);  
   	
   	//DEBUGGING
   	//return specualarIntensity * specularColor;//Testing Specular Color
}

float smoothst(float h)
{
	return h * h * (3 - 2 * h);
}

float smoothst2(float h)
{
	return smoothst(h) * smoothst(h);
}

float smoothst3(float h)
{
	return smoothst2(h) * smoothst(h);
}
void main() {
	globalAmbientColor = vec4(1.0); //globalAmbientColor to a specific texture
	
	vec4 n = normalize(vNormal); //When vNormal is brought into pixel space the size is changed

   //Lighting init
   sLight lights[maxLights];
   int i = 0;
   initPointLight(lights[0], vec3(0.0, 1.0,  0.0), vec4(1.0), .9);
   //initPointLight(lights[1], vec3(0.0, 5.0,  5.0), vec4(1.0, 0.0, 0.0, 1.0), 5);
   //initPointLight(lights[2], vec3(1.0, 5.0,  5.0), vec4(0.5, 0.5, 1.0, 1.0), 5);


//_______________________________
//PHONG_REFLECTANCE
   
	//Function
	vec4 color = vec4(0.0, 1.0, 0.0, 1.0);
	if(vHeight > .10)
	{
		color = mix(vec4(.45, .43, .35, 1.0), vec4(1.0), smoothst3(vHeight));
	}
	else
	{
		color = mix( vec4(.45, .43, .35, 1.0), vec4(.19, .43, 0.0, 1.0), smoothst2(vHeight / .06));
	}
	
	vec4 phongColor = color;
	for(int i = 0; i < maxLights; i++)
	{
		//Creates a temporary sLight to give a point in the relevat space
		sLight tmp;
		vec4 light_space = vMat * lights[i].center; 
		initPointLight(tmp, light_space.xyz, lights[i].color, lights[i].intensity);
		phongColor += phongReflectance(tmp, vPosition, n, phongColor, vSpecularColor, vCameraPosition);
	}
	phongColor += globalAmbientIntensity * globalAmbientColor;


   //PER_FRAGMENT Render
   rtFragColor = phongColor; 
}