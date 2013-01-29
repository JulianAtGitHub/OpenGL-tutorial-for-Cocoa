#version 330 core

layout (location = 0) in vec3 position_model;

void main() {
    gl_Position = vec4(position_model, 1.0);
}