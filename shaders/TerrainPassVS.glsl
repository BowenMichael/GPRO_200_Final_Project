#version 450

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
layout (location = 3) in vec4 vertexTangent;

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
	int lod = 1;
  	vec2 res = textureSize(uTex, lod);
  	float sampleSizeX = 1/res.x;
  	float sampleSizeY = 1/res.y;
  	 vTexCoord = aPos * .5 + .5;
  	
	//Position Pipeline
	mat4 MVP = uMatModel * uMatViewProj;
	//Position to sample the height map 
	vec2 posSample = vec2(vTexCoord.x, vTexCoord.z + (uTime * 0)); //in object space
	//Distorted Position
	float height = texture(uTex, posSample).z;
	vec4 pos_camera = uMatModel * uMatView * aPos;
	vec4 pos_clip = MVP * aPos;
	vec4 distPos = vec4(pos_clip.x, pos_clip.y +height, pos_clip.z, pos_clip.w);
	
	
	gl_Position = distPos;
	
	
	
	
	//Normal Pipeline

	
	float hUp = texture(uTex, vec2(posSample.x, posSample.y + sampleSizeX)).z; 
	float hDn = texture(uTex, vec2(posSample.x, posSample.y - sampleSizeX)).z;  
	float hRt = texture(uTex, vec2(posSample.x + sampleSizeY, posSample.y)).z; 
	float hLt = texture(uTex, vec2(posSample.x - sampleSizeY, posSample.y)).z;
	vec4 n = vec4(0.0);
	vec3 v = vec3(0, hUp - hDn, 2);
	vec3 h = vec3(2, hRt - hLt, 0);
	n = vec4(cross(v, h), 1.0);
	vNormal = vec4(aNormal, 0.0);
	vNormal = n;
	
	
	//translate normal into camera space
	mat3 normalMat = transpose(inverse(mat3(uMatModel * uMatView)));
	vec3 norm_camera = normalMat * n.xyz;
	//vec3 norm_camera = mat3(modelViewMat) * aNormal; //viewSpace Normal Blue Hue
	vec3 norm_clip = mat3(uProjMat) * norm_camera;
	
	//Extra Normal lines
	//vec3 u = vec3(a.x, hUp, a.z + 1);  
  	///vec3 d = vec3(a.x, hDn, a.z - 1);
  	//vec3 r = vec3(a.x + 1,  hRt, a.z);  
  	//vec3 l = vec3(a.x - 1,  hLt, a.z);   
  	//Find normal based on surrounding points   
  	//n += calcNewNormal(a.xyz, u.xyz, d.xyz);
  	//n += calcNewNormal(a.xyz, l.xyz, r.xyz);
  	//n += calcNewNormal(a.xyz, u.xyz, l.xyz);
    //n += calcNewNormal(a.xyz, u.xyz, r.xyz);
  	//n += calcNewNormal(a.xyz, d.xyz, l.xyz);
  	//n += calcNewNormal(a.xyz, d.xyz, r.xyz);
	//n += ;  
  	//n = normalize(vec4(n.x, n.y, n.z, 0.0));
	//n = normalize(vec4(2*(hRt-hLt), 2*(hDn-hUp), -4, 0.0)); 
		//Find surrounding point
	//float tangentFactor = 1.0;
	//distortedPosition = distortedPosition;
    //vec3 tangent1 = orthogonal(aNormal);
    //vec3 tangent2 = normalize(cross(aNormal, tangent1));
    //vec3 nearby1 = aPosTime.xyz + tangent1 * tangentFactor;
    ///vec3 nearby2 = aPosTime.xyz + tangent2 * tangentFactor;
    //vec3 distorted1 = vec3(nearby1.x, 
    					//texture(uTex, vec2(nearby1.x, nearby1.z)).z, 
    					//nearby1.z);
    //vec3 distorted2 = vec3(nearby2.x, 
    					//texture(uTex, vec2(nearby2.x, nearby2.z)).z, 
    					//nearby2.z);
    					
    //vec4 pos_camera2 = uMatModel * uMatView * distortedPosition;
    //gl_Position = uProjMat * pos_camera2;
    //vNormal = vec4(normalize(cross(distorted1 - distortedPosition.xyz, distorted2 - distortedPosition.xyz)), 0.0);

	
	
	//Camera Pipline
   mat4 modelMatInv = inverse(uMatModel);
   vec4 camera_camera = vec4(0.0);
   vec4 camera_object = modelMatInv * camera_camera;
   
   //Diffuse color
    vec4 diffuseColor = vec4(0.5);
   
   //Specular Color
   vec4 specularColor = vec4(1.0);
       
    //____________________________________
	//PER_FRAGMENT, VIEW_SPACE   
	
	//Varyings
	vNormal = vec4(norm_camera, 0.0);
	vPosition = pos_camera;
    vCameraPos = camera_camera;
	vMat = uMatView;
	
	//____________________________________
	//PER_FRAGMENT, Object_SPACE 
   
   //Varyings
   //vNormal = vec4(aNormal, 0.0);
   //vPosition = aPos;
   //vCameraPos = camera_object;
   //vMat = modelMatInv;

//___________________________________
//COMMON VARYINGS
   	vDiffuseColor = diffuseColor;
	vSpecularColor = specularColor;
	  	
  	
  	float grassHeight = .3;
  	float stoneHeight = .6;
  	
  	float weightGrass = 0;
  		float weightStone = 0;
  	//Colors
  	if(height <= stoneHeight){  
  		weightGrass = 1;
  		weightStone = 0;
  		
  	}
  	if(height > grassHeight && height < stoneHeight ){  
  		weightGrass = 0;
  		weightStone = 1;
  		
  	}
  	float weightSnow = 1.0 - weightGrass - weightStone;
  	
  	vColor =  weightGrass * vec4(0.0, 1.0, 0.0, 1.0) + weightStone * vec4(vec3(.5), 1.0) + weightSnow * vec4(1.0); // texture(uTex,vTexCoord.xy);	
  	vHeight = height;
  	//vColor = vNormal;
	//vColor = vec4(n.xyz, 1.0);
}
