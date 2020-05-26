#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(binding = 0) uniform UniformBufferObject {
    mat4 model;
    mat4 view;
    mat4 proj;
} ubo;

layout(location = 0) in vec3 inPosition;
layout(location = 1) in vec3 inColor;
layout(location = 2) in vec3 aNormal;

layout(location = 0) out vec3 fragColor;
layout(location = 1) out vec3 Normal;
layout(location = 2) out vec3 fragPos;

void main() {
    vec3 lightPos = vec3(2.0, .0, 2.0);
    vec3 lightCol = vec3(1.0, 1.0, 1.0);
    vec3 viewPos = vec3(2.0, 2.0, 2.0);
    float ambientStrength = 0.2;
    float specularStrength = 0.5;
    gl_Position = ubo.proj * ubo.view * ubo.model * vec4(inPosition, 1.0);
    fragPos = vec3(ubo.model * vec4(inPosition, 1.0));
    // ambient calculation
    vec3 ambient = ambientStrength * lightCol;
    // diffuse calculation
    Normal = aNormal;
    vec3 norm = normalize(Normal);
    vec3 lightDir = normalize(lightPos - fragPos);  
    float diff = max(dot(norm, lightDir), 0.0);
    vec3 diffuse = diff * lightCol;
    // specular calculation
    vec3 viewDir = normalize(viewPos - fragPos);
    vec3 reflectDir = reflect(-lightDir, norm);  
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), 32);
    vec3 specular = specularStrength * spec * lightCol;  
    // final color calculation
    vec3 result = (ambient + diffuse + specular) * inColor;
    fragColor = result;
}