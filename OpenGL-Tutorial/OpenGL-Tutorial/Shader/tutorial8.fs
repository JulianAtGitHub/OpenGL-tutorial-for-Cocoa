#version 330 core

uniform vec3 light_direction;
uniform vec3 light_color;
uniform float light_ambient_power;
uniform float light_diffuse_power;
uniform float light_specular_power;
uniform vec3 material_color;
uniform float material_shininess;
uniform vec3 eye_position;

in vec3 position_vs;
in vec3 normal_vs;

out vec4 color_final;

void main() {
    vec3 n = normalize(normal_vs);
    vec3 l = normalize(light_direction);
    float cosTheta = clamp( dot(n, l), 0.0, 1.0 );
    vec3 reflected_color = material_color * light_color;
    vec3 color = reflected_color * light_ambient_power + reflected_color * light_diffuse_power * cosTheta;
    if (cosTheta > 0.0) {
        vec3 e = normalize(eye_position - position_vs);
        vec3 r = normalize(reflect(-l, n));
        float cosAlpha = dot(e, r);
        color += reflected_color * light_specular_power * pow(cosAlpha, material_shininess);
    }
    color_final = vec4(color, 1.0);
}