#version 450

//Uniforms
uniform mat4 uViewMat;
uniform mat4 uProjMat;
uniform mat4 uViewProjMat;
uniform mat4 uModelMat;

//attribute
layout (location = 0) in vec4 aPosition;
layout (location = 1) in vec3 aNormal;

//varying
out vec4 vColor;
out vec4 vNormal;
out vec4 vPosition;
out vec4 vDiffuseColor;
out vec4 vSpecularColor;
out vec4 vTexCoord;
out vec4 vCameraPosition;
out mat4 vMat;

void main() {
	//POSITION PIPELINE
	mat4 modelViewMat = uModelMat * uViewMat; //Model View Matrix
	vec4 pos_camera = modelViewMat * aPosition; //CameraPosition
	vec4 pos_clip = uModelMat * uViewProjMat * aPosition; //way 1
	gl_Position = pos_clip;

	//Normal Pipeline
	mat3 normalMat = transpose(inverse(mat3(modelViewMat)));
	vec3 norm_camera = normalMat * aNormal;
	//vec3 norm_camera = mat3(modelViewMat) * aNormal; //viewSpace Normal Blue Hue
	vec3 norm_clip = mat3(uProjMat) * norm_camera;
	
	//Camera Pipline
   mat4 modelMatInv = inverse(uModelMat);
   vec4 camera_camera = vec4(0.0);
   vec4 camera_object = modelMatInv * camera_camera;
   
   //Diffuse color
    vec4 diffuseColor = vec4(0.5);
   
   //Specular Color
   vec4 specularColor = vec4(1.0);
   
	//NDC
    vTexCoord = aPosition * .5 + .5;
    
    //____________________________________
//PER_FRAGMENT, VIEW_SPACE   
	
	//Varyings
	vNormal = vec4(norm_camera, 0.0);
	vPosition = pos_camera;
	vCameraPosition = camera_camera;
	vMat = uViewMat;
	
//____________________________________
//PER_FRAGMENT, Object_SPACE 
   
   //Varyings
   //vNormal = vec4(aNormal, 0.0);
   //vPosition = aPosition;
   //vCameraPosition = camera_object;
   //vMat = modelMatInv;

//___________________________________
//COMMON VARYINGS
   	vDiffuseColor = diffuseColor;
	vSpecularColor = specularColor;
}