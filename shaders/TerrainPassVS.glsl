#version 450

//Unifrom
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

//varying
out vec4 vNormal;
out vec4 vPosition;
out vec4 vDiffuseColor;
out vec4 vSpecularColor;
out vec4 vTexCoord;
out vec4 vCameraPos;
out mat4 vMat;
out float vHeight;

void main(){

	//Position Pipeline
	vec4 pos_world = uMatModel * aPos;
	vec4 pos_camera = uMatView * pos_world;
	vec4 pos_clip = uMatViewProj * pos_world;
  	gl_Position =  pos_clip;

	//Normal Pipeline
	mat3 normalMat = transpose(inverse(mat3(uMatModel * uMatView)));
	vec3 norm_camera = normalMat * aNormal;
	//vec3 norm_camera = mat3(modelViewMat) * aNormal; //viewSpace Normal Blue Hue
	vec3 norm_clip = mat3(uProjMat) * norm_camera;
	
	//Camera Pipline
   mat4 modelMatInv = inverse(uMatModel);
   vec4 camera_camera = vec4(0.0);
   vec4 camera_object = modelMatInv * camera_camera;
   
   //Diffuse color
    vec4 diffuseColor = vec4(0.5);
   
   //Specular Color
   vec4 specularColor = vec4(1.0);
   
	//NDC
    vTexCoord = aPos * .5 + .5;
    
    //
    vec4 aPosTime = vec4(vTexCoord.x, vTexCoord.y, vTexCoord.z + (uTime * 0.15), vTexCoord.w);
    float height = texture(uTex, aPosTime.xz).z  ;
  	gl_Position = vec4(gl_Position.x, gl_Position.y + height , gl_Position.z, gl_Position.w); // adds the height to the y Position
    
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
	  	
  	
  	
  	//Other Variangs
  	/*if(height > .20)
  	{
  		vColor = mix(vec4(.35, .33, .25, 1.0),vec4(1.0), height);
  	}
  	else
  	{  
  		vColor =  mix(vec4(0.0, 1.0, 0.0, 1.0), vec4(.38, .39, .42, 1.0), height); // texture(uTex,vTexCoord.xy);	
	}
	*/
	vHeight = height;
}
