#version 330 core

uniform mat4 MVP;

layout (location = 0) in vec3 position;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec2 uv;

out vec3 position_vs;
out vec3 normal_vs;
out vec2 uv_vs;

void main() {
    gl_Position = MVP * vec4(position, 1.0);
    position_vs = position;
    normal_vs = normal;
    uv_vs = uv;
}