#version 450
//   Copyright 2020 Michael Bowen, Colin Deane
//
//		File name: TerrainPassVS
//		Purpose: Set the vertex positions based on the height from the height map texutre
//				And Calculate the approximate normal for the new vertex position.

//Uniform
uniform mat4 uMatView;
uniform mat4 uMatViewProj;
uniform mat4 uProjMat;
uniform mat4 uMatModel;
uniform float uTime;
uniform sampler2D uTex;
uniform sampler2D uTex1;

//attributes
layout (location = 0) in vec4 aPos;
layout (location = 1) in vec3 aNormal;
layout (location = 2) in vec4 texCoord;

//varying
out vec4 vColor;
out vec4 vNormal;
out vec4 vPosition;
out vec4 vDiffuseColor;
out vec4 vSpecularColor;
out vec4 vTexCoord;
out vec4 vCameraPos;
out mat4 vMat;
out float vHeight;
uniform vec2 mousePos;

//global vars
bool toggleTime = true;

 // http://lolengine.net/blog/2013/09/21/picking-orthogonal-vector-combing-coconuts
  vec3 orthogonal(vec3 v) {
    return normalize(abs(v.x) > abs(v.z) ? vec3(-v.y, v.x, 0.0)
    : vec3(0.0, -v.z, v.y));
  }

vec4 calcNewNormal(vec3 p1, vec3 p2, vec3 p3){
	vec4 newNormal = vec4(cross(p2 - p1, p3 - p1), 0.0);
    return newNormal;
	return normalize(newNormal);
}

void main(){
	 int lod = 1; //level of detail
  	 vec2 res = textureSize(uTex, lod); //height and width of the height map
  	 float sampleSizeX = 1/res.x; //one sample in the x direction
  	 float sampleSizeY = 1/res.y; //one sample in the y direction
  	 vTexCoord = aPos * .5 + .5; //NDC texture coordinates
  	
	//Position Pipeline
	mat4 MVP = uMatModel * uMatViewProj; //Model * Veiw * projection
	//Position to sample the height map 
	float t = 0;
	if(toggleTime){
		t = (uTime * .15 ); //Size of the waves
	}
	vec2 posSample = vec2(vTexCoord.x, vTexCoord.z); //in texture space
	//Distorted Position
	float height = texture(uTex, posSample).z; //z component is for the terrain map
	vec4 pos_camera = uMatModel * uMatView * aPos; //camera space position
	vec4 pos_clip = MVP * aPos; //cliping space position
	//cliping space with height added to the y axis
	vec4 distPos = vec4(pos_clip.x, pos_clip.y + height, pos_clip.z, pos_clip.w); 
	gl_Position = distPos;
	
	//Normal Pipeline
	//Assisted from source: https://www.leadwerks.com/community/topic/16244-calculate-normals-from-heightmap/
	vec4 n = vec4(0.0);
	//Sampling surounding pixels in texture
	float hUp = texture(uTex, vec2(posSample.x, posSample.y + sampleSizeX)).z; 
	float hDn = texture(uTex, vec2(posSample.x, posSample.y - sampleSizeX)).z;  
	float hRt = texture(uTex, vec2(posSample.x + sampleSizeY, posSample.y)).z; 
	float hLt = texture(uTex, vec2(posSample.x - sampleSizeY, posSample.y)).z;
	//calculating horizontal and vertical vectors
	vec3 v = vec3(0, hUp - hDn, 2);
	vec3 h = vec3(2, hRt - hLt, 0);
	//aproximate normal based on plane created by above vectors
	n = vec4(cross(v, h), 1.0);
	vNormal = n;
	//translate normal into camera space
	mat3 normalMat = transpose(inverse(mat3(uMatModel * uMatView)));
	vec3 norm_camera = normalMat * n.xyz;
    vNormal = vec4(norm_camera, 0.0);
	
	//Camera Pipline
    vec4 camera_camera = vec4(0.0);
   
    //Diffuse color
    vec4 diffuseColor = vec4(0.5);
   
    //Specular Color
    vec4 specularColor = vec4(1.0);
       
    //____________________________________
	//PER_FRAGMENT, VIEW_SPACE   
	
	//Varyings
	vPosition = pos_camera;
    vCameraPos = camera_camera;
	vMat = uMatView;
	vHeight = height;
	
	//Colors
   	vDiffuseColor = diffuseColor;
	vSpecularColor = specularColor;
	  	
 }
  	
