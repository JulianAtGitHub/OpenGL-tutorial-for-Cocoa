#version 330 core

uniform mat4 MVP;

layout (location = 0) in vec3 position;
layout (location = 1) in vec3 normal;

out vec3 position_vs;
out vec3 normal_vs;

void main() {
    gl_Position = MVP * vec4(position, 1.0);
    position_vs = position;
    normal_vs = normal;
}