#version 330 core

uniform mat4 MVP;

layout (location = 0) in vec3 position;
layout (location = 1) in vec2 uv;

out vec2 uv_vs;

void main() {
    gl_Position = MVP * vec4(position, 1.0);
    uv_vs = uv;
}