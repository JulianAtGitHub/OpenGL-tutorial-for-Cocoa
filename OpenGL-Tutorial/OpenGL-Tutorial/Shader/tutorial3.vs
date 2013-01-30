#version 330 core

layout (location = 0) in vec3 position_model;

uniform mat4 MVP;

void main() {
    gl_Position = MVP * vec4(position_model, 1.0);
}